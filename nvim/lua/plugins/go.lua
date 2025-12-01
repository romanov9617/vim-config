return {
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gowork", "gotmpl" },
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },

    opts = {
      lsp_inlay_hints = { enable = true },
      gofmt = "gopls",
      goimports = "gopls",
      lsp_codelens = true,

      golangci_lint = {
        default = "standard",
        config = nil,
        no_config = false,
        severity = vim.diagnostic.severity.HINT,
      },
      null_ls = {
        golangci_lint = {
          method = { "NULL_LS_DIAGNOSTICS_ON_SAVE", "NULL_LS_DIAGNOSTICS_ON_OPEN" },
          severity = vim.diagnostic.severity.INFO,
        },
        gotest = {
          method = { "NULL_LS_DIAGNOSTICS_ON_SAVE" },
          severity = vim.diagnostic.severity.WARN,
        },
      },
      diagnostic = {
        hdlr = false,
        underline = true,
        virtual_text = { spacing = 2, prefix = "" },
        signs = { "", "", "", "" },
        update_in_insert = false,
      },
    },

    config = function(_, opts)
      require("go").setup(opts)
      local util = require("lspconfig.util")

      ----------------------------------------------------------------
      -- Константы и утилиты
      ----------------------------------------------------------------
      local USER_GOLANGCI_CONFIG = vim.fn.expand("~/.golangci.yml")

      local function exists(p)
        return p and vim.uv.fs_stat(p) ~= nil
      end

      local function run_in_root(root, cmd)
        local joined = table.concat(cmd, " ")
        local shell = "cd " .. vim.fn.fnameescape(root) .. " && " .. joined .. " 2>&1"
        local out = vim.fn.systemlist(shell)
        local code = vim.v.shell_error
        return code, out
      end

      local function pick_golangci_config(root)
        local names = {
          ".golangci.yml",
          ".golangci.yaml",
          ".golangci.toml",
          ".golangci.json",
        }
        for _, n in ipairs(names) do
          local p = root .. "/" .. n
          if exists(p) then
            return p
          end
        end
        return USER_GOLANGCI_CONFIG
      end

      local function extract_json(text)
        text = text:gsub("\r", "")
        local cleaned_lines = {}
        for line in text:gmatch("[^\n]+") do
          line = line:gsub("^%s*||%s*", "")
          table.insert(cleaned_lines, line)
        end
        local cleaned = table.concat(cleaned_lines, "\n")
        local json_blob = cleaned:match("{.*}%s*$")
        if not json_blob then
          json_blob = cleaned:match("{.*}")
        end
        return json_blob
      end

      ----------------------------------------------------------------
      -- Авто goimports
      ----------------------------------------------------------------
      local fmtgrp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimports()
        end,
        group = fmtgrp,
      })

      ----------------------------------------------------------------
      -- Авто-root
      ----------------------------------------------------------------
      local rootgrp = vim.api.nvim_create_augroup("GoProjectRoot", {})
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        group = rootgrp,
        pattern = { "*.go", "go.mod", "go.work" },
        callback = function(args)
          local bufpath = vim.fn.fnamemodify(args.file, ":p")
          local root = util.root_pattern("go.work", "go.mod", ".git")(bufpath)
          if root and vim.fn.getcwd() ~= root then
            vim.fn.chdir(root)
          end
        end,
      })

      ----------------------------------------------------------------
      -- GoLintAbs — golangci-lint v2 JSON → quickfix + diagnostics
      ----------------------------------------------------------------
      vim.api.nvim_create_user_command("GoLintAbs", function()
        local bufpath = vim.fn.expand("%:p")
        if bufpath == "" then
          vim.notify("GoLintAbs: пустой путь буфера", vim.log.levels.WARN)
          return
        end
        local work_root = util.root_pattern("go.work")(bufpath)
        local mod_root = util.root_pattern("go.mod", ".git")(bufpath)
        local root = work_root or mod_root or vim.fn.getcwd()

        local cfg = pick_golangci_config(root)
        if not exists(cfg) then
          cfg = nil
        end

        local cmd = {
          "golangci-lint",
          "run",
          "--path-mode",
          "abs",
          "--output.json.path",
          "stdout",
          "--max-issues-per-linter",
          "0",
          "--max-same-issues",
          "0",
          "--uniq-by-line",
        }
        if cfg then
          table.insert(cmd, 2, "--config")
          table.insert(cmd, 3, vim.fn.fnameescape(cfg))
        end

        local code, lines = run_in_root(root, cmd)
        if (code ~= 0 and code ~= 1) and (#lines == 0) then
          vim.notify("GoLintAbs: golangci-lint exit=" .. code, vim.log.levels.ERROR)
          return
        end

        local raw = table.concat(lines or {}, "\n")
        local blob = extract_json(raw)
        if not blob or blob == "" then
          vim.notify("GoLintAbs: не удалось выделить JSON", vim.log.levels.WARN)
          return
        end

        local ok, data = pcall(vim.json.decode, blob)
        if not ok or type(data) ~= "table" or type(data.Issues) ~= "table" then
          vim.notify("GoLintAbs: JSON не распознан", vim.log.levels.WARN)
          return
        end

        local items, by_buf = {}, {}
        local function map_severity(s)
          s = (s or ""):lower()
          if s == "error" then
            return vim.diagnostic.severity.ERROR
          end
          if s == "warning" then
            return vim.diagnostic.severity.WARN
          end
          if s == "info" then
            return vim.diagnostic.severity.INFO
          end
          return vim.diagnostic.severity.HINT
        end

        for _, issue in ipairs(data.Issues) do
          local pos = issue.Pos or {}
          local fname = pos.Filename or pos.File or ""
          local lnum, col = tonumber(pos.Line) or 1, tonumber(pos.Column) or 1
          local ltr, sev = issue.FromLinter or "", (issue.Severity or ""):lower()
          local msg = issue.Text or issue.Message or ""
          if fname ~= "" then
            local text = (ltr ~= "" and ("[" .. ltr .. "] ") or "") .. msg
            table.insert(items, {
              filename = fname,
              lnum = lnum,
              col = col,
              text = text,
              type = (sev == "error") and "E" or (sev == "warning" and "W" or ""),
            })
            -- publish diagnostics
            local bufnr = vim.fn.bufnr(fname, true)
            by_buf[bufnr] = by_buf[bufnr] or {}
            table.insert(by_buf[bufnr], {
              lnum = math.max(0, lnum - 1),
              col = math.max(0, col - 1),
              end_lnum = math.max(0, lnum - 1),
              end_col = math.max(0, col - 1),
              message = text,
              severity = map_severity(issue.Severity),
              source = "golangci-lint",
            })
          end
        end

        if #items == 0 then
          vim.notify("GoLintAbs: проблем не найдено", vim.log.levels.INFO)
          vim.fn.setqflist({}, "r", { items = {} })
          return
        end

        local ns = vim.api.nvim_create_namespace("golangci-lint-v2")
        vim.diagnostic.reset(ns)
        for bufnr, diags in pairs(by_buf) do
          vim.diagnostic.set(ns, bufnr, diags)
        end

        vim.fn.setqflist({}, "r", { title = "golangci-lint", items = items })
        vim.cmd("copen")
        vim.cmd("cc 1")
      end, { desc = "golangci-lint v2 JSON → quickfix + diagnostics (repo/user config)" })

      ----------------------------------------------------------------
      -- Клавиши
      ----------------------------------------------------------------
      vim.api.nvim_create_user_command("GoLintWork", function()
        vim.cmd("GoLintAbs")
      end, {})

      vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { desc = "Quickfix next" })
      vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { desc = "Quickfix prev" })

      -- всплывающее описание всех диагностик строки
      vim.keymap.set("n", "<leader>de", function()
        vim.diagnostic.open_float(nil, {
          scope = "line",
          source = "if_many",
          border = "rounded",
          focusable = false,
        })
      end, { desc = "Diagnostics (line)" })
    end,

    event = { "CmdlineEnter" },
    build = ':lua require("go.install").update_all_sync()',
  },
}

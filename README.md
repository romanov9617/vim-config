# Neovim конфигурация на LazyVim

Персональная сборка Neovim, построенная на базе LazyVim и адаптированная под Go, Python, Rust и работу с заметками Obsidian. Конфигурация включает готовые плагины, преднастроенные LSP/форматтеры и удобные горячие клавиши.

## Установка
1. Убедитесь, что установлены **Neovim 0.9+**, `git` и инструменты, требуемые языковыми серверами (Go toolchain, Python + venv/poetry, Rust toolchain, Node.js для некоторых утилит).
2. Сохраните текущий `~/.config/nvim`, если он есть: `mv ~/.config/nvim ~/.config/nvim.backup`.
3. Клонируйте репозиторий в любую директорию, например:
   ```bash
   git clone <repo-url> ~/vim-config
   ```
4. Подключите конфигурацию к Neovim, создав ссылку или скопировав каталог `nvim` из репозитория в `~/.config/nvim`, например:
   ```bash
   ln -s ~/vim-config/nvim ~/.config/nvim
   # или скопируйте содержимое
   # cp -r ~/vim-config/nvim ~/.config/nvim
   ```
   Если при слиянии веток возникли конфликты по файлам конфигурации, выбирайте версию из каталога `nvim` в корне репозитория — именно она актуальна и поддерживает настройки, описанные в этом README.
5. Запустите `nvim`. Lazy.nvim автоматически установит плагины. При необходимости выполните `:Lazy sync` для синхронизации и `:Mason` для установки нужных LSP/линтеров/форматтеров.
6. Для Go убедитесь, что `golangci-lint` и `gotestsum` доступны в `$PATH`; для Python отладки требуется `debugpy`, для Markdown предпросмотра — `markdown-preview.nvim` соберётся автоматически.

## Плагины
Полный список фиксирован в `nvim/lazy-lock.json` и включает:
- Ядро: LazyVim, lazy.nvim, which-key.nvim, Snacks, mini.*.
- Интерфейс: bufferline.nvim, lualine.nvim, catppuccin, tokyonight.nvim, nvim-web-devicons, noice.nvim, flash.nvim.
- Поиск/навигатор: telescope.nvim, grug-far.nvim.
- LSP/автодополнение: nvim-lspconfig, mason.nvim (+ mason-lspconfig), nvim-cmp и blink.cmp, lazydev.nvim, SchemaStore.nvim, omnisharp-extended-lsp.
- Treesitter: nvim-treesitter (+ textobjects, ts-autotag, ts-comments).
- Форматирование/линтинг: conform.nvim, nvim-lint, todo-comments.nvim.
- Git: gitsigns.nvim, vim-fugitive.
- Языки: go.nvim (+ guihua.lua), rustaceanvim, crates.nvim, neotest (ядро, neotest-golang, neotest-python), nvim-dap, nvim-dap-go, nvim-dap-python, venv-selector.nvim, render-markdown.nvim.
- Документы/Markdown/ноуты: obsidian.nvim, markdown-preview.nvim, trouble.nvim.
- Утилиты: Comment.nvim, FixCursorHold.nvim, plenary.nvim, persistence.nvim, sqlua.nvim, vim-wakatime.
Полный перечень с ветками и коммитами смотрите в `nvim/lazy-lock.json`.

## Горячие клавиши
- **LSP/диагностика**: `gd` — переход к определению через Telescope; `gr` — поиск ссылок; `<leader>de` — всплывающее окно диагностик строки; `<leader>dv` — вкл/выкл виртуальный текст.
- **Go**: `<leader>gfs` (GoFillStruct), `<leader>gfp` (GoFixPlurals), `<leader>gfe` (GoIfErr), `<leader>gc` (GoCmt), `<leader>ta` (GoAddTag), `<leader>td` (GoRmTag). Плагин автоматически выполняет `goimports` при сохранении и подхватывает корень проекта.
- **Git (vim-fugitive)**: `<leader>gs` — `:Git status`; `<leader>gd` — `:Gdiffsplit`.
- **Trouble**: `<leader>xx` — диагностика проекта справа; `<leader>xb` — диагностика текущего файла; `<leader>xq` — quickfix; `<leader>xl` — loclist; `gR` — LSP references; `<leader>xs` — символы документа.
- **Тесты (neotest)**: `<leader>tt` — ближайший тест; `<leader>tf` — тесты файла; `<leader>ts` — окно summary; `<leader>to` — вывод; `<leader>tp` — панель вывода; `<leader>tl` — повторить последний; `<leader>td` — отладка ближайшего через DAP.
- **Python DAP**: `<leader>dd` — продолжить; `<leader>db` — breakpoint; `<leader>dO` — step over; `<leader>di` — step into; `<leader>do` — step out.
- **Obsidian**: `<leader>oo` — быстрый переход; `<leader>on` — новая заметка; `<leader>os` — поиск; `<leader>ot` — дневная заметка.

## Дополнительно
- Плагин `ray-x/go.nvim` сейчас совместим только с веткой `master` `nvim-treesitter`; именно она указана в конфигурации. Для корректной работы Python, Rust и других LSP рекомендуется использовать ветку `main` upstream `nvim-treesitter`.
- Деревья синтаксиса устанавливаются для Python, Go, Rust, Lua, Vim, Bash, HTML, CSS, JSON и SQL; автодобстановка форматирования включает Ruff для Python, rustfmt для Rust и prettier для JSON.

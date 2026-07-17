# Neovim Setup Todo List

## Conventions
- `[x]` — done
- `[-]` — partial / needs review
- `[ ]` — not started

---

## 0. Architecture & Foundation

- [x] Architecture document (`documentation/architecture.md`)
- [x] LSP architecture doc (`documentation/lsp_architecture.md`)
- [x] `lua/settings.lua` — central settings
- [x] `lua/lazy_plugin_manager.lua` — Lazy bootstrap
- [ ] Implement `lua/language_settings.lua` — module loader with pcall + logging
- [ ] Implement `lua/core/` directory — move options, keybinds, autocommands from root
- [ ] Implement `lua/ui/` directory — move statusline, theme, cursor_mode
- [ ] Unify cursor strategy — resolve guicursor vs cursor_mode.lua conflict
- [ ] Implement error log to `stdpath("data")/language_settings.log`

## 1. Language Server Protocol (LSP)

- [-] Architecture understood (0.11+ `vim.lsp.config` + `vim.lsp.enable` API)
- [x] `lua/plugins/nvim-lspconfig.lua` installed
- [x] `lua/plugins/mason.lua` installed
- [ ] Create `lua/languages/` directory with per-language data modules:
  - [ ] `python.lua` — basedpyright + ruff
  - [ ] `rust.lua` — rust_analyzer
  - [ ] `cpp.lua` — clangd
  - [ ] `lua.lua` — lua_ls
  - [ ] `bash.lua` — bash-language-server
  - [ ] `nix.lua` — nixd
  - [ ] `fish.lua` — fish-lsp
  - [ ] `markdown.lua` — marksman / markdown_oxide
  - [ ] `toml.lua` — taplo
  - [ ] `yaml.lua` — yaml-language-server
  - [ ] `haskell.lua` — haskell-language-server
  - [ ] `clojure.lua` — clojure-lsp
- [ ] Configure LSP keybinds in `core/keybinds.lua` or `LspAttach` autocmd
  - [ ] `gd` — go to definition
  - [ ] `gr` — go to references
  - [ ] `K` — hover
  - [ ] `<leader>rn` — rename
  - [ ] `<leader>ca` — code action
- [ ] Remove hardcoded `vim.lsp.enable` calls from `init.lua`

## 2. Treesitter & Highlighting

- [ ] Install `nvim-treesitter/nvim-treesitter`
- [ ] Install `nvim-treesitter/nvim-treesitter-textobjects`
- [ ] List `ensure_installed` parsers
- [ ] Enable highlighting, indentation, folding

## 3. Navigation & Searching

- [ ] Install fuzzy finder:
  - [ ] `nvim-telescope/telescope.nvim` (current plan)
  - [ ] or `ibhagwan/fzf-lua`
  - [ ] or `alexpasmantier/tv.nvim` (future)
- [ ] Configure search keybinds:
  - [ ] `<leader>ff` — find files
  - [ ] `<leader>fg` — live grep
  - [ ] `<leader>fb` — buffers
  - [ ] `<leader>fk` — keymaps
  - [ ] `<leader>f:'"` — marks
  - [ ] `<leader>fr'` — registers
  - [ ] `<leader>fs` — search current symbol
- [ ] Install file explorer:
  - [ ] `stevearc/oil.nvim` (recommended)
  - [ ] or `nvim-neo-tree/neo-tree.nvim`
  - [ ] or `yazi.nvim` (wrapper around yazi)

## 4. Keybindings & Options

- [x] Basic options in `lua/core/options.lua`
- [x] Basic keybinds in `lua/core/keybinds.lua`
- [ ] Window/split navigation:
  - [ ] `<C-h/j/k/l>` — navigate splits
  - [ ] `<leader>wv` — vertical split
  - [ ] `<leader>ws` — horizontal split
  - [ ] `<leader>wq` — close window
- [ ] Tab/buffer navigation:
  - [ ] `[b` / `]b` — previous/next buffer
  - [ ] `<leader>bd` — close buffer
  - [ ] `<leader>bl` — list buffers
- [ ] Terminal toggles:
  - [ ] `<leader>tt` — toggle floating terminal
  - [ ] `<leader>th` — toggle horizontal terminal

## 5. Editor Quality of Life

- [ ] `lewis6991/gitsigns.nvim` — git gutters, hunks, blame
- [ ] `stevearc/conform.nvim` — auto-formatting on save
- [ ] `mfussenegger/nvim-lint` — real-time linting
- [ ] `tpope/vim-sleuth` — auto-detect indent settings
- [ ] `lukas-reineke/indent-blankline.nvim` — vertical indent guides
- [ ] `windwp/nvim-autopairs` — auto-close brackets (installed)

## 6. UI & Themes

- [x] Colorscheme plugins: oxocarbon, tokyodark, carbonfox installed
- [x] Colorscheme selection via `lua/settings.lua`
- [-] Transparent background (works, needs Neovide color sync fix)
- [x] Statusline: lualine with dynamic theme
- [x] Notifications: fidget.nvim installed
- [ ] Implement `lua/ui/cursor_mode.lua` — dynamic cursor by mode
- [ ] Unify cursor strategy (guicursor in options.lua vs cursor_mode.lua)
- [ ] Bufferline / tabline (optional)

## 7. Note-Taking System

User wants to evaluate and pick one:

- [ ] `epwalsh/obsidian.nvim` — syncs with Obsidian app
- [ ] `nvim-orgmode/orgmode` — full Org mode experience
- [ ] `nvim-neorg/neorg` — Neovim-native structured notes
- [ ] Markdown Oxide — LSP-native, experimental
- [ ] `chomosuke/typst-preview.nvim` (if using Typst)
- Phase 2: Integrate chosen backend into `lua/notes/` router

## 8. External Tool Integrations

- [ ] **neovim-remote**: Set up `nvr` as `$EDITOR` for git, direnv, etc.
- [ ] **direnv**: Hook `.envrc` loading into LSP root detection
- [ ] **VSCode**: Create `lua/integrations/vscode.lua` compatibility layer

## 9. Debugging (DAP)

- [ ] `mfussenegger/nvim-dap`
- [ ] `rcarriga/nvim-dap-ui`
- [ ] Language-specific adapters (debugpy, lldb, etc.)

## 10. Terminal

- [ ] `akinsho/toggleterm.nvim` — floating/horizontal terminal
- [ ] Auto-open terminal in project root
- [ ] Terminal keybinds

## 11. Neovide

- [x] Font, opacity, padding, cursor effects
- [ ] `neovide_background_color` sync with colorscheme
- [ ] Ensure GUI-only plugins don't load in headless

## 12. Performance & Headless

- [ ] Audit plugin loading — ensure `lazy = true` everywhere possible
- [ ] Add `vim.fn.has("gui_running")` guards in GUI-only plugin specs
- [ ] Verify `--headless` starts without errors
- [ ] Profile startup time: `vim.cmd("profile start")`

## Long-Term Migrations

- [ ] Lazy.nvim → LZE.nvim (keep same `lua/plugins/*.lua` files)
- [ ] LZE + Mason → Nix home-manager modules
- [ ] Telescope → tv.nvim (evaluate when television matures)
- [ ] lualine → heirline (if more customization is needed)
- [ ] netrw → oil.nvim / yazi.nvim

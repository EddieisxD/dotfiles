# Neovim Setup Todo List

This checklist tracks the missing features and configurations needed to build out a robust, IDE-like Neovim setup.

##   1. Language Server Protocol (LSP)
- [ ] Setup LSP Client (`neovim/nvim-lspconfig`)
- [ ] Install LSP Package Manager (`williamboman/mason.nvim` and `williamboman/mason-lspconfig.nvim`)
- [ ] Configure keybinds for LSP actions (definition, references, rename, code actions, hover)

##   2. Treesitter & Highlighting
- [ ] Configure `nvim-treesitter` (parser installation, highlights)
- [ ] Enable Treesitter-based indentation & folding
- [ ] Configure `ensure_installed` list of parsers (e.g., lua, python, markdown, etc.)

##   3. Navigation & Searching
- [ ] Install a Fuzzy Finder (`nvim-telescope/telescope.nvim` or `ibhagwan/fzf-lua`)
- [ ] Configure search keybinds (find files, live grep, buffers, keymaps)
- [ ] Install a modern File Explorer (`stevearc/oil.nvim` or `nvim-neo-tree/neo-tree.nvim`)

##   4. Keybindings & Options
- [ ] Define window/split navigation hotkeys (e.g., `<C-h/j/k/l>`)
- [ ] Define tab/buffer navigation hotkeys
- [ ] Map terminal toggles and buffer closing shortcuts

##   5. Quality of Life & Developer Utilities
- [ ] Configure Git gutters/diffs (`lewis6991/gitsigns.nvim`)
- [ ] Configure code auto-formatting (`stevearc/conform.nvim`)
- [ ] Configure code linting (`mfussenegger/nvim-lint`)
- [ ] Configure automatic indentation detection (`tpope/vim-sleuth`)
- [ ] Add vertical indentation guides (`lukas-reineke/indent-blankline.nvim`)

##   6. UI & Themes
- [ ] Install a modern colorscheme (e.g., `tokyonight`, `catppuccin`, or `gruvbox`)
- [ ] Set installed colorscheme in `lazy_plugin_manager.lua`
- [ ] Verify transparency compatibility in `transparent_nvim.lua`

##   7. Terminal & Debugging (Optional)
- [ ] Configure floating/toggleable terminal window (`akinsho/toggleterm.nvim`)
- [ ] Install debugger client & UI (`nvim-dap` & `nvim-dap-ui`)

---

## Migrations
- [ ] lualine -> heirline
- [ ] telescope -> tv.nvim
- [ ] newtr -> oil.nvim / snacks.nvim / yazi.nvim
- [ ] obsidian.nvim -> logseq-mode.nvim





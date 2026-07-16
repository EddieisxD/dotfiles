vim.g.netrw_banner = 0

--- Indentations
vim.o.tabstop = 4      -- Width of a tab character (display width)
vim.o.softtabstop = 4  -- How many spaces Tab key inserts
vim.o.shiftwidth = 4   -- How many spaces >> and << indent
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.autoindent = true

-- # use vim-sleuth for automatic indentation detection
-- # use nvim-treesitter and nvim-treesitter-textobjects for this automatic indentation

--- Wrap
vim.o.wrap = true
vim.o.linebreak = true
vim.o.textwidth = 0

--- Gutter
vim.wo.number = true;
vim.wo.relativenumber = true;
vim.wo.numberwidth = 2    -- Minimum width of the number column
vim.wo.signcolumn = "yes" -- Always show sign column ("yes", "auto", "no")
vim.wo.foldcolumn = "1"   -- Show a fold column ("0" to "9", or "auto")

vim.o.formatoptions = "jcroql"  -- Vim default

--- Mouse and Gestures
vim.o.mouse = "a"          -- Enable mouse in all modes
vim.o.mousemodel = "popup" -- Right-click shows popup menu
vim.o.mousefocus = true    -- Focus follows mouse (terminal-dependent)

--- swap files
vim.o.swapfile = false    -- Enable swap files (default)
vim.o.directory = "/tmp/neovim/"  -- Where to store swap files

vim.o.backup = false      -- Don't create ~filename~ backup files
vim.o.writebackup = false -- Don't backup before writing
vim.o.backupdir = "/tmp/neovim/"  -- Where to store backups (if enabled)

vim.o.undofile = true     -- Save undo history to disk
vim.o.undodir = "/tmp/neovim/"    -- Where to store undo files

--- Clipboard
vim.opt.clipboard:append('unnamedplus')

--- UI and Appearance
vim.o.termguicolors = true -- Enable true color (24-bit color)
vim.o.background = "dark"  -- Hint to colorschemes ("light" or "dark")
vim.o.showmode = false      -- Don't show --INSERT-- in status line
vim.o.cmdheight = 1        -- Height of the command line
vim.o.pumheight = 10       -- Max height of popup menu (completions)
vim.o.pumblend = 10        -- Transparency of popup menus
vim.opt.laststatus = 3

--- Window management
vim.o.splitbelow = true          -- :split opens below current window
vim.o.splitright = true          -- :vsplit opens to the right
vim.o.equalalways = true         -- Resize splits equally
vim.o.winminwidth = 10           -- Minimum width for a window
vim.o.winminheight = 1           -- Minimum height for a window

--- cursor style
vim.o.guicursor = ""
vim.opt.guicursor:append("n-v-c:block-CursorNormal")
vim.opt.guicursor:append("i-ci-ve:block-CursorBlue")
vim.opt.guicursor:append("r-cr:hor20,o:hor50")
vim.api.nvim_set_hl(0, "CursorNormal", { fg = "#000000", bg = "#FAFAFA" }) -- Blue block for Normal
vim.api.nvim_set_hl(0, "CursorBlue",   { fg = "#000000", bg = "#B8CC52" }) -- Green line for Insert

--- Search
vim.o.hlsearch = true          -- Highlight all search matches
vim.o.incsearch = true         -- Show matches as you type
vim.o.ignorecase = true        -- Case-insensitive search
vim.o.smartcase = true         -- If search has uppercase, override ignorecase
vim.opt.inccommand = "split"   -- splits in a new window when search and replacing

--- Motion and Scrolling
vim.o.scrolloff = 8            -- Keep 8 lines visible above/below cursor
vim.o.sidescrolloff = 8        -- Keep 8 columns visible left/right of cursor
vim.o.timeoutlen = 500         -- Max time (ms) to wait between keys of a mapped sequence like gd
vim.o.ttimeoutlen = 0          -- Timeout for terminal key codes (0 = instant, no delay on <Esc>)
vim.o.updatetime = 250         -- CursorHold event interval in ms. LSP diagnostics, git signs
vim.o.hidden = true            -- Allow switching buffers without saving first

--- Spell Check
vim.o.spell = false              -- Enable spell check
vim.o.spelllang = "en_us"       -- Language(s) to check. Can be list: {"en_us", "de_de"}
vim.opt.spelloptions:append("camel")  -- Check camelCase words as well

--- Completions
vim.opt.completeopt = "menu,noselect,fuzzy"

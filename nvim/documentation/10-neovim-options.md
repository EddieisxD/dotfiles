# Neovim Options: A Practical Reference

This tutorial covers the Neovim options you'll use most often, organized by
topic. Options are set with `vim.o.<name> = value` (global), `vim.wo.<name>`
(window-local), or `vim.bo.<name>` (buffer-local).

---

## 1. Setting Options in Lua

```lua
-- Global options (apply everywhere)
vim.o.tabstop = 4

-- Window-local options (apply to current window)
vim.wo.number = true

-- Buffer-local options (apply to current buffer)
vim.bo.shiftwidth = 2

-- Option object API (supports :append, :remove, :prepend)
vim.opt.tabstop = 4
vim.opt.listchars:append({ tab = "» " })
vim.opt.formatoptions:remove({ "c", "r", "o" })
```

Use `vim.opt` when you need to modify complex options. Use `vim.o`/`vim.wo`/`vim.bo`
for simple scalars.

---

## 2. Indentation

These control how Neovim handles indentation. There are three layers:

### Layer 1: Basic Indentation

```lua
vim.o.tabstop = 4          -- Width of a tab character (display width)
vim.o.softtabstop = 4      -- How many spaces Tab key inserts
vim.o.shiftwidth = 4       -- How many spaces >> and << indent
vim.o.expandtab = true     -- Convert tabs to spaces
```

| Option | What it does |
|---|---|
| `tabstop` | Display width of a `\t` character in the file |
| `softtabstop` | How many spaces pressing Tab inserts. 0 = use tabstop. -1 = use shiftwidth |
| `shiftwidth` | How many spaces `>>`, `<<`, `==` indent by. 0 = use tabstop |
| `expandtab` | `true` = pressing Tab inserts spaces, not a tab character |
| `smarttab` | Tab inserts shiftwidth at line start, tabstop elsewhere |

### Layer 2: Auto-indentation

```lua
vim.o.autoindent = true    -- Copy indent from previous line (on Enter)
vim.o.smartindent = true   -- Extra indentation after { etc. (legacy)
vim.o.cindent = true       -- C-style indentation (legacy, for C-family)
vim.o.indentexpr = ""      -- Lua function for custom indentation
```

| Option | What it does |
|---|---|
| `autoindent` | When pressing Enter, copy indent from the line above. Essential. |
| `smartindent` | Old Vim behavior: adds indent after `{`, removes after `}`. Often replaced by treesitter. |
| `indentexpr` | If set, Neovim calls this expression to compute indentation. Treesitter plugins set this. |

### Layer 3: Treesitter-based Indentation (modern)

Treesitter-aware indentation is handled by `nvim-treesitter` or `nvim-treesitter-textobjects`.
You don't set options — the plugin sets `indentexpr` for each filetype.

```lua
-- In your LZE spec for nvim-treesitter:
{
  "nvim-treesitter",
  event = "VeryLazy",
  after = function()
    require("nvim-treesitter.configs").setup({
      indent = { enable = true },
      -- treesitter handles indentexpr per filetype
    })
  end,
}
```

With treesitter indent enabled, `==` re-indents based on the AST, not
simple brace counting. Much more accurate.

### Common indentation setups by language

```lua
-- Lua: 2 spaces
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true

-- Python: 4 spaces
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

-- Go: tabs (literal tab characters, width 8)
vim.bo.tabstop = 8
vim.bo.shiftwidth = 8
vim.bo.expandtab = false

-- Just use filetype plugins or vim-sleuth (automatic detection)
```

### vim-sleuth (automatic indent detection)

`vim-sleuth` is a single file you put in `start/` (or set `lazy = false`).
It reads the buffer and automatically sets `shiftwidth`, `tabstop`,
`expandtab` based on what it sees.

```lua
-- Eager, no triggers needed. Runs on every buffer.
{ "vim-sleuth", lazy = false },
```

---

## 3. Numbering and the Gutter

The gutter is the left margin of the editor. It holds line numbers,
signs (debug breakpoints, git markers), and fold indicators.

```lua
vim.wo.number = true           -- Show absolute line numbers
vim.wo.relativenumber = true   -- Show numbers relative to cursor line
vim.wo.numberwidth = 4         -- Minimum width of the number column
vim.wo.signcolumn = "yes"      -- Always show sign column ("yes", "auto", "no")
vim.wo.foldcolumn = "1"        -- Show a fold column ("0" to "9", or "auto")
```

### Line numbering modes

| `number` | `relativenumber` | Result |
|---|---|---|
| `false` | `false` | No line numbers |
| `true` | `false` | Absolute line numbers (1, 2, 3, ...) |
| `false` | `true` | All numbers relative to cursor (cursor = 0, above = 1, below = 1) |
| `true` | `true` | Cursor line shows absolute, rest show relative |

Most modern setups use `number = true, relativenumber = true`. You get the
absolute line where your cursor is and relative numbers everywhere else
(for `5j`, `3dd` motions).

### signcolumn

The signcolumn shows icons: debug breakpoints, git additions/deletions,
LSP diagnostics, etc.

```lua
vim.wo.signcolumn = "yes"   -- Always show (prevents layout shifts)
-- "auto"  = only show when signs are present
-- "no"    = never show
-- "yes:2" = always show, reserve 2 characters width (Neovim 0.9+)
```

Always set to `"yes"` to prevent the buffer width from jumping when signs appear.

### statuscolumn (Neovim 0.9+)

Replaces the separate number/sign/fold columns with a single customizable
column. Only useful if you want advanced customization:

```lua
vim.wo.statuscolumn = "%s %l %r"  -- sign, absolute line, relativenumber
-- Default: "%s%l %r" (sign + number + folding)
```

Most users don't need to touch this.

---

## 4. Code Formatting

### formatoptions

Controls how `gq` (format), text width, and auto-wrapping behave.

A string of single-letter flags. Common starting values:

```lua
vim.o.formatoptions = "jcroql"  -- Vim default
vim.o.formatoptions = "jqln"    -- Modern: keep j (join), q (gq), l (no rewrap), n (lists)
```

Common flags:

| Flag | What it does |
|---|---|
| `t` | Auto-wrap text at `textwidth` when inserting. Usually off for code. |
| `c` | Auto-wrap comments at `textwidth`. Usually off for code. |
| `r` | **Insert comment leader on `<Enter>` in comments**. This causes `//` or `--` to appear every time you press Enter inside a comment. Many users disable this. |
| `o` | Insert comment leader on `o`/`O` in comments. Same annoyance as `r`. |
| `q` | Allow `gq` to format comments. Useful if you keep it. |
| `j` | **Remove comment leader when joining lines.** `J` on a block comment removes `//` or `*`. Good. |
| `n` | Recognize numbered lists when formatting. |
| `l` | **Don't re-wrap if line is already longer than textwidth.** Prevents Neovim from reformatting lines you pasted. |
| `1` | Don't re-wrap if the line is a single word. |

A common modern setup removes `c`, `r`, `o` if you don't want auto-commenting:

```lua
vim.opt.formatoptions:remove({ "c", "r", "o" })
-- Now pressing Enter inside a comment won't add `-- ` or `// `
```

### textwidth

```lua
vim.o.textwidth = 80   -- Automatically wrap at column 80
vim.o.textwidth = 0    -- No auto-wrapping (most common for code)
```

### formatexpr

Neovim uses `formatexpr` when `gq` is pressed. If unset, it falls back to
Vim's internal formatter. Treesitter-aware formatting plugins set this.

### LSP Formatting

```lua
-- Manual format:
vim.lsp.buf.format()

-- With options:
vim.lsp.buf.format({
  async = true,             -- Format in background
  timeout_ms = 2000,        -- Wait 2s max
  filter = function(client)  -- Only use certain LSPs
    return client.name == "lua_ls"
  end,
})
```

Wrap this in a keymap:

```lua
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format buffer" })
```

### Conform.nvim (null-ls alternative)

For formatting without relying solely on LSP (e.g., Prettier for JS,
StyLua for Lua, Black for Python):

```lua
{
  "conform-nvim",
  event = "VeryLazy",
  after = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettierd", "prettier" },
        rust = { "rustfmt" },
      },
    })
  end,
}
```

Then trigger with `vim.lsp.buf.format()` — Conform hooks into it.

---

## 5. Mouse and Gestures

```lua
vim.o.mouse = "a"          -- Enable mouse in all modes
vim.o.mousemodel = "popup" -- Right-click shows popup menu
vim.o.mousefocus = true    -- Focus follows mouse (terminal-dependent)
```

`mouse = "a"` is standard. Without it, you can't click to place the cursor,
scroll with the wheel, or resize splits with the mouse.

| `mouse` value | Effect |
|---|---|
| `"a"` | All modes (normal, visual, insert, command-line) |
| `"n"` | Normal mode only |
| `"v"` | Visual mode only |
| `"i"` | Insert mode only |
| `""` | Disabled |

---

## 6. Swap Files and Modern Alternatives

### Traditional: swapfile

Vim/Neovim writes a `.swp` file alongside the edited file. If the editor
crashes, you can recover from the swap file.

```lua
vim.o.swapfile = true       -- Enable swap files (default)
vim.o.directory = "/tmp"    -- Where to store swap files
```

**Problems:** Creates files in the working directory, wastes writes on SSD,
recovery is manual.

### Modern: undofile (undo history)

Persistent undo — you can undo changes even after closing and reopening
a file.

```lua
vim.o.undofile = true       -- Save undo history to disk
vim.o.undodir = "/tmp"      -- Where to store undo files
```

With `undofile = true`, `u` and `<C-r>` work across sessions. This is the
real modern replacement — not for crash recovery, but for the ability to
undo after closing.

### Alternative: no swapfile

Many modern setups disable swap entirely and rely on undofile + git:

```lua
vim.o.swapfile = false      -- Disable swap files
vim.o.backup = false        -- Disable backup files
vim.o.undofile = true       -- But keep persistent undo
```

The argument: you use git, so you don't need swap. If Neovim crashes,
your unsaved work is gone anyway (swap files aren't reliable for recovery).
Instead, you save frequently (or use auto-save plugins).

### Backup files

```lua
vim.o.backup = false          -- Don't create ~filename~ backup files
vim.o.writebackup = false     -- Don't backup before writing
vim.o.backupdir = "/tmp"      -- Where to store backups (if enabled)
```

---

## 7. Clipboard

```lua
vim.o.clipboard = "unnamedplus"  -- Share with system clipboard
```

| Value | Effect |
|---|---|
| `"unnamed"` | `y`/`d`/`p` use the `*` register (primary selection on Linux) |
| `"unnamedplus"` | `y`/`d`/`p` use the `+` register (system clipboard, Ctrl+C/Ctrl+V) |
| `"unnamed,unnamedplus"` | Both |

**What this means:**
- `"unnamedplus"`: Yank (`y`) puts text in system clipboard. Paste (`p`)
  pulls from system clipboard. `<C-v>` in other apps works with `p` in Neovim.
- `"unnamed"`: Uses X11 primary selection (middle-click paste). Useful on
  Linux but doesn't interact with Ctrl+C/Ctrl+V.

Most users want `"unnamedplus"` for seamless integration with other apps.

```lua
vim.o.clipboard = "unnamedplus"
```

---

## 8. UI and Appearance

```lua
vim.o.termguicolors = true       -- Enable true color (24-bit color)
vim.o.background = "dark"        -- Hint to colorschemes ("light" or "dark")
vim.o.showmode = false           -- Don't show --INSERT-- in status line
vim.o.cmdheight = 1              -- Height of the command line
vim.o.pumheight = 10             -- Max height of popup menu (completions)
vim.o.pumblend = 10              -- Transparency of popup menus
```

### window management

```lua
vim.o.splitbelow = true          -- :split opens below current window
vim.o.splitright = true          -- :vsplit opens to the right
vim.o.equalalways = true         -- Resize splits equally
vim.o.winminwidth = 10           -- Minimum width for a window
vim.o.winminheight = 1           -- Minimum height for a window
```

### cursor

```lua
vim.o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
```

The format is: `{mode-group}:{cursor-shape}{style}`. Multiple groups
separated by commas.

| Mode group | Modes covered |
|---|---|
| `n-v-c` | Normal, Visual, Command-line |
| `i-ci-ve` | Insert, Command-line Insert, Visual Ex (gQ) |
| `r-cr` | Replace, Command-line Replace |
| `o` | Operator pending (after `g`, `z`, etc.) |

| Cursor shape | Looks like |
|---|---|
| `block` | Full block █ |
| `ver25` | Vertical bar, 25% width │ |
| `hor20` | Horizontal bar, 20% height _ |

| Style integer | Blink behavior |
|---|---|
| `1` | Blink, same as cursor |
| `25` | Blink 25% of the blink period |
| `0` | No blink (always visible) |

Common simplified version:

```lua
vim.opt.guicursor:append("i:ver25")  -- Vertical bar in insert mode
```

---

## 9. Search

```lua
vim.o.hlsearch = true          -- Highlight all search matches
vim.o.incsearch = true         -- Show matches as you type
vim.o.ignorecase = true        -- Case-insensitive search
vim.o.smartcase = true         -- If search has uppercase, override ignorecase

-- Clear search highlight with a keymap:
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search" })
```

`smartcase` is key: with `ignorecase + smartcase`, searching `foo` matches
`foo`, `Foo`, `FOO`. Searching `Foo` only matches `Foo` and `FOO` (because
you used uppercase, so case matters).

---

## 10. Motion and Scrolling

```lua
vim.o.scrolloff = 8            -- Keep 8 lines visible above/below cursor
vim.o.sidescrolloff = 8        -- Keep 8 columns visible left/right of cursor
vim.o.timeoutlen = 500         -- Max time (ms) to wait between keys of a mapped sequence like gd
vim.o.ttimeoutlen = 0          -- Timeout for terminal key codes (0 = instant, no delay on <Esc>)
vim.o.updatetime = 250         -- CursorHold event interval in ms. LSP diagnostics, git signs
vim.o.hidden = true            -- Allow switching buffers without saving first
```

| Option | Why you want it |
|---|---|
| `scrolloff` | Prevents cursor from hitting top/bottom of screen. Essential. |
| `sidescrolloff` | Same for horizontal scrolling. |
| `timeoutlen` | Affects how long you can pause between `g` and `d` in `gd`. 500ms is comfortable. |
| `updatetime` | LSP diagnostics update, git signs refresh, etc. Lower = more responsive. |
| `hidden` | Without this, `:bn` fails if the current buffer has unsaved changes. |

---

## 11. Special Characters and Whitespace

```lua
vim.o.list = true                      -- Show hidden characters
vim.opt.listchars = {
  tab = "» ",                          -- Show tabs as » followed by spaces
  trail = "·",                          -- Show trailing spaces as dots
  eol = "↴",                           -- Show end-of-line markers
  extends = ">",                        -- Show when line continues off-screen
  precedes = "<",                       -- Show when line continues off-screen (left)
  space = "·",                         -- Show spaces as dots (too busy usually)
  multispace = "·",                     -- Show multiple consecutive spaces
  lead = "·",                           -- Show leading spaces (for indentation)
  nbsp = "␣",                          -- Non-breaking space indicator
}
```

A conservative setup:

```lua
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
```

This shows tabs and trailing whitespace without cluttering the buffer.

---

## 12. Folding

```lua
vim.o.foldmethod = "expr"      -- Use expression-based folding
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"  -- Treesitter fold
vim.o.foldlevel = 99           -- Open all folds by default
vim.o.foldcolumn = "1"         -- Show fold indicators in gutter
vim.o.foldenable = true        -- Enable folding
```

| `foldmethod` | What it does |
|---|---|
| `"indent"` | Fold based on indentation level |
| `"expr"` | Use a Lua expression to compute fold level |
| `"syntax"` | Fold based on syntax regions |
| `"marker"` | Fold based on `{{{` / `}}}` markers |
| `"manual"` | User defines folds manually |

Treesitter folding (`"expr"` with `vim.treesitter.foldexpr()`) is the
modern choice. It folds function bodies, if-blocks, etc. correctly based
on the AST.

`foldlevel = 99` is important: without it, files open with all folds
closed, which is disorienting.

---

## 13. Spell Check

```lua
vim.o.spell = true              -- Enable spell check
vim.o.spelllang = "en_us"       -- Language(s) to check. Can be list: {"en_us", "de_de"}
vim.opt.spelloptions:append("camel")  -- Check camelCase words as well

-- Built-in spell motions (these work without mappings):
-- ]s  → next misspelled word
-- [s  → previous misspelled word
-- zg  → add word under cursor to spellfile (good word)
-- zw  → mark word under cursor as wrong (bad word)
-- z=  → show suggestions for misspelled word
```

---

## 14. Completion

```lua
vim.o.completeopt = "menu,menuone,noselect"
```

| Flag | Effect |
|---|---|
| `menu` | Show a popup menu |
| `menuone` | Show popup even with one result |
| `noselect` | Don't auto-select the first item |
| `preview` | Show preview window for selected item (rarely used) |
| `noinsert` | Don't insert anything until explicitly confirmed |
| `fuzzy` | Use fuzzy matching (Neovim 0.10+) |

For blink.cmp or nvim-cmp, `completeopt` is managed by the plugin. For
built-in completions:

```lua
vim.o.completeopt = "menu,menuone,noselect"
```

---

## 15. Quick Summary: Essential Options

```lua
-- Essentials (enable these first)
vim.o.hidden = true            -- Allow switching buffers without saving first
vim.o.mouse = "a"              -- Enable mouse in all modes
vim.o.termguicolors = true     -- 24-bit true color (needed for most colorschemes)
vim.o.clipboard = "unnamedplus"  -- Share yank/paste with system clipboard

-- Line numbering
vim.wo.number = true           -- Show absolute line number on cursor line
vim.wo.relativenumber = true   -- Show relative numbers everywhere else
vim.wo.signcolumn = "yes"      -- Always show sign column (prevents layout shifts)

-- Search
vim.o.hlsearch = true          -- Highlight all search matches
vim.o.incsearch = true         -- Show matches while typing
vim.o.ignorecase = true        -- Case-insensitive search by default
vim.o.smartcase = true         -- Override with case-sensitive if uppercase used

-- Motion
vim.o.scrolloff = 8            -- Keep 8 lines visible above/below cursor
vim.o.sidescrolloff = 8        -- Keep 8 columns visible left/right
vim.o.updatetime = 250         -- How often CursorHold fires (ms). Affects LSP/git sign speed

-- Indentation
vim.o.tabstop = 4              -- Display width of a tab character
vim.o.shiftwidth = 4           -- Indent width for >>, <<, ==
vim.o.expandtab = true         -- Pressing Tab inserts spaces, not a tab char
vim.o.autoindent = true        -- Copy indent from previous line on Enter

-- Persistence
vim.o.undofile = true          -- Save undo history across sessions
vim.o.swapfile = false         -- Don't create .swp files (rely on git + undofile)
vim.o.backup = false           -- Don't create ~ backup files

-- UI
vim.o.showmode = false         -- Don't show --INSERT-- (statusline shows it)
vim.o.cmdheight = 1            -- Height of command line (1 is fine with no showmode)
vim.o.splitbelow = true        -- :split opens below, not above
vim.o.splitright = true        -- :vsplit opens right, not left

-- Don't auto-insert comment leaders
vim.opt.formatoptions:remove({ "c", "r", "o" })  -- Stop // and -- from auto-appearing
```

---

## 16. Common Option Prefixes Reference

| Prefix | Scope | When to use |
|---|---|---|
| `vim.o` | Global | Options that apply everywhere (tabstop, mouse, clipboard) |
| `vim.wo` | Window-local | Display options (number, signcolumn, foldcolumn) |
| `vim.bo` | Buffer-local | File-specific options (shiftwidth, filetype, formatoptions) |
| `vim.opt` | Global (object API) | When you need `:append()`, `:remove()`, `:prepend()` |
| `vim.opt_local` | Buffer-local (object API) | Buffer-local with method access |
| `vim.go` | Global (string-based) | Legacy VimL-style, use vim.o instead |

# Neovim Configuration Architecture

## Design Tenets

1. **Text editor until it needs to be an IDE** — plugins lazy-load by filetype, command, event, or keybinding. Nothing loads at startup unless it's required for core editing.
2. **Headless-safe** — GUI/display plugins check for a running UI before loading. Same config works in terminal, Neovide, VSCode Neovim, and `--headless` scripting.
3. **Language configs are pure data** — no `require`, no side effects, trivially portable between Lazy, LZE, and Nix wrappers.
4. **Error isolation** — `pcall` per module. One broken file never blocks the rest of the config.
5. **Separation of concerns** — core, UI, languages, integrations, and notes are independent subsystems that communicate through `lua/settings.lua`.

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                         # Source order & boot sequence
├── lua/
│   ├── settings.lua                 # Central user preferences
│   ├── lazy_plugin_manager.lua      # Lazy.nvim bootstrap + setup
│   │
│   ├── core/                        # Editor fundamentals (no plugin deps)
│   │   ├── options.lua              # vim.opt.*
│   │   ├── keybinds.lua             # vim.keymap.set (global)
│   │   ├── autocommands.lua         # vim.api.nvim_create_autocmd (global)
│   │   └── transparent_nvim.lua     # Background transparency
│   │
│   ├── ui/                          # Visual layer (plugin-dependent)
│   │   ├── statusline.lua           # lualine config
│   │   ├── notifications.lua        # fidget / noice integration
│   │   ├── cursor_mode.lua          # Dynamic cursor color by mode
│   │   └── theme/
│   │       ├── init.lua             # Theme loading & per-theme overrides
│   │       └── render-markdown.lua  # render-markdown highlight overrides
│   │
│   ├── plugins/                     # Lazy.nvim plugin specs (one per plugin)
│   │   ├── colorscheme.lua
│   │   ├── lualine.lua
│   │   ├── telescope.lua
│   │   ├── treesitter.lua
│   │   ├── blink_cmp.lua
│   │   ├── conform.lua
│   │   ├── nvim-lint.lua
│   │   ├── gitsigns.lua
│   │   ├── indent_blankline.lua
│   │   ├── toggleterm.lua
│   │   ├── dap.lua
│   │   ├── autopairs.lua
│   │   ├── fidget.lua
│   │   ├── markdown_nvim.lua
│   │   ├── diagram_nvim.lua
│   │   ├── image_nvim.lua
│   │   ├── oil.lua                  # or neo-tree / yazi
│   │   ├── org_mode.lua
│   │   ├── mason.lua
│   │   └── nvim-lspconfig.lua
│   │
│   ├── languages/                   # Per-language configs (pure data)
│   │   ├── python.lua
│   │   ├── rust.lua
│   │   ├── cpp.lua
│   │   ├── lua.lua
│   │   ├── bash.lua
│   │   ├── nix.lua
│   │   ├── fish.lua
│   │   ├── markdown.lua
│   │   ├── toml.lua
│   │   ├── yaml.lua
│   │   ├── haskell.lua
│   │   └── clojure.lua
│   │
│   ├── language_settings.lua        # Loader: discover, pcall, wire LSP/linter/formatter
│   │
│   ├── integrations/                # External tool connectors
│   │   ├── neovim_remote.lua        # nvr — $EDITOR from external tools
│   │   ├── direnv.lua               # direnv → LSP root resolution
│   │   └── vscode.lua               # VSCode Neovim plugin compat
│   │
│   ├── modules/                     # Legacy — platform-specific modules
│   │   ├── neovide.lua              # Neovide GUI settings
│   │   └── kitty_integration.lua    # Kitty terminal integration
│   │
│   └── notes/                       # Note-taking subsystem
│       ├── init.lua                 # Router: pick active backend
│       ├── obsidian.lua             # obsidian.nvim config
│       ├── orgmode.lua              # orgmode.nvim config
│       └── neorg.lua                # neorg config
│
├── after/ftplugin/                  # Filetype-specific overrides
├── plugin/                          # Globally sourced Vim scripts (rare)
└── documentation/                   # Design docs & references
    ├── architecture.md
    ├── lsp_architecture.md
    ├── todo.md
    ├── init_lua.md
    ├── 10-neovim-options.md
    └── vimbinds.md
```

---

## Initialization Order

`init.lua` sources modules in this exact sequence:

```
┌────────────────────────────────────────────────────┐
│  1. vim.loader.enable()          LuaJIT loader     │
│  2. vim.g.neovide → require      GUI-only config   │
│  3. core/options.lua             Editor options    │
│  4. core/autocommands.lua        Global autocmds   │
│  5. core/keybinds.lua            Global keymaps    │
│  6. core/transparent_nvim.lua    Background         │
│  7. lazy_plugin_manager.lua      Lazy bootstrap    │
│     ├── loads lua/plugins/*.lua  Plugin specs      │
│     ├── colorscheme loads from   Theme              │
│     │   settings.lua                                 │
│     └── fidget.nvim loads        Notifications      │
│  8. ui/cursor_mode.lua          Dynamic cursor     │
│     (deferred via vim.schedule)                     │
│  9. language_settings.lua        Language modules   │
│     (deferred — waits for Lazy)                     │
└────────────────────────────────────────────────────┘
```

### Why this order

- **Core first** — options, autocmds, and keybinds depend on nothing. They must be available before any plugin expects them.
- **Lazy then UI** — Lazy must install and load plugins before UI modules that configure those plugins (lualine, fidget, cursor_mode) can read their highlight groups.
- **Languages last** — `vim.lsp.config()` and `vim.lsp.enable()` need the Neovim 0.11+ LSP APIs, which are always available, but we defer to avoid racing with Lazy's plugin resolution.
- **Deferred loading** — `vim.schedule` callbacks run after `UIEnter`, guaranteeing all `lazy = false` plugins (including the colorscheme and lualine) have finished their `config` functions.

---

## Layer Breakdown

### 1. Core (`lua/core/`)

These files manage the editor's intrinsic behavior. They have **zero plugin dependencies** and must load first.

| File | Content |
|---|---|
| `options.lua` | `vim.opt.*`, `vim.o.*`, `vim.wo.*`, `vim.g.*` — indentation, gutter, clipboard, search, scroll, spell, completions, guicursor |
| `keybinds.lua` | `vim.keymap.set` — global leader mappings, mode-switching shortcuts |
| `autocommands.lua` | `vim.api.nvim_create_autocmd` — yank highlighting, format-on-save triggers, LspAttach |
| `transparent_nvim.lua` | Strips background from `Normal`, `SignColumn`, `LineNr`, etc. on every `ColorScheme` event |

`options.lua` currently uses a **hardcoded `guicursor`** strategy (lines 63–66) with separate highlight groups per mode. This conflicts with the dynamic `cursor_mode.lua` approach. See "Cursor strategy" below.

### 2. Plugin Layer (`lua/plugins/`)

One file per Lazy.nvim plugin spec. Each file returns either a single spec table or an array of spec tables.

All `lua/plugins/*.lua` files are auto-imported by Lazy via:
```lua
-- lazy_plugin_manager.lua
require("lazy").setup({
  spec = { { import = "plugins" } },
})
```

#### Loading strategy per plugin

| Strategy | Mechanism | Plugins |
|---|---|---|
| **Startup** (`lazy = false`) | Loads during Lazy setup | `lualine`, `fidget`, `colorscheme` |
| **Filetype** | `ft = { "python", "rust" }` | `treesitter`, `conform`, `nvim-lint` |
| **Command** | `cmd = { "Telescope", "Dap" }` | `telescope`, `dap`, `oil` |
| **Event** | `event = { "InsertEnter", "VeryLazy" }` | `blink_cmp`, `autopairs`, `gitsigns` |
| **Key** | `keys = { { "gd", desc = "..." } }` | LSP keymaps |

#### Avoiding coupling

Plugin specs import **no application logic**. They are pure declarative tables. When migrating to LZE or Nix, only `lazy_plugin_manager.lua` and the files in `lua/plugins/` need to change — everything else (`lua/core/`, `lua/languages/`, `lua/ui/`, `lua/integrations/`) is portable.

### 3. Language Subsystem (`lua/languages/` + `lua/language_settings.lua`)

#### Language module contract

Each file in `lua/languages/` returns a table with zero side effects:

```lua
-- lua/languages/python.lua
return {
    lsp = {
        name = 'basedpyright',
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', '.git' },
        settings = {
            basedpyright = {
                analysis = { typeCheckingMode = 'basic' },
            },
        },
    },
    linter = {
        name = 'ruff',
        filetypes = { 'python' },
        args = { 'check', '--stdin-filename', '$FILENAME', '-' },
    },
    formatter = {
        name = 'ruff_format',
        filetypes = { 'python' },
        args = { 'format', '--stdin-filename', '$FILENAME', '-' },
    },
}
```

The loader (`lua/language_settings.lua`) runs after Lazy has finished:

```lua
-- Pseudocode for language_settings.lua
local modules = vim.fn.glob(vim.fn.stdpath("config") .. "/lua/languages/*.lua", false, true)
for _, path in ipairs(modules) do
    local ok, err = pcall(function()
        local mod = require("languages." .. vim.fn.fnamemodify(path, ":t:r"))
        if mod.lsp then
            vim.lsp.config(mod.lsp.name, {
                cmd = { mod.lsp.name },
                filetypes = mod.lsp.filetypes,
                root_markers = mod.lsp.root_markers,
                settings = mod.lsp.settings or {},
            })
            vim.lsp.enable(mod.lsp.name)
        end
    end)
    if not ok then
        vim.notify("Language module error: " .. err, vim.log.levels.WARN)
        -- Also append to log file at stdpath("data") .. "/language_settings.log"
    end
end
```

Key properties:
- **Pure data** — no `require()` inside module files. They are simple `return { ... }`.
- **Error isolation** — each `pcall` is independent. A broken Python module doesn't block Rust.
- **No path hardcoding** — `cmd` defaults to the server binary name (must be in `$PATH`).
- **Portable** — the same `lua/languages/*.lua` files work with Lazy, LZE, or Nix-managed servers.

### 4. UI Layer (`lua/ui/`)

Loaded after Lazy setup so plugin highlight groups exist.

| File | Plugin | Purpose |
|---|---|---|
| `statusline.lua` | lualine | Mode-aware statusline with theme colors |
| `notifications.lua` | fidget.nvim | vim.notify integration, LSP progress spinner |
| `cursor_mode.lua` | (native) | Reads `lualine_a_*` hl groups, sets `Cursor` bg per mode |
| `theme/init.lua` | (native) | Applies colorscheme from `settings.colorscheme`, runs per-theme overrides |
| `theme/render-markdown.lua` | render-markdown.nvim | Custom highlight overrides for markdown headings, code blocks, bullets |

#### Cursor strategy

Two approaches exist in the codebase and must be unified:

1. **Current `options.lua` approach** — hardcoded `guicursor` with custom hl groups (`CursorNormal`, `CursorBlue`). Static, theme-unaware.
2. **`cursor_mode.lua` approach** — reads `lualine_a_<mode>` highlight groups at runtime. Dynamic, theme-aware.

**Resolution**: `options.lua` should reset `guicursor` to use the standard `Cursor` highlight group, and `cursor_mode.lua` manages the rest. This avoids conflicts.

### 5. Integration Layer (`lua/integrations/`)

| File | Tool | Purpose |
|---|---|---|
| `neovim_remote.lua` | [neovim-remote](https://github.com/mhinz/neovim-remote) | Enables `$EDITOR = 'nvr'` so external tools (git, direnv) open files in the running Neovim instance |
| `direnv.lua` | [direnv](https://direnv.net) + LSP | Reads `.envrc`, feeds environment into LSP server start (e.g., `basedpyright` needs `PYTHONPATH`) |
| `vscode.lua` | VSCode Neovim plugin | Disables conflicting plugins, maps VSCode actions to Neovim keybinds |

### 6. Note-Taking Subsystem (`lua/notes/`)

A router pattern where one backend is active at a time:

```lua
-- lua/notes/init.lua
local backend = require("settings").notes_backend  -- "obsidian" | "orgmode" | "neorg"

if backend == "obsidian" then
    require("notes.obsidian")
elseif backend == "orgmode" then
    require("notes.orgmode")
elseif backend == "neorg" then
    require("notes.neorg")
end
```

Each backend file is a Lazy plugin spec or a native config. The setting lives in `lua/settings.lua`. This keeps the note system swappable without editing multiple files.

#### Candidates

| Backend | Strengths | Weaknesses |
|---|---|---|
| [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) | Mature, syncs with Obsidian app, good Markdown support | Tied to Obsidian vault format |
| [orgmode.nvim](https://github.com/nvim-orgmode/orgmode) | True Org mode, agenda, TODOs, capture | No mobile sync, limited ecosystem |
| [neorg](https://github.com/nvim-neorg/neorg) | Modern, Neovim-native, extensible | Still maturing, breaking changes |
| Markdown Oxide | LSP-native, built for Neovim 0.11+ | Experimental |

---

## Environment Awareness

### Headless mode (`--headless`)

GUI plugins (`image.nvim`, `diagram.nvim`, `neorg` UI components) must check for a running UI:

```lua
if vim.fn.has("gui_running") == 0 and vim.v.vim_did_enter == 0 then
    return  -- headless or early boot, skip plugin setup
end
```

### Neovide (`nvim --headless` is irrelevant for Neovide, but Neovide runs GUI)

```lua
if vim.g.neovide then
    require("modules.neovide")
end
```

Already in `init.lua`. Sets font, transparency, animations, cursor effects, and `laststatus = 3`.

### VSCode Neovim plugin

The VSCode Neovim integration uses the same `init.lua` but `vscode.lua` toggles off plugins that don't make sense (oil, telescope, lualine) and maps VSCode-native actions:

```lua
-- integrations/vscode.lua (loaded early if detected)
if not vim.g.vscode then return end

vim.g.vscode_snippets = true
-- Disable plugins that conflict with VSCode's UI
-- Map gd → VSCode "Go to Definition"
```

Detection: `vim.g.vscode` is set by the VSCode Neovim extension.

---

## Performance Principles

1. **No plugin loads at startup unless necessary.** Lualine and fidget are exceptions because they're part of the core editing UX.
2. **Treesitter parsers are lazy.** Only parse visible regions. Use `incremental_selection = { enable = true }` to defer full-buffer parsing.
3. **LSP starts on `FileType`.** `vim.lsp.enable()` with the 0.11+ API already defers to filetype match — no need for manual autocmds.
4. **Completion engine loads on `InsertEnter`.** Blink.cmp only activates when you start typing.
5. **Telescope and DAP load on `cmd`.** No startup overhead for tools you use occasionally.
6. **GUi-only plugins check at runtime.** `image.nvim`, `diagram.nvim` and Neovide-specific modules guard themselves behind `has("gui_running")`.
7. **`vim.schedule` for deferred work.** Language module loading, cursor color initialization — anything that must wait for Lazy to finish.

---

## Error Handling

### Module-level isolation

Every dynamic load goes through `pcall`:

```lua
local ok, err = pcall(require, "languages." .. name)
if not ok then
    -- 1. Notify user
    vim.notify("[" .. name .. "] " .. err, vim.log.levels.WARN)
    -- 2. Log to file
    local log = vim.fn.stdpath("data") .. "/language_settings.log"
    vim.fn.writefile({ os.date("%Y-%m-%d %H:%M:%S") .. " " .. err }, log, "a")
    -- 3. Continue — never abort
end
```

### What gets logged

| Level | Method | Example |
|---|---|---|
| WARN | `vim.notify` | Language module load failure |
| INFO | `vim.notify` | Theme switch, LSP attach |
| DEBUG | Log file only | Module discovery count, deferred task timing |

---

## Settings Reference (`lua/settings.lua`)

This file is the single source of truth for user preferences. All other modules read from it.

```lua
return {
    -- Theme
    colorscheme = 'tokyodark',

    -- Note-taking backend
    notes_backend = 'obsidian',   -- "obsidian" | "orgmode" | "neorg" | "markdown_oxide"

    -- Editor behavior
    transparent = true,
    enable_mouse = true,
    enable_spellcheck = false,

    -- LSP
    lsp_format_on_save = true,
    lsp_diagnostics_virtual_text = true,

    -- Plugins to enable (toggle to disable without removing)
    plugins = {
        telescope = true,
        dap = true,
        oil = true,
        gitsigns = true,
        indent_blankline = true,
    },
}
```

---

## Migration Path: Lazy → LZE → Nix

```
Phase 1 (now):        Lazy.nvim  →  lua/plugins/*.lua
                   Mason.nvim  →  installs server binaries
                   lua/languages/*.lua  →  pure data

Phase 2 (soon):       LZE.nvim   →  lua/plugins/*.lua (same files!)
                   Mason.nvim  →  removed (system packages)
                   lua/languages/*.lua  →  unchanged

Phase 3 (long term):  Nix module →  lua/languages/*.lua imported
                   into home-manager
                   lua/plugins/  →  nixpkgs neovimPlugins
                   Mason, Lazy, LZE  →  all removed
```

At each phase, only the outer orchestration layer changes. The language modules, UI config, core settings, and integration glue never need rewriting.

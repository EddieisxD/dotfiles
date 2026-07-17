# Agent Scratch Space — Heirline Migration

## Directives

- `agent/` is the scratch space for this project. Maintain it throughout.
- All boilerplate, ideas, approaches, and decisions go here.
- The cookbook at `documentation/cookbook.md` is the **only source of truth** for heirline patterns.
- Workflow: User leads, agent researches + templates boilerplate, user reviews + improves, iterate.
- Before writing any heirline code, consult the cookbook for the canonical pattern.
- Do NOT introduce patterns or components not found in the cookbook unless explicitly asked.

## Goal

Cleanly migrate from lualine → heirline.nvim for the statusline & tabline.
Leverage heirline's performance, persistent UI elements across windows, and clickable components.

## Progress

### Phase 1 — Cleanup lualine remnants

- [x] Download cookbook to `documentation/cookbook.md`
- [x] Remove lualine alias HL groups from `lua/plugins/heirline.lua`
- [ ] Decide what to do with `cursor_mode.lua` (standalone? merge into heirline? drop?)
- [ ] Update `documentation/architecture.md` — remove lualine references
- [ ] Update `documentation/todo.md` — mark lualine→heirline as done

### Phase 2 — Rewrite heirline config

- [x] Restructure `lua/plugins/heirline.lua` following cookbook patterns:
  - [x] `init`/`static`/`provider`/`hl` separation
  - [x] `utils.surround()` for delimiters
  - [x] `conditions` for conditional rendering
  - [x] `update` events for efficient redraws
  - [x] `on_click` for clickable buffer tabs
  - [x] `fallthrough` pattern for active vs inactive windows
  - [x] `on_colorscheme` for live theme switching
- [x] Statusline components: ViMode, FileName, Git, LSP, Diagnostics, Ruler, FileType
- [x] Tabline / bufferline with clickable tabs
- [ ] Winbar (optional)
- [ ] Native linter/formatter info (currently just LSP names)

### Phase 3 — Polish & customize to NvChad look

- [ ] Iterate on visual design (started)
- [ ] Make cursor color follow mode via heirline (replace cursor_mode.lua)
- [ ] Performance audit

## Cookbook Patterns Used

| Component | Cookbook Section | Notes |
|---|---|---|
| `ViMode` | Crash course: the ViMode | Full mode table + `init`/`static`/`provider`/`hl` + `ModeChanged` update |
| `FileNameBlock` | Crash course part II | `FileIcon` excluded (no dep), `FileNameModifer` + `FileFlags` kept |
| `Git` | Git | Adapted to native `vim.fn.system` instead of gitsigns |
| `LSPActive` | LSP | Lists server names, condition `lsp_attached` |
| `Diagnostics` | Diagnostics | Full severity enum with `init` caching |
| `Ruler` | Cursor position | Standard statusline syntax |
| `FileType` | FileType, FileEncoding and FileFormat | Upper case filetype |
| `StatusLines` | Conditional Statuslines | `fallthrough = false` with `InactiveStatusline` + `DefaultStatusline` |
| `BufferLine` | Bufferline | Cookbook bufferline with clickable tabs + close button |
| Colors | Theming | `utils.on_colorscheme(setup_colors)` for live theme updates |

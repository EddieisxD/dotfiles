# What is a hunk?
- A hunk in Neovim refers to a contiguous block of modified, added, or deleted lines within a file, as determined by a diff algorithm. Often tracked through version control systems like Git, hunks allow you to quickly identify, navigate, or selectively stage discrete sections of code.
- In zed editor we can traverse through these hunks with the command `] c` for next hunk and `[ c` for the previous hunk.
- Hunks are usually managed in neovim usually via -- `gitsigns.nvim` and builtin `mini.diff` module
  - stage hunk: add only those changes in the current hunk to the next commit.
  - Reset/Undo Hunk: Reverts the lines back to how they looked in the parent/committed state.
  - Preview Hunk: Opens a floating window to visualize exactly what was added, removed, or changed.
  - Next/Previous Hunk: Keyboard shortcuts (like ]c or [c) to jump your cursor between modifications in the file.

# Goto line number
- to go to some line number you have several options
  - [line_number]G: Type the line number and a capital G.
  - :[line_number]<Enter>: Type a colon, the line number, and press Enter.
  - [line_number]gg: Type the line number followed by lowercase gg.
- you can go to the previous cursor location using `''` or `"``"`

# Jump history
- you can move forward and back in your neovim history using the commands `ctrl + i` (forward) and `ctrl + o` (backwards)
- for just previous line you use '' and for previous line and column you can use ``
- :jumps: Displays your entire jump history.

# Fold in neovim
- zf: Creates a fold over a visual selection (or with a motion like zfj to fold the current and next line).
- zd: Deletes the fold at the cursor.
- zc: Closes the fold at the cursor line.
- zo: Opens the fold at the cursor line.
- za: Toggles the fold at the cursor (opens it if closed, closes it if open).
- zM: Closes all folds in the entire file.
- zR: Opens all folds in the entire file.

> [!note] 
> If manual folding (zf) is not working, your folding method might be set to static. Add this command to your configuration or type it in normal mode to enable manual folding:
> `:set foldmethod=manual`

# Word and Text Object Jumps
- `%`: Jumps between matching pairs of brackets, parentheses, or braces (), [], {}.
- w / W: Jumps forward to the start of the next word / WORD 
- b / B: Jumps backward to the start of the previous word / WORD.
- e / E: Jumps forward to the end of the next word / WORD.

# Line-Level Jumps
- 0 (Zero): Jumps to the absolute beginning of the line.
- ^: Jumps to the first non-blank character of the line.
- $: Jumps to the end of the line.
- _ (Underscore): Jumps to the first non-blank character of the current line (similar to ^).

# Screen and Scroll Jumps
- H (High): Jumps to the top line visible on the screen.
- M (Middle): Jumps to the middle line visible on the screen.
- L (Low): Jumps to the bottom line visible on the screen.
- `Ctrl + u`: Scrolls the screen Up by half a page.
- `Ctrl + d`: Scrolls the screen Down by half a page.

# Paragraph and Paragraph Blocks
- }: Jumps forward to the next empty line (ends of paragraphs).
- {: Jumps backward to the previous empty line (starts of paragraphs).

# Local Character Searches
- f[char]: Finds and jumps forward to the next occurrence of [char].
- F[char]: Finds and jumps backward to the previous occurrence of [char].
- t[char]: Jumps forward until (just before) the next occurrence of [char].
- T[char]: Jumps backward until (just after) the previous occurrence of [char].

- `;`: Jumps forward to the next appearance of the character.
- `,` (Comma): Jumps backward to the previous appearance of the character.

# Code Architecture and Definition gotos
- gd: Goto definition (jumps directly to where the variable, function, or class was defined).
- gD: Goto declaration (jumps to the type declaration, useful in languages like C/C++ or TypeScript).
- gi: Goto implementation (jumps to the concrete code implementing an interface or abstract class).
- gr: Goto references (lists or cycles through everywhere this specific code is used).

# Local Text & Line Gotos
- ge: Goto the end of the previous word (moves backward, stopping at the last letter of a word).
- gE: Goto the end of the previous WORD (ignoring punctuation).
- g_: Goto the last non-blank character of the current line (great for avoiding whitespace at the end of lines).
- gj: Goto the next visual line (crucial for navigating long, wrapped lines of text where one code line spans multiple screen lines).
- gk: Goto the previous visual line.

# History & Editing Gotos (Change List)
- gi: Goto last insertion (switches to Insert mode exactly where you last typed text, even if you moved away).
- g;: Goto the previous change in the change list (cycles backward through your actual file edits).
- g,: Goto the newer change in the change list (cycles forward through your edits).
- :changes: Displays the list of all recent modifications.

# Visual & Selection Gotos
- gv: Goto and reselect your last visual selection (instantly highlights what you had selected previously).
- gn: Goto and select the next match of your current search pattern.

# File Markings (Setting Teleporters)
- You can drop invisible flags called "marks" to bookmark specific lines and teleport back to them instantly.
- m[letter]: Sets a mark at the current cursor position using a lowercase letter (e.g., ma).
- '[letter]: Jumps directly to the line of that mark (e.g., 'a).
- `[letter]: Jumps directly to the exact column and line of that mark (e.g., `a).
Pro Tip: Use uppercase letters (like m followed by A) to create global marks. This allows you to jump to that file and line even if you are working in a completely different file.

# Text object navigation
- [{: Jump backward to the opening brace { of the current block.
- ]}: Jump forward to the closing brace } of the current block.
- [( and ]): Same as above, but for parentheses ().


# Square bracket navigation
- [{ / ]}: Jump to the opening / closing brace of the current block.
- [( / ]): Jump to the opening / closing parenthesis of the current block.
- [* / ]/*: Jump to the start / end of a C-style comment block.
- [m / ]m: Jump to the start of the previous / next method or function.
- [M / ]M: Jump to the end of the previous / next method or function.
- [d / ]d: Jump to the previous / next macro definition.

# 2. Version Control & Git (via gitsigns.nvim)
- [c / ]c: Jump to the previous / next Git change/hunk (Standard Vim default).
- [H / ]H: Commonly mapped in gitsigns.nvim to jump specifically to the previous / next hunk without triggering other diff systems.

# Diagnostics & Errors (via Built-In LSP)
- [d: Jump to the previous diagnostic error/warning.
- ]d: Jump to the next diagnostic error/warning.
- [e / ]e: Frequently mapped to jump exclusively to Errors (skipping warnings).

# The Golden Standard: mini.bracketed or vim-unimpaired
To supercharge bracket navigation, almost every modern Neovim setup uses either mini.bracketed or TPope's classic [vim-unimpaired](https://github.com/tpope/vim-unimpaired).
These plugins add dozens of predictable bracket maps to jump through your workspace:
## Document Navigation
* [b / ]b: Jump to the previous / next buffer (open tab/file).
* [f / ]f: Jump to the previous / next file in the current directory.
* [l / ]l: Jump to the previous / next item in the location list.
* [q / ]q: Jump to the previous / next item in the quickfix list (build errors).
* [t / ]t: Jump to the previous / next tag.

## Text & Blank Space Layout
* [space / ]space: Insert a blank line above / below the current line without entering insert mode.
* [e / ]e: Bubble/Move the current line up or down.

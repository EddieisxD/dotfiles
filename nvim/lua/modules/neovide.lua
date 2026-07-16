
-- Font configuration (Required format: "Font_Name:hFont_Size")
vim.o.guifont = "FiraCode_Nerd_Font:h14"

-- Transparency and blur (0.0 to 1.0)
vim.g.neovide_opacity = 0.75
vim.g.neovide_scroll_animation_length = 0.3

-- Scaling
vim.g.neovide_scale_factor = 0.9
vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 10
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_left = 10
vim.opt.linespace = 2
-- Hides the command line when you aren't using it, expanding the buffer area
vim.o.cmdheight = 0

-- Cursor Settings
vim.g.neovide_cursor_vfx_mode = "railgun" -- Options: "tornado", "fireworks", "laser", etc.
vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_trail_size = 0.8

-- Refresh Rate & Smoothness
vim.g.neovide_refresh_rate = 60
vim.g.neovide_no_idle = true

-- Forces a single, global statusline at the bottom of the window
vim.opt.laststatus = 3 

vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
            local bg_color = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg")
            if bg_color and bg_color ~= "" then
                -- Sets Neovide background clear/matching color
                vim.g.neovide_background_color = bg_color
            end
        end,
    })


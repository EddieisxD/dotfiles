
local function apply_transparency()
    local groups = {
        "Normal", "NormalNC",
        "NonText", "EndOfBuffer",
        "SignColumn",
        "LineNr", "FoldColumn",
        "VertSplit",
        "StatusLine", "StatusLineNC",
        "TabLineFill",
        "MsgArea",
    }
    for _, g in ipairs(groups) do
        vim.api.nvim_set_hl(0, g, { bg = "none" })
    end
end

vim.api.nvim_create_augroup("TransparentNvim", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
    group = "TransparentNvim",
    callback = apply_transparency,
})

-- run immediately on startup (important)
apply_transparency()

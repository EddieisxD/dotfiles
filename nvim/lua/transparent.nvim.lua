
vim.api.nvim_create_augroup("TransparentNvim", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = "TransparentNvim",
  callback = function()
    local groups = {
      "Normal", "NonText", "EndOfBuffer", "SignColumn", "LineNr",
      "FoldColumn", "VertSplit", "StatusLine", "StatusLineNC",
    }
    for _, g in ipairs(groups) do
      vim.api.nvim_set_hl(0, g, { bg = "none" })
    end
  end,
})

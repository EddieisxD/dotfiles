local M = {}

function M.apply()
    vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = "none" })
    vim.api.nvim_set_hl(0, 'RenderMarkdownCodeBorder', { bg = "none" })
    vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { bg = "none" })

    vim.api.nvim_set_hl(0, 'RenderMarkdownH1', { fg = '#ff6b6b' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH2', { fg = '#ffa94d' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH3', { fg = '#ffd43b' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH4', { fg = '#69db7c' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH5', { fg = '#74c0fc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH6', { fg = '#da77f2' })

    vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { bg = '#1a1111' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { bg = '#1a1510' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { bg = '#1a1a10' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { bg = '#101a10' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { bg = '#10101a' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH6Bg', { bg = '#15101a' })
end

return M

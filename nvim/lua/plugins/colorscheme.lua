local settings = require('settings')

return {
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.opt.background = 'dark'
            vim.cmd.colorscheme(settings.colorscheme)
        end
    },
    {
        'nyoom-engineering/oxocarbon.nvim',
        lazy = false,
        priority = 900,
        config = function()
            vim.opt.background = 'dark'
            vim.cmd.colorscheme(settings.colorscheme)
        end
    },
    {
        'tiagovla/tokyodark.nvim',
        lazy = false,
        priority = 800,
        config = function()
            vim.opt.background = 'dark'
            vim.cmd.colorscheme(settings.colorscheme)
        end
    },
}


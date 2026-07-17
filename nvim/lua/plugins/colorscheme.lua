local settings = require('settings')

local default = {
    'olimorris/onedarkpro.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        vim.opt.background = 'dark'
        vim.cmd.colorscheme(settings.colorscheme)
    end,
}

local extras = {
    { 'nyoom-engineering/oxocarbon.nvim',       lazy = false, priority = 900 },
    { 'tiagovla/tokyodark.nvim',                lazy = false, priority = 800 },
    { 'EdenEast/nightfox.nvim',                 lazy = false, priority = 700 },
}

return vim.list_extend({ default }, extras)

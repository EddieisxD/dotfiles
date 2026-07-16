return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { "markdown", "norg", "rmd", "org" },
    opts = {
        enabled_filetypes = { "markdown", "org", "norg", "rmd" },
        preset = "obsidian",
        acknowledge_conflicts = true,
        debounce = 30,
        heading = {
            border = false,
        },
        bullet = {
            icons = { '●', '○', '◉', '◎' },
        },
        anti_conceal = {
            ignore = {
                code_background = true,
                indent = true,
                sign = true,
                virtual_lines = true,
                bullet = true,
                head_icon = true,
                head_background = true,
                head_border = true,
            },
        },
    },
    config = function(_, opts)
        require('render-markdown').setup(opts)
        require('theme.render-markdown').apply()
    end,
}

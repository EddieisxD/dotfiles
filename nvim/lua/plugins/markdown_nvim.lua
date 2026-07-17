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
            -- foregrounds = {
            --     "@markup.heading.1.markdown",
            --     "@markup.heading.2.markdown",
            --     "@markup.heading.3.markdown",
            --     "@markup.heading.4.markdown",
            --     "@markup.heading.5.markdown",
            --     "@markup.heading.6.markdown",
            -- },
            -- backgrounds = {
            --     "@text.title.1.markdown",
            --     "@text.title.2.markdown",
            --     "@text.title.3.markdown",
            --     "@text.title.4.markdown",
            --     "@text.title.5.markdown",
            --     "@text.title.6.markdown",
            -- },
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

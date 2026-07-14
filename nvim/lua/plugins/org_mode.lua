return {
    {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    config = function()
        -- Setup orgmode
        require('orgmode').setup({
            org_agenda_files = '~/vaults/orgfiles/**/*',
            org_default_notes_file = '~/vaults/orgfiles/refile.org',
        })
        -- Experimental LSP support
        vim.lsp.enable('org')
    end,
    },
    -- {
    --     'akinsho/org-bullets.nvim',
    --     event = "VeryLazy",
    --     config = function()
    --         require('org-bullets').setup()
    --     end,
    -- },
}

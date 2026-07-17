return {
    lsp = {
        name = 'yamlls',
        cmd = { 'yaml-language-server', '--stdio' },
        filetypes = { 'yaml', 'yml' },
        root_markers = { '.git' },
        settings = {
            yaml = {
                schemas = {
                    ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
                },
            },
        },
    },
}

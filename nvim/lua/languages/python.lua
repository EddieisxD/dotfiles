return {
    lsp = {
        name = 'basedpyright',
        cmd = { 'basedpyright', '--stdio' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', '.git' },
        settings = {
            basedpyright = {
                analysis = { typeCheckingMode = 'basic' },
            },
        },
    },
}

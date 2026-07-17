return {
    lsp = {
        name = 'nixd',
        cmd = { 'nixd' },
        filetypes = { 'nix' },
        root_markers = { 'flake.nix', 'default.nix', 'shell.nix', '.git' },
        settings = {},
    },
}

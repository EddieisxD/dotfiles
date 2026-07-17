return {
    lsp = {
        name = 'hls',
        cmd = { 'haskell-language-server-wrapper', '--lsp' },
        filetypes = { 'haskell', 'lhaskell' },
        root_markers = { '*.cabal', 'stack.yaml', 'package.yaml', '.git' },
        settings = {},
    },
}

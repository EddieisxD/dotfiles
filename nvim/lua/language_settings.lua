local log_path = vim.fn.stdpath('data') .. '/language_settings.log'

local function log(level, msg)
    vim.notify(msg, level)
    local line = os.date('%Y-%m-%d %H:%M:%S') .. ' ' .. msg
    vim.fn.writefile({ line }, log_path, 'a')
end

local function discover_modules()
    local pattern = vim.fn.stdpath('config') .. '/lua/languages/*.lua'
    local files = vim.fn.glob(pattern, false, true)
    local names = {}
    for _, path in ipairs(files) do
        local name = vim.fn.fnamemodify(path, ':t:r')
        table.insert(names, name)
    end
    return names
end

local function load_module(name)
    local ok, mod = pcall(require, 'languages.' .. name)
    if not ok then
        log(vim.log.levels.WARN, '[' .. name .. '] require failed: ' .. tostring(mod))
        return nil
    end
    return mod
end

local n_servers = 0

for _, name in ipairs(discover_modules()) do
    local mod = load_module(name)
    if not mod then goto continue end

    if mod.lsp then
        local ok, err = pcall(function()
            vim.lsp.config(mod.lsp.name, {
                cmd = mod.lsp.cmd,
                filetypes = mod.lsp.filetypes,
                root_markers = mod.lsp.root_markers,
                settings = mod.lsp.settings or {},
            })
            vim.lsp.enable(mod.lsp.name)
            n_servers = n_servers + 1
        end)
        if not ok then
            log(vim.log.levels.WARN, '[' .. name .. '] LSP setup failed: ' .. tostring(err))
        end
    end

    ::continue::
end

log(vim.log.levels.INFO, 'Loaded ' .. n_servers .. ' LSP servers from ' .. #vim.fn.glob(vim.fn.stdpath('config') .. '/lua/languages/*.lua', false, true) .. ' language modules')

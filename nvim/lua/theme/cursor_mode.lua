local M = {}

local mode_bg = {
    normal  = '#61afef',
    insert  = '#98c379',
    visual  = '#e5c07b',
    replace = '#c678dd',
    command = '#e06c75',
    terminal = '#56b6c2',
}

local function set_cursor_from_mode(mode)
    local bg = mode_bg[mode]
    if bg then
        vim.api.nvim_set_hl(0, 'Cursor', { fg = '#1e2127', bg = bg })
    end
end

local function mode_to_name(m)
    if m == 'n' then return 'normal'
    elseif m == 'i' then return 'insert'
    elseif m == 'v' or m == 'V' or m == '\x16' then return 'visual'
    elseif m == 'R' or m == 'r' or m == 's' or m == 'S' or m == '\x13' then return 'replace'
    elseif m == 'c' then return 'command'
    end
    return nil
end

function M.setup()
    local group = vim.api.nvim_create_augroup('CursorMode', { clear = true })

    vim.api.nvim_create_autocmd('ModeChanged', {
        group = group,
        pattern = '*:*',
        callback = function()
            local name = mode_to_name(vim.fn.mode(1))
            if name then set_cursor_from_mode(name) end
        end,
    })

    vim.api.nvim_create_autocmd('ColorScheme', {
        group = group,
        callback = function()
            vim.schedule(function()
                vim.schedule(function()
                    set_cursor_from_mode(mode_to_name(vim.fn.mode(1)) or 'normal')
                end)
            end)
        end,
    })

    vim.schedule(function()
        set_cursor_from_mode('normal')
    end)
end

return M


return {
    "rebelot/heirline.nvim",
    lazy = false,
    config = function()
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")

        local function setup_colors()
            return {
                bright_bg = utils.get_highlight("Folded").bg,
                bright_fg = utils.get_highlight("Folded").fg,
                red = utils.get_highlight("DiagnosticError").fg,
                dark_red = utils.get_highlight("DiffDelete").bg,
                green = utils.get_highlight("String").fg,
                blue = utils.get_highlight("Function").fg,
                gray = utils.get_highlight("NonText").fg,
                orange = utils.get_highlight("Constant").fg,
                purple = utils.get_highlight("Statement").fg,
                cyan = utils.get_highlight("Special").fg,
                diag_warn = utils.get_highlight("DiagnosticWarn").fg,
                diag_error = utils.get_highlight("DiagnosticError").fg,
                diag_hint = utils.get_highlight("DiagnosticHint").fg,
                diag_info = utils.get_highlight("DiagnosticInfo").fg,
                git_del = utils.get_highlight("diffDeleted").fg,
                git_add = utils.get_highlight("diffAdded").fg,
                git_change = utils.get_highlight("diffChanged").fg,
            }
        end

        local colors = setup_colors()

        local ViMode = {
            init = function(self)
                self.mode = vim.fn.mode(1)
            end,
            static = {
                mode_names = {
                    n = "Normal",
                    no = "N?",
                    nov = "N?",
                    noV = "N?",
                    ["no\22"] = "N?",
                    niI = "Ni",
                    niR = "Nr",
                    niV = "Nv",
                    nt = "Nt",
                    v = "Visual",
                    vs = "Vs",
                    V = "Visual",
                    Vs = "Vs",
                    ["\22"] = "Visual",
                    ["\22s"] = "Visual",
                    s = "S",
                    S = "S_",
                    ["\19"] = "^S",
                    i = "Insert",
                    ic = "Ic",
                    ix = "Ix",
                    R = "R",
                    Rc = "Rc",
                    Rx = "Rx",
                    Rv = "Rv",
                    Rvc = "Rv",
                    Rvx = "Rv",
                    c = "C",
                    cv = "Ex",
                    r = "...",
                    rm = "M",
                    ["r?"] = "?",
                    ["!"] = "!",
                    t = "T",
                },
                mode_colors = {
                    n = "red",
                    i = "green",
                    v = "cyan",
                    V = "cyan",
                    ["\22"] = "cyan",
                    c = "orange",
                    s = "purple",
                    S = "purple",
                    ["\19"] = "purple",
                    R = "orange",
                    r = "orange",
                    ["!"] = "red",
                    t = "red",
                },
            },
            provider = function(self)
                return " %2(" .. self.mode_names[self.mode] .. "%) "
            end,
            hl = function(self)
                local mode = self.mode:sub(1, 1)
                return { fg = self.mode_colors[mode], bold = true }
            end,
            update = {
                "ModeChanged",
                pattern = "*:*",
                callback = vim.schedule_wrap(function()
                    vim.cmd("redrawstatus")
                end),
            },
        }

        local FileNameBlock = {
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(0)
            end,
        }

        local FileName = {
            provider = function(self)
                local filename = vim.fn.fnamemodify(self.filename, ":.")
                if filename == "" then return "[No Name]" end
                if not conditions.width_percent_below(#filename, 0.25) then
                    filename = vim.fn.pathshorten(filename)
                end
                return filename
            end,
            hl = { fg = utils.get_highlight("Directory").fg },
        }

        local FileFlags = {
            {
                condition = function()
                    return vim.bo.modified
                end,
                provider = "[+]",
                hl = { fg = "green" },
            },
            {
                condition = function()
                    return not vim.bo.modifiable or vim.bo.readonly
                end,
                provider = "[RO]",
                hl = { fg = "orange" },
            },
        }

        local FileNameModifer = {
            hl = function()
                if vim.bo.modified then
                    return { fg = "cyan", bold = true, force = true }
                end
            end,
        }

        FileNameBlock = utils.insert(FileNameBlock,
        utils.insert(FileNameModifer, FileName),
        FileFlags,
        { provider = "%<" }
    )

    local Git = {
        condition = function()
            local ok, out = pcall(vim.fn.system, "git rev-parse --is-inside-work-tree 2>/dev/null")
            return ok and vim.trim(out) == "true"
        end,
        init = function(self)
            local ok, out = pcall(vim.fn.system, "git rev-parse --abbrev-ref HEAD 2>/dev/null")
            if ok and not vim.startswith(out, "fatal") then
                self.branch = vim.trim(out)
            else
                self.branch = ""
            end
        end,
        hl = { fg = "orange" },
        {
            provider = function(self)
                return self.branch
            end,
            hl = { bold = true },
        },
        update = { "FileChangedShellPost", "BufEnter" },
    }

    local LSPActive = {
        condition = conditions.lsp_attached,
        update = { "LspAttach", "LspDetach" },
        provider = function()
            local names = {}
            for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                table.insert(names, server.name)
            end
            return " [" .. table.concat(names, " ") .. "]"
        end,
        hl = { fg = "green", bold = true },
    }

    local Diagnostics = {
        condition = conditions.has_diagnostics,
        init = function(self)
            self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
            self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,
        update = { "DiagnosticChanged", "BufEnter" },
        {
            provider = function(self)
                return self.errors > 0 and ("E:" .. self.errors .. " ") or ""
            end,
            hl = { fg = "diag_error" },
        },
        {
            provider = function(self)
                return self.warnings > 0 and ("W:" .. self.warnings .. " ") or ""
            end,
            hl = { fg = "diag_warn" },
        },
        {
            provider = function(self)
                return self.info > 0 and ("I:" .. self.info .. " ") or ""
            end,
            hl = { fg = "diag_info" },
        },
        {
            provider = function(self)
                return self.hints > 0 and ("H:" .. self.hints) or ""
            end,
            hl = { fg = "diag_hint" },
        },
    }

    local Ruler = {
        provider = "%7(%l/%3L%):%2c %P",
    }

    local FileType = {
        provider = function()
            return (vim.bo.filetype)
        end,
        hl = { fg = utils.get_highlight("Type").fg, bold = true },
    }

    local Align = { provider = "%=" }
    local Space = { provider = " " }

    local DefaultStatusline = {
        ViMode, Space, FileNameBlock, Space, Git, Space, Diagnostics, Align,
        LSPActive, Space, FileType, Space, Ruler,
    }

    local InactiveStatusline = {
        condition = conditions.is_not_active,
        FileType, Space, FileName, Align,
    }

    local StatusLines = {
        hl = function()
            if conditions.is_active() then
                return "StatusLine"
            else
                return "StatusLineNC"
            end
        end,
        fallthrough = false,
        InactiveStatusline, DefaultStatusline,
    }

    local TablineFileName = {
        provider = function(self)
            local filename = self.filename
            filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
            return filename
        end,
        hl = function(self)
            return { bold = self.is_active or self.is_visible }
        end,
    }

    local TablineFileFlags = {
        {
            condition = function(self)
                return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
            end,
            provider = "[+]",
            hl = { fg = "green" },
        },
        {
            condition = function(self)
                return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
                or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
            end,
            provider = "[RO]",
            hl = { fg = "orange" },
        },
    }

    local TablineFileNameBlock = {
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(self.bufnr)
        end,
        hl = function(self)
            if self.is_active then
                return "TabLineSel"
            else
                return "TabLine"
            end
        end,
        on_click = {
            callback = function(_, minwid, _, button)
                if button == "m" then
                    vim.schedule(function()
                        vim.api.nvim_buf_delete(minwid, { force = false })
                    end)
                else
                    vim.api.nvim_win_set_buf(0, minwid)
                end
            end,
            minwid = function(self)
                return self.bufnr
            end,
            name = "heirline_tabline_buffer_callback",
        },
        TablineFileName,
        TablineFileFlags,
    }

    local TablineBufferBlock = utils.surround({ " ", " " }, function(self)
        if self.is_active then
            return utils.get_highlight("TabLineSel").bg
        else
            return utils.get_highlight("TabLine").bg
        end
    end, { TablineFileNameBlock })

    local BufferLine = utils.make_buflist(
        TablineBufferBlock,
        { provider = "<", hl = { fg = "gray" } },
        { provider = ">", hl = { fg = "gray" } }
    )

    vim.opt.showtabline = 2

    vim.api.nvim_create_augroup("Heirline", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
            utils.on_colorscheme(setup_colors)
            vim.api.nvim_set_hl(0, "TabLineSel", { bg = "none" })
            vim.api.nvim_set_hl(0, "TabLine", { bg = "none" })
        end,
        group = "Heirline",
    })
    vim.api.nvim_set_hl(0, "TabLineSel", { bg = "none" })
    vim.api.nvim_set_hl(0, "TabLine", { bg = "none" })
    require("heirline").load_colors(colors)
    require("heirline").setup({
        statusline = StatusLines,
        tabline = { { provider = "   " }, BufferLine },
    })
end,
}

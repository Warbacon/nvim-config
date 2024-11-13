return {
    "rebelot/heirline.nvim",
    event = "UiEnter",
    init = function()
        vim.o.statusline = " "
    end,
    config = function()
        local utils = require("heirline.utils")
        local conditions = require("heirline.conditions")
        local Space = { provider = " " }
        local Align = { provider = "%=" }

        local colors = {
            bright_bg = utils.get_highlight("Folded").bg,
            red = utils.get_highlight("DiagnosticError").fg,
            green = utils.get_highlight("String").fg,
            blue = utils.get_highlight("Function").fg,
            orange = utils.get_highlight("Constant").fg,
            purple = utils.get_highlight("Statement").fg,
            cyan = utils.get_highlight("Special").fg,
            aqua = utils.get_highlight("DiagnosticHint").fg,
        }

        local ViMode = {
            init = function(self)
                self.mode = vim.fn.mode(1)
            end,
            static = {
                mode_colors = {
                    n = "blue",
                    i = "green",
                    v = "purple",
                    V = "purple",
                    ["\22"] = "purple",
                    c = "orange",
                    s = "purple",
                    S = "purple",
                    ["\19"] = "purple",
                    R = "red",
                    ["!"] = "aqua",
                    t = "aqua",
                },
            },
            provider = " ",
            hl = function(self)
                local mode = self.mode:sub(1, 1)
                return { bg = self.mode_colors[mode] or self.mode_colors["n"] }
            end,
        }

        local FileNameBlock = {
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(0)
            end,
        }

        local FileIcon = {
            init = function(self)
                local filename = self.filename
                local has_icons, mini_icons = pcall(require, "mini.icons")
                if has_icons then
                    self.icon, self.hl = require("mini.icons").get("file", filename)
                end
            end,
            provider = function(self)
                return self.icon and (self.icon .. " ")
            end,
            hl = function(self)
                return { fg = self.icon_color }
            end,
            condition = function()
                return vim.bo.filetype ~= ""
            end,
        }

        local FileName = {
            provider = function(self)
                if self.filename == "" then
                    return "[Sin nombre]"
                end

                if vim.bo.buftype == "help" then
                    return vim.fn.fnamemodify(self.filename, ":t")
                end

                local filename = vim.fn.fnamemodify(self.filename, ":.")

                if not conditions.width_percent_below(#filename, 0.55) then
                    filename = vim.fn.pathshorten(filename)
                end

                return filename
            end,
        }

        local FileFlags = {
            {
                condition = function()
                    return vim.bo.modified
                end,
                provider = " ●",
            },
            {
                condition = function()
                    return vim.bo.readonly
                end,
                provider = " 󰌾",
                hl = { fg = "red" },
            },
        }

        FileNameBlock = utils.insert(FileNameBlock, FileIcon, FileName, FileFlags, { provider = "%<" })

        local Ruler = {
            provider = "%-6.(%l:%c%V%)",
        }

        local ScrollBar = {
            static = {
                sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
            },
            provider = function(self)
                local curr_line = vim.api.nvim_win_get_cursor(0)[1]
                local lines = vim.api.nvim_buf_line_count(0)
                local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
                return string.rep(self.sbar[i], 2)
            end,
            hl = { fg = "cyan", bg = "bright_bg" },
        }

        local StatusLine = {
            ViMode,
            Space,
            FileNameBlock,
            Space,
            Align,
            Ruler,
            Space,
            ScrollBar,
            hl = "StatusLine",
        }

        local StatusLineNC = {
            FileNameBlock,
            Space,
            Align,
            Ruler,
            Space,
            ScrollBar,
            hl = vim.tbl_extend("force", utils.get_highlight("StatusLineNC"), { force = true }),
            condition = conditions.is_not_active,
        }

        local StatusLines = {
            fallthrough = false,
            StatusLineNC,
            StatusLine,
        }

        require("heirline").setup({
            statusline = StatusLines,
            opts = { colors = colors },
        })
    end,
}

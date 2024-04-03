return {
    -- HEIRLINE.NVIM ----------------------------------------------------------
    {
        "rebelot/heirline.nvim",
        event = "UiEnter",
        init = function()
            vim.opt.statusline = " "
        end,
        config = function()
            local conditions = require("heirline.conditions")
            local utils = require("heirline.utils")
            local Align = { provider = "%=" }
            local Space = { provider = " " }
            local colors = require("catppuccin.palettes").get_palette("mocha")

            ViMode = {
                init = function(self)
                    self.mode = vim.fn.mode(1)
                end,
                static = {
                    -- mode_names = {
                    --     n = "normal",
                    --     no = "normal",
                    --     nt = "normal",
                    --     v = "visual",
                    --     V = "línea visual",
                    --     s = "selección",
                    --     ["\22"] = "bloque visual",
                    --     i = "insertar",
                    --     c = "comando",
                    --     t = "terminal",
                    -- },
                    mode_colors = {
                        n = "blue",
                        i = "green",
                        v = "mauve",
                        V = "mauve",
                        ["\22"] = "mauve",
                        c = "peach",
                        t = "green",
                        s = "teal",
                    },
                },
                provider = function()
                    return " "
                end,
                hl = function(self)
                    local mode = self.mode:sub(1, 1) -- get only the first mode character
                    return { fg = "base", bg = self.mode_colors[mode], bold = true }
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

            local FileIcon = {
                init = function(self)
                    self.icon, self.icon_color =
                        require("nvim-web-devicons").get_icon_colors_by_filetype(vim.bo.filetype)
                end,
                provider = function(self)
                    return self.icon and (self.icon .. "  ")
                end,
                hl = function(self)
                    return { fg = self.icon_color }
                end,
            }

            local FileName = {
                provider = function(self)
                    local filename = vim.fn.fnamemodify(self.filename, ":.")
                    if filename == "" then
                        return "[Sin nombre]"
                    end
                    if not conditions.width_percent_below(#filename, 0.35) then
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
                    provider = " [+]",
                },
                {
                    condition = function()
                        return not vim.bo.modifiable or vim.bo.readonly
                    end,
                    provider = " ",
                    hl = { fg = "red" },
                },
            }

            FileNameBlock = utils.insert(
                FileNameBlock,
                FileIcon,
                FileName,
                FileFlags,
                { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
            )

            local Ruler = {
                provider = "%l,%c%V %13P",
            }

            local StatusLine = {
                ViMode,
                Space,
                FileNameBlock,
                Align,
                Ruler,
                Space,
                hl = { bg = "mantle" },
            }

            local StatusLineNc = {
                condition = function()
                    return not conditions.is_active()
                end,
                FileNameBlock,
                Align,
                Ruler,
                Space,
                hl = { fg = "surface2", bg = "mantle" },
            }

            require("heirline").setup({
                opts = { colors = colors },
                statusline = {
                    fallthrough = false,
                    StatusLineNc,
                    StatusLine,
                },
            })
        end,
    },
}

return {
    -- NVIM-WEB-DEVICONS =======================================================
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- INDENT-BLANKLINE.NVIM ===================================================
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = { show_start = false, show_end = false },
            exclude = {
                filetypes = {
                    "help",
                    "lazy",
                    "mason",
                },
            },
        },
        main = "ibl",
    },

    -- STATUSCOL.NVIM ==========================================================
    {
        "luukvbaal/statuscol.nvim",
        opts = function()
            local builtin = require("statuscol.builtin")
            return {
                ft_ignore = { "netrw" },
                segments = {
                    { sign = { namespace = { "diagnostic/signs" } } },
                    { text = { builtin.lnumfunc } },
                    { sign = { namespace = { "gitsigns" } } },
                },
            }
        end,
    },
}

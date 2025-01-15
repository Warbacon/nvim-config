return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
        -- stylua: ignore start
        { "<leader>n", function() Snacks.notifier.show_history() end },
        -- { "<leader>,", function() Snacks.picker.buffers() end },
        -- { "<leader>f", function() Snacks.picker.files() end },
        -- { "<leader>f", function() Snacks.picker.files() end },
        -- { "<leader>sg", function() Snacks.picker.grep() end },
        -- { "<leader>sh", function() Snacks.picker.help() end },
        -- { "<leader>sd", function() Snacks.picker.diagnostics() end },
        -- { "<leader>ss", function() Snacks.picker.lsp_symbols() end },
        -- { "<leader>ss", function() Snacks.picker.man() end },
        -- stylua: ignore end
    },
    opts = {
        notifier = {},
        bigfile = {},
        quickfile = {},
        picker = {
            win = {
                input = {
                    keys = {
                        ["<Esc>"] = { "close", mode = { "n", "i" } },
                    },
                },
            },
            icons = {
                diagnostics = {
                    Error = util.icons.diagnostics.ERROR,
                    Warn = util.icons.diagnostics.WARN,
                    Hint = util.icons.diagnostics.HINT,
                    Info = util.icons.diagnostics.INFO,
                },
                kinds = util.icons.kinds,
            },
        },
    },
}

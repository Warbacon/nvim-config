return {
    -- CONFORM.NVIM ------------------------------------------------------------
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    keys = {
        {
            "<leader>bf",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
        },
    },
    opts = {
        formatters_by_ft = {
            c = { "clang_format" },
            cpp = { "clang_format" },
            fish = { "fish_indent" },
            lua = { "stylua" },
            python = { "ruff_format" },
            sh = { "shfmt" },
            markdown = { "injected" },
            ["_"] = { "trim_whitespace" },
        },
        formatters = {
            clang_format = {
                prepend_args = {
                    "-style={IndentWidth: 4, BreakBeforeBraces: Linux, AccessModifierOffset: -4}",
                },
            },
            shfmt = { prepend_args = { "-i", "4", "-ci", "-bn" } },
        },
    },
}

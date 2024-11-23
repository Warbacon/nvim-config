return {
    -- MASON-LSPCONFIG ========================================================
    { "williamboman/mason-lspconfig.nvim", lazy = true },

    -- MASON ==================================================================
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        event = "VeryLazy",
        keys = {
            { "<leader>m", "<cmd>Mason<cr>" },
        },
        opts = {
            ui = {
                icons = {
                    package_pending = " ",
                    package_installed = " ",
                    package_uninstalled = " ",
                },
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            require("mason-lspconfig").setup()

            local ensure_installed = vim.list_extend({
                "clang-format",
                "markdownlint",
                "ruff",
                "shellcheck",
                "shfmt",
                "stylua",
            }, vim.tbl_keys(require("util.lsp_servers")))

            local registry = require("mason-registry")

            registry:on("package:install:success", function()
                vim.defer_fn(function()
                    -- trigger FileType event to possibly load this newly installed LSP server
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)

            registry.refresh(function()
                local mappings = require("mason-lspconfig").get_mappings().lspconfig_to_mason
                for _, package_name in ipairs(ensure_installed) do
                    package_name = mappings[package_name] or package_name
                    if not registry.is_installed(package_name) then
                        local package = registry.get_package(package_name)
                        package:install()
                    end
                end
            end)
        end,
    },
}

return {
    -- SCHEMASTORE =============================================================
    { "b0o/SchemaStore.nvim", lazy = true },

    -- LAZYDEV =================================================================
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },

    -- JDTLS ===================================================================
    {
        "mfussenegger/nvim-jdtls",
        enabled = vim.fn.executable("java"),
        ft = "java",
        config = function()
            local function attach_jdtls()
                local fname = vim.api.nvim_buf_get_name(0)

                local has_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")

                local config = {
                    cmd = { vim.fn.exepath("jdtls") },
                    root_dir = require("lspconfig.configs.jdtls").default_config.root_dir(fname),
                    capabilities = has_cmp_lsp and cmp_lsp.default_capabilities()
                        or require("blink-cmp").get_lsp_capabilities(),
                }

                require("jdtls").start_or_attach(config)
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("start-jdtls", { clear = true }),
                pattern = { "java" },
                callback = attach_jdtls,
            })
        end,
    },

    -- LSPCONFIG ===============================================================
    {
        "neovim/nvim-lspconfig",
        event = "LazyFile",
        dependencies = {
            "mason.nvim",
        },
        config = function()
            local has_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")

            local has_blink, blink = pcall(require, "blink.cmp")

            local capabilities = {}
            if not has_blink then
                capabilities = vim.tbl_deep_extend(
                    "force",
                    {},
                    vim.lsp.protocol.make_client_capabilities(),
                    has_cmp_lsp and cmp_lsp.default_capabilities() or {}
                )
            else
                capabilities = blink.get_lsp_capabilities()
            end

            local servers = require("util.lsp").servers

            servers.jdtls = nil

            for server_name in pairs(servers) do
                local server_opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, servers[server_name])
                require("lspconfig")[server_name].setup(server_opts)
            end
        end,
    },
}

return {
    -- TS-COMMENTS.NVIM ========================================================
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- NVIM-SURROUND ===========================================================
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {},
    },

    -- MINI.AI =================================================================
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                    f = ai.gen_spec.treesitter({
                        a = "@function.outer",
                        i = "@function.inner",
                    }),
                    c = ai.gen_spec.treesitter({
                        a = "@class.outer",
                        i = "@class.inner",
                    }),
                },
            }
        end,
    },

    -- TREESJ ==================================================================
    {
        "Wansmer/treesj",
        keys = {
            {
                "<leader>j",
                function()
                    require("treesj").join()
                end,
                mode = "n",
            },
            {
                "<leader>s",
                function()
                    require("treesj").split()
                end,
                mode = "n",
            },
        },
        opts = { use_default_keymaps = false },
    },

    -- NVIM-CMP ================================================================
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            {
                "dcampos/nvim-snippy",
                opts = {
                    mappings = {
                        is = {
                            ["<C-l>"] = "expand_or_advance",
                            ["<C-h>"] = "previous",
                        },
                    },
                },
            },
            "dcampos/cmp-snippy",
        },
        opts = function()
            local cmp = require("cmp")
            local snippy = require("snippy")

            return {
                snippet = {
                    expand = function(args)
                        snippy.expand_snippet(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(_, item)
                        ---@diagnostic disable-next-line: param-type-mismatch
                        item.kind = require("mini.icons").get("lsp", item.kind) .. " "

                        local widths = {
                            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
                            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
                        }

                        for key, width in pairs(widths) do
                            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
                            end
                        end

                        return item
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<S-CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
                    ["<C-CR>"] = function(fallback)
                        cmp.abort()
                        fallback()
                    end,
                }),
                view = {
                    entries = { follow_cursor = true },
                },
                sources = cmp.config.sources({
                    { name = "lazydev", group_index = 0 },
                    { name = "nvim_lsp" },
                    { name = "snippy" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
            }
        end,
    },
}

return {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
        plugins = { cmp = true },
    },
    config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd.colorscheme("tokyonight")
    end,
}

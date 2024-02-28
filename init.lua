-- Set leader-key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Options
require("options")

-- Keymaps
require("keymaps")

-- Autocmds
require("autocmds")

-- Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
})

-- Add hyprlang filetype
vim.filetype.add({
	pattern = { [".*/hypr.*.conf"] = "hyprlang" },
})

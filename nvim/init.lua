-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set font
vim.g.have_nerd_font = true

-- Line number configuration
vim.o.number = true
vim.o.relativenumber = true

-- Don't show mode (see status line)
vim.o.showmode = false

-- Sync clipboard between OS and nvim
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Keep signcolumn on
vim.o.signcolumn = "yes"

-- Highlight cursor line
vim.o.cursorline = true

-- Minimum lines above/below cursor
vim.o.scrolloff = 10

-- Confirm making unsaved changes
vim.o.confirm = true

-- Save undo history
vim.o.undofile = true

-- They call me verstappen
vim.opt.timeoutlen = 0 -- Adjust this to your preference

-- Filetype extension
vim.filetype.add({
	extension = {
		h = "c",
		hpp = "cpp",
		tpp = "cpp",
		metal = "cpp",
		mm = "cpp",
	},
})

-- Enable native autocompletion
-- vim.o.autocomplete = true

require("vim._core.ui2").enable({})

-- Indent settings
local indent_settings = {
	-- Two space languages
	lua = { shiftwidth = 2, softtabstop = 2, expandtab = true },
	nix = { shiftwidth = 2, softtabstop = 2, expandtab = true },
	wgsl = { shiftwidth = 2, softtabstop = 2, expandtab = true },
	c0 = { shiftwidth = 2, softtabstop = 2, expandtab = true },

	-- Four space languages
	python = { shiftwidth = 4, softtabstop = 4, expandtab = true },
	c = { shiftwidth = 4, softtabstop = 4, expandtab = true },
	cpp = { shiftwidth = 4, softtabstop = 4, expandtab = true },

	-- Languages with real tabs
	make = { shiftwidth = 4, softtabstop = 4, expandtab = false },
}

-- Enable true colors
vim.o.termguicolors = true

require("core.autocmds")
require("core.andrew-sync")
require("lsp.lsp-setup")
require("core.keymaps")

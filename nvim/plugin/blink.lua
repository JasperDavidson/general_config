vim.pack.add({
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("^1"),
	},
})

require("blink.cmp").setup({
	keymap = { preset = "super-tab" },

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	cmdline = {
		enabled = true,
		keymap = { preset = "cmdline" },
		completion = { menu = { auto_show = true } },
	},

	signature = { enabled = true },
})

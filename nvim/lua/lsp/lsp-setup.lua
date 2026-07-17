vim.lsp.config["clangd"] = {
	cmd = { "clangd" },
	filetypes = { "c", "cpp" },
	root_markers = { "Makefile", ".git", "compile_commands.json" },
}
vim.lsp.config["rust-analyzer"] = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "cargo.toml" },
}
vim.lsp.config["lua-ls"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
}

vim.lsp.config["pyright"] = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
			},
		},
	},
}

vim.lsp.config["typos_lsp"] = {
	cmd = { "typos-lsp" },
	root_markers = { ".git", "typos.toml", "_typos.toml", ".typos.toml", "pyproject.toml", "Cargo.toml" },
}

vim.lsp.enable("clangd")
vim.lsp.enable("rust-analyzer")
vim.lsp.enable("lua-ls")
vim.lsp.enable("pyright")
vim.lsp.enable("typos_lsp")

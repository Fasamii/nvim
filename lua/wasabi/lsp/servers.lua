require("mason").setup({
	ui = {
		border = "solid",
		width = 0.8,
		height = 0.8,
		icons = {
			package_installed = "󱗜 ",
			package_pending = "󰌴 ",
			package_unsinstalled = "󰅗 ",
		},
	},
	max_concurrent_installers = 4,
});

require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"rust_analyzer",
		"clangd",
		"ts_server",
		"pyright",
		"lua_ls",
		"marksman",
		"jsonls",
		"yamlls",
		"html",
		"cssls",
	},
	automatic_installation = true,
	automatic_enable = true,
});

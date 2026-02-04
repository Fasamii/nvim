require("mason").setup({
	log_level = vim.log.levels.WARN,

	max_concurrent_installers = 4,

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
});

require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"rust_analyzer",
		"clangd",
		"ts_ls",
		"js_ls",
		"pyright",
		"lua_ls",
		"marksman",
		"jsonls",
		"yamlls",
		"html",
		"emmet_language_server",
		"cssls",
	},

	automatic_installation = true,
	automatic_enable = true,
});

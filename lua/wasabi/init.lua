-- Removes kitty padding if using kitty
if vim.env.TERM == "xterm-kitty" then
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			vim.fn.system({
				"kitty",
				"@",
				"set-spacing",
				"padding=0",
			})
		end,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			vim.fn.system({
				"kitty",
				"@",
				"set-spacing",
				"padding=default",
				"margin=default",
			})
		end,
	})
end

vim.pack.add({
	-- Colorscheme
	{ src = "https://github.com/Fasamii/sobsob.nvim" },
	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	-- Injections
	{ src = "https://github.com/Fasamii/embed.nvim" },
	-- Icons dependency for: [ "Telescope", "Lualine" ]
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	-- Lualine
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	-- Plenary dependency for: [ "Telescope" ]
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	-- Telescope
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	-- Todo
	{ src = "https://github.com/folke/todo-comments.nvim" },
	-- Git
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	-- Session
	{ src = "https://github.com/rmagatti/auto-session" },
	-- Peak lines
	{ src = "https://github.com/nacro90/numb.nvim" },
	-- Markdown
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	-- LSP
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	-- CMP
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.8.0"),
	},
	{ src = "https://github.com/b0o/schemastore.nvim" },
})

vim.cmd.colorscheme("sobsob");

require("wasabi.opts");
require("wasabi.keymaps");

require("wasabi.plugins.treesitter");
require("wasabi.plugins.lualine");
require("wasabi.plugins.telescope");
require("wasabi.plugins.todo-comments");
require("wasabi.plugins.gitsigns");
require("wasabi.plugins.auto-session");
require("numb").setup();
require("wasabi.plugins.markdown");


require("wasabi.lsp");

local ts = require("nvim-treesitter");
local parsers = {
	"c",
	"lua",
	-- "vim",
	-- "vimdoc",
	"markdown",
	"markdown_inline",
	"rust",
	"python",
	"javascript",
	"typescript",
	"html",
	"css",
	"json",
	"yaml",
	"bash",
};

ts.setup({});

ts.install(parsers, { summary = true }):wait(300000);

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
		if lang then
			pcall(vim.treesitter.start, args.buf, lang)
		end
	end,
});

-- Indentation support through Treesitter
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
-- Fold support through Treesitter
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'

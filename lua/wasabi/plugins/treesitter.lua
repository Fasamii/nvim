local ts = require("nvim-treesitter");
local parsers = {
	"c", "lua", "vim", "vimdoc", "query",
	"markdown", "markdown_inline",
	"rust", "python", "javascript", "typescript",
	"html", "css", "json", "yaml", "bash",
}

ts.setup({});

ts.install(parsers, { summary = true });

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
		if lang then
			pcall(vim.treesitter.start, args.buf, lang)
		end
	end,
});

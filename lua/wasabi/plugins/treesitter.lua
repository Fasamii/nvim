if vim.fn.executable("tree-sitter") ~= 1 then
	vim.schedule(function()
		vim.notify(
			"Tree-sitter CLI not found!\nInstall 'tree-sitter-cli' to enable parser compilation.",
			vim.log.levels.ERROR,
			{ title = "Tree-sitter" }
		)
	end)
end

local parsers = {
	"sql",
	"asm",
	"c",
	"lua",
	"vim",
	"vimdoc",
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

local ok, ts = pcall(require, "nvim-treesitter")
if ok then
	local ts_path = vim.fn.stdpath("data") .. "/site";

	ts.setup({
		install_dir = ts_path,
	});

	ts.install(parsers, { summary = false });
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
		if lang then
			pcall(vim.treesitter.start, args.buf, lang)
		end
	end,
});

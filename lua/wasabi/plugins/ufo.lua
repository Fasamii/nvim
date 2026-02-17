local ts_only = {
	"lua",
	"python",
	"markdown",
}

require("ufo").setup({
	provider_selector = function(bufnr, filetype, buftype)
		if vim.tbl_contains(ts_only, filetype) then
			return { "treesitter", "indent" };
		end
		return { "lsp", "treesitter" };
	end,

	fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local suffix = ("  %d lines"):format(endLnum - lnum)
		local sufWidth = vim.fn.strdisplaywidth(suffix)
		local targetWidth = width - sufWidth
		local curWidth = 0

		for _, chunk in ipairs(virtText) do
			local chunkText = chunk[1]
			local chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if targetWidth > curWidth + chunkWidth then
				table.insert(newVirtText, chunk)
			else
				chunkText = truncate(chunkText, targetWidth - curWidth)
				table.insert(newVirtText, { chunkText, chunk[2] })
				chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if curWidth + chunkWidth < targetWidth then
					suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
				end
				break
			end
			curWidth = curWidth + chunkWidth
		end

		table.insert(newVirtText, { suffix, "MoreMsg" })
		return newVirtText
	end,
});

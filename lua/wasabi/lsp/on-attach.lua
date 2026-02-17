return function(client, bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	require("wasabi.keymaps").lsp_attach(bufnr);

	-- Inlay hints (0.10+)
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	-- CodeLens
	if client.server_capabilities.codeLensProvider then
		local codelens_group = vim.api.nvim_create_augroup("LspCodeLens_" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			group = codelens_group,
			buffer = bufnr,
			callback = function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end,
		})
	end

	-- Document highlight (0.12+)
	if client.server_capabilities.documentHighlightProvider then
		local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = highlight_group,
			buffer = bufnr,
			callback = function() vim.lsp.buf.document_highlight() end,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = highlight_group,
			buffer = bufnr,
			callback = function() vim.lsp.buf.clear_references() end,
		})
	end
end

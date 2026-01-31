require("wasabi.lsp.servers");
require("wasabi.lsp.completion")

local capabilities = vim.lsp.protocol.make_client_capabilities();
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities);
capabilities.workspace = capabilities.workspace or {};
capabilities.workspace.didChangeWatchedFiles = {
	dynamicRegistration = true,
	relativePatternSupport = true,
}

local on_attach = function(client, bufnr)
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

local servers = require("wasabi.lsp.configs");

for server, config in pairs(servers) do
	config.capabilities = config.capabilities or capabilities;
	config.on_attach = on_attach;
	vim.lsp.config(server, config);
	vim.lsp.enable(server);
end

local format_on_save_group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = format_on_save_group,
	pattern = { "*.rs", "*.c", "*.cpp", "*.h", "*.lua", "*.py", "*.js", "*.ts" },
	callback = function()
		-- Use new 0.12.0+ async formatting
		vim.lsp.buf.format({
			async = false,
			timeout_ms = 2000,
		})
	end,
})

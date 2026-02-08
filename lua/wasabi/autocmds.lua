vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	callback = function()
		vim.hl.on_yank({
			timeout = 30,
		})
	end
})

-- vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "WinLeave" }, {
-- 	desc = "Cursorline only in active window",
-- 	callback = function(args)
-- 		if vim.bo[args.buf].buftype ~= "" then return end
-- 		vim.opt_local.cursorline = args.event ~= "WinLeave"
-- 	end,
-- })

local function guess_the_indent(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then return end

	-- don't apply if .editorconfig is in effect
	local ec = vim.b[bufnr].editorconfig
	if ec and (ec.indent_style or ec.indent_size or ec.tab_width) then return end

	-- guess indent from first indented line
	local indent
	local maxToCheck = math.min(30, vim.api.nvim_buf_line_count(bufnr))
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, maxToCheck, false)
	for lnum = 1, #lines do
		-- require at least two spaces to avoid jsdoc setting indent to 1, etc.
		indent = lines[lnum]:match("^  +") or lines[lnum]:match("^\t*")
		if #indent > 0 then break end
	end
	if not indent then return end
	local spaces = indent:match(" +")
	if vim.bo[bufnr].ft == "markdown" then
		if not spaces then return end -- no indented line
		if #spaces == 2 then return end -- 2 space indents from hardwrap, not real indent
	end

	-- apply if needed
	local opts = { title = "Lucky indent", icon = "󰉶" }
	if spaces and (not vim.bo.expandtab or vim.bo[bufnr].shiftwidth ~= #spaces) then
		vim.bo[bufnr].expandtab = true
		vim.bo[bufnr].shiftwidth = #spaces
		vim.notify_once(("Set indentation to %d spaces."):format(#spaces), nil, opts)
	elseif not spaces and vim.bo.expandtab then
		vim.bo[bufnr].expandtab = false
		vim.notify_once("Set indentation to tabs.", nil, opts)
	end
end

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Find and apply the indentation of the current buffer",
	callback = function(ctx)
		vim.defer_fn(function() guess_the_indent(ctx.buf) end, 100)
	end,
})

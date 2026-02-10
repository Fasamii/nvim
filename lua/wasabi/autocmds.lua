vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	callback = function()
		vim.hl.on_yank({
			timeout = 30,
		})
	end
})

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

-- Do not pollute buffer list with terminal buffers
-- Close terminal after exit if status code is 0
local keep_open = {
	{ "cargo", "run" },
	{ "cargo", "check" },
};

local function parse_command(cmd)
	local words = vim.split(cmd, "%s+")
	local non_flag_words = {};

	for _, word in ipairs(words) do
		if not word:match("^%-") then
			table.insert(non_flag_words, word);
		end
	end

	return non_flag_words;
end

local function should_keep_open(words)
	for _, keep_open_word in ipairs(keep_open) do
		local matches = true;

		for i, part in ipairs(keep_open_word) do
			if words[i] ~= part then
				matches = false;
				break;
			end
		end

		if matches and #keep_open_word > 0 then
			return true;
		end
	end

	return false;
end

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function(args)
		vim.bo[args.buf].buflisted = false
		vim.bo[args.buf].bufhidden = "wipe";

		local bufname = vim.api.nvim_buf_get_name(args.buf);
		local cmd = bufname:match("term://.*//[0-9]+:(.*)");

		if cmd and should_keep_open(parse_command(cmd)) then
			vim.b[args.buf].keep_open = true;
		end
	end,
})

vim.api.nvim_create_autocmd("TermClose", {
	callback = function(args)
		local bufnr = args.buf;
		local ev = vim.v.event;

		if ev.status ~= 0 then
			return;
		end

		if vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr].keep_open then
			return;
		end

		for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, false);
			end
		end
	end
})

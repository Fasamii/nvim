vim.opt.foldmethod = "expr";
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()";

vim.opt.foldminlines = 3;
vim.opt.foldlevel = 99;


vim.opt.foldtext = "";
-- SHIT IS FUCKING BROKEN
-- ·················· that cool fold char
-- vim.opt.foldtext = "v:lua.CustomFoldText()"
-- function _G.CustomFoldText()
-- 	local line = vim.fn.getline(vim.v.foldstart)
--
-- 	-- Get diagnostics in the folded range
-- 	local diagnostics = vim.diagnostic.get(0, {
-- 		lnum_start = vim.v.foldstart - 1,
-- 		lnum_end = vim.v.foldend - 1
-- 	})
--
-- 	-- Count errors and warnings
-- 	local errors = 0
-- 	local warnings = 0
-- 	for _, diag in ipairs(diagnostics) do
-- 		if diag.severity == vim.diagnostic.severity.ERROR then
-- 			errors = errors + 1
-- 		elseif diag.severity == vim.diagnostic.severity.WARN then
-- 			warnings = warnings + 1
-- 		end
-- 	end
--
-- 	-- Calculate available width
-- 	local win_width = vim.api.nvim_win_get_width(0)
-- 	local num_col_width = vim.wo.numberwidth + vim.wo.foldcolumn
-- 	if vim.wo.signcolumn ~= "no" then
-- 		num_col_width = num_col_width + 2
-- 	end
-- 	local text_width = win_width - num_col_width
--
-- 	-- Calculate display width (accounts for tabs)
-- 	local line_len = vim.fn.strdisplaywidth(line)
--
-- 	-- Build diagnostic text if needed
-- 	local diag_text = ""
-- 	if errors > 0 and warnings > 0 then
-- 		diag_text = "[E-" .. errors .. " W-" .. warnings .. "]"
-- 	elseif errors > 0 then
-- 		diag_text = "[E-" .. errors .. "]"
-- 	elseif warnings > 0 then
-- 		diag_text = "[W-" .. warnings .. "]"
-- 	end
--
-- 	local diag_len = vim.fn.strdisplaywidth(diag_text)
-- 	local end_dots = 3 -- Always 3 dots at the end
--
-- 	-- Calculate dots needed
-- 	local dots_needed = text_width - line_len - 1 -- 1 for space after line
--
-- 	if diag_len > 0 then
-- 		-- Format: line · [diag] ···
-- 		dots_needed = dots_needed - diag_len - 1 - end_dots - 1 -- spaces around diag and end dots
-- 	else
-- 		-- Format: line ·················
-- 		-- dots fill to the end
-- 	end
--
-- 	if dots_needed < 1 then
-- 		dots_needed = 1 -- At least one dot
-- 	end
--
-- 	-- Build the result - preserve original line with tabs intact
-- 	local result = line .. " " .. string.rep("·", dots_needed)
--
-- 	if diag_len > 0 then
-- 		result = result .. " " .. diag_text .. " " .. string.rep("·", end_dots)
-- 	end
--
-- 	return result
-- end

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

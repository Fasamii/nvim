local M = {};

function M.set(mode, keymap, what, desc, opts)
	opts = opts or {};
	opts.desc = desc;
	opts.noremap = opts.noremap ~= false;

	vim.keymap.set(mode, keymap, what, opts);
end

function M.notify(msg, level, opts)
	vim.schedule(function()
		vim.notify(msg, level, opts)
	end)
end

function M.find_git_root(path)
	local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(path) .. " rev-parse --show-toplevel")
		[1];
	if vim.v.shell_error == 0 then
		return git_root;
	end
	return nil;
end

function M.set_pwd(path)
	local ok, _ = pcall(vim.cmd, "cd " .. path);
	if ok then
		M.notify("set pwd to: " .. path, vim.log.levels.INFO, {
			timeout = 3000,
		});
	else
		error("Failed to set pwd: " .. path);
	end
end

return M;

local cmds = {
	-- TODO: Remove these if plugin author removes it
	"Autosession",
	"SessionSave",
	"SessionRestore",
	"SessionDelete",
	"SessionSearch",
	"SessionDisableAutoSave",
	"SessionToggleAutoSave",
	"SessionPurgeOrphaned",
}

for _, cmd in ipairs(cmds) do
	pcall(vim.api.nvim_del_user_command, cmd)
end

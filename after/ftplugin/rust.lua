-- Kill rust.vim command spam
local cmds = {
	"RustRun",
	"RustExpand",
	"RustEmitIr",
	-- "RustEmitAsm", -- Cool
	"RustPlay",
	"RustFmt",
	"RustFmtRange",
	"RustInfo",
	"RustInfoToClipboard",
	"RustInfoToFile",
	"RustTest",
	-- "Cargo", -- Useful
	"Cbuild",
	"Ccheck",
	"Cclean",
	"Cdoc",
	"Cnew",
	"Cinit",
	"Crun",
	"Ctest",
	"Cbench",
	"Cupdate",
	"Csearch",
	"Cpublish",
	"Cinstall",
	"Cruntarget",
}

for _, cmd in ipairs(cmds) do
	pcall(vim.api.nvim_del_user_command, cmd)
end

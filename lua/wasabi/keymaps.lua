local M = {};

local KEYMAP_REGISTRY = {}
local function set(mode, keymap, what, desc, opts)
	local modes;
	if type(mode) == "string" then
		modes = {};
		for m in mode:gmatch("[^,%s]+") do
			table.insert(modes, m);
		end
	else
		modes = mode;
	end

	KEYMAP_REGISTRY[keymap] = KEYMAP_REGISTRY[keymap] or {}
	for _, m in ipairs(modes) do
		for _, existing in ipairs(KEYMAP_REGISTRY[keymap]) do
			if existing == m then
				-- error(string.format("Keymap '%s' already registered in mode '%s'", keymap, m))
			end
		end
		table.insert(KEYMAP_REGISTRY[keymap], m)
	end

	local opts = opts or {};
	opts.desc = desc;
	opts.noremap = opts.noremap ~= false;

	vim.keymap.set(modes, keymap, what, opts);
end

-- MISC IMPORTANT

set({ "n", "v" }, "<Space>", "<Nop>", "Remove any action <Space> had", { silent = true });

-- GENERAL EDITING

set("n", "dr", "0D", "delete line without removing line");

set("v", "K", ":m '<-2<CR>gv-gv", "moves lines down in visual mode");
set("v", "J", ":m '>+1<CR>gv-gv", "moves lines down in visual mode");

set("v", "<", "<gv", "indent right without removing highlight");
set("v", ">", ">gv", "indent right without removing highlight");

-- BUFFER OPERATIONS

set("n", "<leader>fv", function()
	vim.cmd("normal! ggVG");
end, "Select entire buffer");
set("n", "<leader>fy", function()
	local pos = vim.fn.getpos(".");
	vim.cmd("normal! ggVG\"+y");
	vim.fn.setpos(".", pos);
end, "Copy entire buffer");

set("n", "<leader>rb", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	"Replace word under cursor for this buffer");

-- SPLITS

set("n", "<leader>sv", "<C-w>v", "split vertically");
set("n", "<leader>sp", "<C-w>h", "split horizontally");
set("n", "<leader>sd", "<cmd>close<CR>", "close current split");
set("n", "<leader>sh", "<C-w>h", "focus left split");
set("n", "<leader>sj", "<C-w>j", "focus bottom split");
set("n", "<leader>sk", "<C-w>k", "focus upper split");
set("n", "<leader>sl", "<C-w>l", "focus right split");
set("n", "<leader>srh", "<C-w>>", "resize split window (left)");
set("n", "<leader>srl", "<C-w><", "resize split window (right)");
set("n", "<leader>srk", "<C-w>+", "resize split window (up)");
set("n", "<leader>srj", "<C-w>-", "resize split window (down)");
set("n", "<leader>sr=", "<C-w>=", "resize split window (left)");

-- TABS

set("n", "<leader>wn", "<cmd>tabnew<CR>", "create new tab");
set("n", "<leader>wd", "<cmd>tabclose<CR>", "close current tab");
set("n", "<leader>wh", "<cmd>tabp<CR>", "focus previous tab");
set("n", "<leader>wl", "<cmd>tabn<CR>", "focus next tab");

-- FILE EXPLORER

set("n", "<leader>fe", vim.cmd.Ex, "open NetRw");

-- SPELL

set("n", "zz", function()
	vim.opt.spell = not vim.opt.spell:get()
end, "toggle spell checking");
set("n", "zn", "]s", "focus next spelling error");
set("n", "zp", "[s", "focus previous spelling error");
set("n", "zg", "zg", "mark word as correct");
set("n", "zw", "zw", "mark word as incorrect");
set("n", "zr", function()
	vim.cmd("normal! zuw");
	vim.cmd("normal! zug");
end, "Remove word from dictionary");

function M.telescope(builtin)
	-- FILES
	set("n", "<leader>fs", builtin.find_files, "find files");
	set("n", "<leader>fp", builtin.git_files, "find files in git repo");
	set("n", "<leader>fo", builtin.oldfiles, "find recent files");
	-- TEXT
	set("n", "<leader>fg", builtin.live_grep, "find Grep");
	-- SPELL
	set("n", "zs", builtin.spell_suggest, "spell suggestions");
	-- GIT
	set("n", "<leader>gc", builtin.git_commits, "git commits");
	set("n", "<leader>gC", builtin.git_bcommits, "git commits (buffer)");
	set("n", "<leader>gb", builtin.git_branches, "git branches");
	set("n", "<leader>gs", builtin.git_status, "git status");
	set("n", "<leader>gS", builtin.git_stash, "git stash");
	-- LSP
	set("n", "<leader>lr", builtin.lsp_references, "LSP references");
	set("n", "<leader>ld", builtin.lsp_definitions, "LSP definitions");
	set("n", "<leader>lD", builtin.lsp_type_definitions, "LSP type definitions");
	set("n", "<leader>li", builtin.lsp_implementations, "LSP implementations");
	set("n", "<leader>ls", builtin.lsp_document_symbols, "LSP document symbols");
	set("n", "<leader>lS", builtin.lsp_workspace_symbols, "LSP workspace symbols");
	set("n", "<leader>lw", builtin.lsp_dynamic_workspace_symbols, "LSP dynamic workspace symbols");
	set("n", "<leader>le", builtin.diagnostics, "LSP diagnostics");
end

-- TODO: Review that keymaps
function M.todo_comments()
	vim.keymap.set("n", "<leader>tl", "<cmd>TodoTelescope<cr>", { desc = "list all labels" });
	vim.keymap.set("n", "<leader>tfl", "<cmd>TodoTelescope keywords=FIX,FIXME,BUG,FIXIT,ISSUE,ERR<cr>",
		{ desc = "list all FIXME labels" });
	vim.keymap.set("n", "<leader>ttl", "<cmd>TodoTelescope keywords=TODO,LATER<cr>", { desc = "list all TODO labels" });
	vim.keymap.set("n", "<leader>twl", "<cmd>TodoTelescope keywords=WARN,WARNING,XXX<cr>",
		{ desc = "list all WARN labels" });
	vim.keymap.set("n", "<leader>til", "<cmd>TodoTelescope keywords=NOTE,INFO<cr>", { desc = "list all NOTE labels" });
	vim.keymap.set("n", "<leader>tol", "<cmd>TodoTelescope keywords=PERF,OPTIM,PERFORMANCE,OPTIMIZE<cr>",
		{ desc = "list all PERF labels" });
	vim.keymap.set("n", "<leader>tel", "<cmd>TodoTelescope keywords=TEST,TESTING,PASSED,FAILED<cr>",
		{ desc = "list all TEST labels" });

	vim.keymap.set("n", "<leader>tn", function() require("todo-comments").jump_next() end, { desc = "Next label" });
	vim.keymap.set("n", "<leader>tp", function() require("todo-comments").jump_prev() end, { desc = "Previous label" });

	vim.keymap.set("n", "<leader>tfn",
		function() require("todo-comments").jump_next({ keywords = { "FIX", "FIXME", "BUG", "FIXIT", "ISSUE", "ERR" } }) end,
		{ desc = "Next FIXME label" });
	vim.keymap.set("n", "<leader>tfp",
		function() require("todo-comments").jump_prev({ keywords = { "FIX", "FIXME", "BUG", "FIXIT", "ISSUE", "ERR" } }) end,
		{ desc = "Prev FIXME label" });

	vim.keymap.set("n", "<leader>ttn",
		function() require("todo-comments").jump_next({ keywords = { "TODO", "LATER" } }) end,
		{ desc = "Next TODO label" });
	vim.keymap.set("n", "<leader>ttp",
		function() require("todo-comments").jump_prev({ keywords = { "TODO", "LATER" } }) end,
		{ desc = "Prev TODO label" });

	vim.keymap.set("n", "<leader>twn",
		function() require("todo-comments").jump_next({ keywords = { "WARN", "WARNING", "XXX" } }) end,
		{ desc = "Next WARN label" });
	vim.keymap.set("n", "<leader>twp",
		function() require("todo-comments").jump_prev({ keywords = { "WARN", "WARNING", "XXX" } }) end,
		{ desc = "Prev WARN label" });

	vim.keymap.set("n", "<leader>tin",
		function() require("todo-comments").jump_next({ keywords = { "NOTE", "INFO" } }) end,
		{ desc = "Next NOTE label" });
	vim.keymap.set("n", "<leader>tip",
		function() require("todo-comments").jump_prev({ keywords = { "NOTE", "INFO" } }) end,
		{ desc = "Prev NOTE label" });

	vim.keymap.set("n", "<leader>ton",
		function() require("todo-comments").jump_next({ keywords = { "PERF", "OPTIM", "PERFORMANCE", "OPTIMIZE" } }) end,
		{ desc = "Next PERF label" });
	vim.keymap.set("n", "<leader>top",
		function() require("todo-comments").jump_prev({ keywords = { "PERF", "OPTIM", "PERFORMANCE", "OPTIMIZE" } }) end,
		{ desc = "Prev PERF label" });

	vim.keymap.set("n", "<leader>ten",
		function() require("todo-comments").jump_next({ keywords = { "TEST", "TESTING", "PASSED", "FAILED" } }) end,
		{ desc = "Next TEST label" });
	vim.keymap.set("n", "<leader>tep",
		function() require("todo-comments").jump_prev({ keywords = { "TEST", "TESTING", "PASSED", "FAILED" } }) end,
		{ desc = "Prev TEST label" });
end

function M.auto_session()
	vim.keymap.set("n", "<leader>rs", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" });
end

function M.lsp_attach(bufnr)
	local function buf_set(mode, keymap, what, desc)
		set(mode, keymap, what, desc, { buffer = bufnr });
	end

	-- NAVIGATION
	buf_set("n", "gd", vim.lsp.buf.definition, "go to definition")
	buf_set("n", "gD", vim.lsp.buf.declaration, "go to declaration")
	buf_set("n", "gi", vim.lsp.buf.implementation, "go to implementation")
	buf_set("n", "gr", vim.lsp.buf.references, "show references")
	buf_set("n", "gt", vim.lsp.buf.type_definition, "go to type definition")
	-- DOCUMENTATION
	buf_set("n", "K", vim.lsp.buf.hover, "show hover documentation")
	buf_set("n", "<C-k>", vim.lsp.buf.signature_help, "show signature help")
	-- ACTIONS
	buf_set("n", "<leader>ca", vim.lsp.buf.code_action, "code action")
	buf_set("n", "<leader>cr", vim.lsp.buf.rename, "rename symbol")
	buf_set("n", "<leader>cf", function()
		vim.lsp.buf.format({ async = true })
	end, "format document")

	-- DIAGNOSTICS
	buf_set("n", "[d", vim.diagnostic.goto_prev, "previous diagnostic")
	buf_set("n", "]d", vim.diagnostic.goto_next, "next diagnostic")
	buf_set("n", "<leader>cd", vim.diagnostic.open_float, "show diagnostic")
	buf_set("n", "<leader>cq", vim.diagnostic.setloclist, "diagnostics to loclist")

	-- WORKSPACE
	buf_set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "add workspace folder")
	buf_set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "remove workspace folder")
	buf_set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "list workspace folders")
end

return M;

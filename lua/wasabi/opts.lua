-- Global leader key used as a prefix for custom keybindings
-- Must be set before defining any <leader> mappings
vim.g.mapleader = " ";
-- Local leader key, used mainly for filetype-specific mappings
vim.g.maplocalleader = "~";
-- Timeout (in milliseconds) for mapped key sequences
-- Affects how long nvim waits after pressing <leader>
vim.opt.timeoutlen = 300

-- Enables full 24-bit RGB color
vim.opt.termguicolors = true;
-- Enables mouse support in specified modes
-- Values:
--	"" - disabled
--	"a" - all
--	combination of "nvi" - selective
vim.opt.mouse = "nv";
-- Highlights the screen line the cursor is currently on
vim.opt.cursorline = true;

-- Show absolute line number on the current line
vim.opt.number = true
-- Show relative line numbers on all other lines
vim.opt.relativenumber = true;
-- Column used to display signs (diagnostics, git, breakpoints)
-- Values:
--	"number" - overlays them on the line number column to save space
--	"yes" - TODO:
--	"no" - TODO:
--	"auto" - TODO:
vim.opt.signcolumn = "number";
-- Height of the command line
vim.opt.cmdheight = 0;
-- Statusline behaviour with multiple buffers
-- Values:
--	0 - never
--	1 - only with splits
--	2 - per window
--	3 - global (neovim only)
vim.opt.laststatus = 3;

-- Visually wrap long lines instead of horizontal scrolling
vim.opt.wrap = true;
-- Wrap lines at word boundaries instead of breaking words
-- Only has effect when "wrap" is enabled
vim.opt.linebreak = true;
-- Indents wrapped lines to match the indentation of the original line
-- Improves readability of wrapped code and comments
vim.opt.breakindent = true;
-- Minimum number of context lines kept above and below the cursor
vim.opt.scrolloff = 999;
-- Minimum number of context lines kept to the left and right of cursor
vim.opt.sidescrolloff = 8;
-- Allows cursor movement into "virtual" space
-- Values:
--	"block" - only in Visual Block mode (safest useful option)
--	"onemore" - one char past EOL
--  "all" - anywhere (can break assumptions)
vim.opt.virtualedit = "block";

local tab_size = 4; -- TODO: Make some global table wit settings like that
-- Use literal tab characters (\t) instead of spaces
-- false = tabs, true = spaces
vim.opt.expandtab = false;
-- Visual width of a tab character
vim.opt.tabstop = tab_size;
-- Number of spaces inserted/removed when pressing <Tab>/<BS>
vim.opt.softtabstop = tab_size;
-- Number of spaces used for autoindent and << / >> shifts
vim.opt.shiftwidth = tab_size;
-- Copies indentation from the previous line
vim.opt.autoindent = true;
-- Adds simple syntax-aware indentation (mainly C-like languages)
-- Often superseded by LSP or tree-sitter indentation
vim.opt.smartindent = true;

-- Live preview of :substitute commands
-- "split" shows results in a temporary split window
vim.opt.inccommand = "split";
-- New horizontal splits open below the current window
vim.opt.splitbelow = true;
-- New vertical splits open to the right of the current window
vim.opt.splitright = true;
-- Keep screen position on split
vim.opt.splitkeep = "screen";

local backup_dir = os.getenv("HOME") .. "/.backup/nvim"
vim.fn.mkdir(backup_dir .. "/undo", "p")
vim.fn.mkdir(backup_dir .. "/backup", "p")
vim.fn.mkdir(backup_dir .. "/swap", "p")

-- Directory for persistent undo files
vim.opt.undodir = backup_dir .. "/undo"
-- Enables persistent undo across sessions
vim.opt.undofile = true;
-- Directory for backup files (~).
vim.opt.backupdir = backup_dir .. "/backup"
-- Skip backup creation for
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
-- Enables backup file creation before overwriting
vim.opt.backup = true;
-- Directory for swap files
vim.opt.directory = backup_dir .. "/swap"
-- Enables swap files for crash recovery and file-lock detection
vim.opt.swapfile = true;

-- Directory for spell files
local spell_dir = vim.fn.stdpath("config") .. "/spelldir";
vim.fn.mkdir(spell_dir, "p");
vim.opt.spellfile = spell_dir .. "/spellfile.utf-8.add";
-- Spell checking
vim.opt.spell = true;
-- Spell checking language
vim.opt.spelllang = "en_us,pl";

-- Case insensitive seach
vim.opt.ignorecase = true
-- Case sensitive search when uppercase letters are used
vim.opt.smartcase = true
-- Show search results while typing
vim.opt.incsearch = true
-- Disables persistent search highlighting
vim.opt.hlsearch = true;

-- Clipboard integration with system clipboard
vim.opt.clipboard = "unnamedplus";

-- Draws a vertical guideline
-- Accepts comma-separated list: "80,100"
vim.opt.colorcolumn = "80,100";
-- Enables .editorconfig support
-- Editorconfig can override tab/indent options per project
vim.g.editorconfig = true;

-- Disable the netrw banner
vim.g.netrw_banner = 0;
-- Directory listing style
-- 0 = simple, 1 = detailed, 2 = wide, 3 = tree view
vim.g.netrw_liststyle = 3;
-- netrw window size as a percentage of the screen width
vim.g.netrw_winsize = 8;
-- Sorting method: "name", "time", "size", "ext"
vim.g.netrw_sort_by = "name";
-- Shell command used to copy directories
vim.g.netrw_localcopydircmd = "cp -r";
-- Shell command used to remove directories
vim.g.netrw_localrmdir = "rm -ri";
-- Directory browsing cache behavior
-- 0 = no cache, 1 = moderate caching, 2 = aggressive caching
vim.g.netrw_fastbrowse = 1;
-- TODO:
vim.g.netrw_altv = 1

-- TODO:
vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- Popup menu height
vim.opt.pumheight = 10

-- Time in milliseconds before CursorHold events and diagnostics update
vim.opt.updatetime = 50;
-- LSP diagnostics config
vim.diagnostic.config({
	-- Inline virtual text diagnostics
	virtual_text = {
		severity = { max = vim.diagnostic.severity.WARN },
		source = "if_many",
		prefixx = "[!]",
		spacing = 4,
	},
	-- Full-width virtual lines
	virtual_lines = { severity = { min = vim.diagnostic.severity.ERROR } },
	-- Diagnostic underlines
	underline = false,
	-- Update diagnostics while typing
	update_in_insert = false,
	-- Sort diagnostics by severity
	severity_sort = true,
	-- Floating diagnostic window appearance
	float = {
		focusable = false,
		style = "minimal",
		border = "solid",
		source = "always",
		header = "",
		prefix = "",
		suffix = "",
	},

	-- signs = {
	-- 	text = {
	-- 		[vim.diagnostic.severity.ERROR] = "E",
	-- 		[vim.diagnostic.severity.WARN] = "W",
	-- 		[vim.diagnostic.severity.INFO] = "i",
	-- 		[vim.diagnostic.severity.HINT] = "H",
	-- 	},
	-- },
	-- Gutter signs
	signs = false,
});




-- NOTE: Below ones are these that I'm not sure if i like

-- Delays redraws during macros and scripts
vim.opt.lazyredraw = false

vim.opt.smoothscroll = true;

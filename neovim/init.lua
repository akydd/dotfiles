vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugins with their options
require("lazy").setup({
	{
		-- Theme
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			vim.o.background = "dark" -- or "light" for light mode
			vim.cmd([[colorscheme gruvbox]])
		end
	},

	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = "gruvbox",
			}
		}
	},

	{
		-- Filesystem browsing
		'stevearc/oil.nvim',
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	"kyazdani42/nvim-web-devicons",
	"tpope/vim-sleuth",
	"nathom/tmux.nvim",
	"tpope/vim-fugitive",

	-- Clojure
	'jiangmiao/auto-pairs',
	"Olical/conjure",
	{
		'TreyBastian/nvim-jack-in',
		config = true,
		opts = {
			location = 'background',
		},
	},
	{
		"julienvincent/nvim-paredit",
		config = function()
			require("nvim-paredit").setup()
		end
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},

	{
		-- LSP
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ 'williamboman/mason.nvim', config = true },
			'williamboman/mason-lspconfig.nvim',

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim',       opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
	},

	{
		'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
		config = function()
		end
	},

	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp"
	},
	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
	},

	{
		-- indentation guides
		'lukas-reineke/indent-blankline.nvim',
		main = "ibl",
		opts = {
			indent = { char = '┊' },
		},
	},

	{ 'numToStr/Comment.nvim',         opts = {} },

	-- telescope + fzf
	{ 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	},

	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
	},

	{
		-- Treesitter
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ":TSUpdate",
	},


	-- debugging!
	{
		'mxsdev/nvim-dap-vscode-js',
		dependencies = {
			'mfussenegger/nvim-dap'
		},
	},
	{
		'microsoft/vscode-js-debug',
		run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio"
		},
	},
	{
		'mfussenegger/nvim-dap',
		dependencies = {
			-- Creates a beautiful debugger UI
			'rcarriga/nvim-dap-ui',

			'theHamsta/nvim-dap-virtual-text',

			-- Installs the debug adapters for you
			'williamboman/mason.nvim',
			'jay-babu/mason-nvim-dap.nvim',

			-- Add your own debuggers here
			'microsoft/vscode-js-debug'
		},
		config = function()
			local dap = require 'dap'
			local dapui = require 'dapui'
			local dapvirtualtxt = require 'nvim-dap-virtual-text'

			require('mason-nvim-dap').setup {
				-- Makes a best effort to setup the various debuggers with
				-- reasonable debug configurations
				automatic_setup = true,

				-- You can provide additional configuration to the handlers,
				-- see mason-nvim-dap README for more information
				handlers = {},

				-- You'll need to check that you have the required things installed
				-- online, please don't ask me how to install them :)
				ensure_installed = {
					-- Update this to ensure that you have the debuggers for the langs you want
					'delve',
				},
			}

			-- Basic debugging keymaps, feel free to change to your liking!
			vim.keymap.set('n', '<F5>', dap.continue)
			vim.keymap.set('n', '<F1>', dap.step_into)
			vim.keymap.set('n', '<F2>', dap.step_over)
			vim.keymap.set('n', '<F3>', dap.step_out)
			vim.keymap.set('n', '<leader>B', dap.toggle_breakpoint)
			-- vim.keymap.set('n', '<leader>B', function()
			-- 	dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
			-- end)

			dapvirtualtxt.setup()

			-- Dap UI setup
			-- For more information, see |:help nvim-dap-ui|
			dapui.setup {
				-- Set icons to characters that are more likely to work in every terminal.
				--    Feel free to remove or use ones that you like more! :)
				--    Don't feel like these are good choices.
				icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
				controls = {
					icons = {
						pause = '⏸',
						play = '▶',
						step_into = '⏎',
						step_over = '⏭',
						step_out = '⏮',
						step_back = 'b',
						run_last = '▶▶',
						terminate = '⏹',
						disconnect = "⏏",
					},
				},
			}

			-- toggle to see last session result. Without this ,you can't see session output in case of unhandled exception.
			vim.keymap.set("n", "<F7>", dapui.toggle)

			dap.listeners.after.event_initialized['dapui_config'] = dapui.open
			dap.listeners.before.event_terminated['dapui_config'] = dapui.close
			dap.listeners.before.event_exited['dapui_config'] = dapui.close

			-- Install golang specific config
			-- require('dap-go').setup()
			require("dap-vscode-js").setup({
				-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
				debugger_path = vim.fn.stdpath('data') .. "/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
				-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
				adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
				-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
				-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
				-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
			})

			for _, language in ipairs({ "typescript", "javascript" }) do
				require("dap").configurations[language] = {
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require 'dap.utils'.pick_process,
						cwd = "${workspaceFolder}",
					}

				}
			end
		end,
	},
}, {})

-- NeoVim settings
vim.opt.cursorline = true
vim.o.termguicolors = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.o.hlsearch = false
vim.o.completeopt = 'menuone,noselect'
vim.o.breakindent = true
vim.wo.number = true

-- Telescope settings
require('telescope').setup {
	defaults = {
		mappings = {
			-- n = {
			-- 	["q"] = require('telescope.actions').close
			-- }
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
		file_ignore_patterns = {
			"node_modules",
		}
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			case_mode = "ignore_case", -- ignore case
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
		}
	}
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

local tb = require 'telescope.builtin'
-- Find files
vim.keymap.set("n", "<leader>o", tb.find_files)
-- Grep string under cursor
vim.keymap.set("n", "<leader>s", tb.grep_string)
-- Live grep files
vim.keymap.set("n", "<leader>r", tb.live_grep)
-- List buffers
vim.keymap.set("n", "<leader>b", tb.buffers)
-- Pick git branch
vim.keymap.set("n", "<leader>gb", tb.git_branches)
-- symbols
vim.keymap.set("n", "<leader>t", tb.lsp_document_symbols)
-- file explorer
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<cr>")
-- diagnostics
vim.keymap.set("n", "<leader>d", tb.diagnostics)
-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
	virtual_text = false,
})

-- Treesitter
require 'nvim-treesitter.configs'.setup {
	ensure_installed = { 'c', 'cpp', 'go', 'lua', 'tsx', 'typescript', 'clojure' },
	highlight = {
		enable = true
	},

	-- expand
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = '<c-space>',
			node_incremental = '<c-space>',
		},
	},

	-- tree sitter text objects
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["ab"] = "@block.outer",
				["ib"] = "@block.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				['<leader>a'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>A'] = '@parameter.inner',
			},
		},
	},
}

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>pe", vim.diagnostic.goto_prev, {})
vim.keymap.set("n", "<leader>ne", vim.diagnostic.goto_next, {})
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, {})
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })


-- LSP
local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('gn', vim.lsp.buf.rename, 'Re{n]ame')
	nmap('gd', vim.lsp.buf.definition, '[d]efinition')
	nmap('gD', vim.lsp.buf.declaration, '[D]eclaration')
	nmap('gr', require('telescope.builtin').lsp_references, '[r]eferences')
	nmap('gI', vim.lsp.buf.implementation, '[I]mplementation')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
	nmap('<leader>k', vim.lsp.buf.hover, 'Hover Documentation')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

local servers = {
	-- clangd = {},
	gopls = {},
	golangci_lint_ls = {
		init_options = {
			command = {}
		}
	},
	-- pyright = {},
	-- rust_analyzer = {},
	ts_ls = {},
	clojure_lsp = {},

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		}
	end,
}

require("lsp_lines").setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete {},
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}

-- Tmux nav
local opts = { noremap = true, silent = true }
local tmux = require 'tmux'
vim.keymap.set("n", "<C-h>", tmux.move_left, opts)
vim.keymap.set("n", "<C-j>", tmux.move_down, opts)
vim.keymap.set("n", "<C-k>", tmux.move_up, opts)
vim.keymap.set("n", "<C-l>", tmux.move_right, opts)

-- Easy exit of terminal mode
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", opts)

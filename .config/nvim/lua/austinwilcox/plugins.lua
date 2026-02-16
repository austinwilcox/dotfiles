local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local utils = require("austinwilcox.utils")

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

local plugins = {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			auto_install = true,
			ensure_installed = {
				"bash",
				"c_sharp",
				"clojure",
				"css",
				"go",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"r",
				"rnoweb",
				"regex",
				"rust",
				"scss",
				"sql",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = true,
			},
			indent = { enable = true, disable = { "yaml" } },
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						-- NOTE: You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["ii"] = "@conditional.inner",
						["ai"] = "@conditional.outer",
						["il"] = "@loop.inner",
						["al"] = "@loop.outer",
						["at"] = "@comment.outer",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		},
		dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)
		end,
	},
	{
		"austinwilcox/hex2rgba",
		event = "VeryLazy",
	},
	{
		"austinwilcox/ZKMoveFile",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("ZKMoveFile").setup({
				dir = "/home/austin/Zettelkasten-V2",
				permanent_notes_dir = "Permanent Notes",
				title = "ZK Directories",
				layers = 1,
			})
		end,
	},
	{
		"austinwilcox/jsonhero.nvim",
		event = "VeryLazy",
		config = function()
			require("jsonhero").setup({})
		end,
	},
	{
		-- NOTE: To get Telescope live grep working you need ripgrep
		-- Ubuntu/Debian based
		-- sudo apt install ripgrep
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})
			-- NOTE: To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("todo-comments").setup({})
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"github/copilot.vim",
	},
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"hrsh7th/cmp-buffer",
	},
	{
		"hrsh7th/cmp-nvim-lsp-signature-help",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			-- local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			local has_words_before = function()
				if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
					return false
				end
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						-- luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-x>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					-- ["<CR>"] = cmp.mapping(function(fallback)
					--   if cmp.visible() and cmp.get_selected_entry() then
					--     cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
					--   else
					--     fallback()
					--   end
					-- end, { "i", "s" }),
				}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
						maxwidth = 50,
						symbol_map = { Copilot = "" },
					}),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp_signature_help" },
					-- { name = "nvim_lsp", max_item_count = 6 },
					{ name = "nvim_lsp" },
					-- { name = "luasnip" },
					{ name = "copilot" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
	{
		"lukas-reineke/lsp-format.nvim",
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ensure_installed = {
					"tsserver",
					"ts_ls",
					"cssls",
					-- "denols",
					"lua_ls",
					"rust_analyzer",
					"vls",
					"gopls",
					"marksman",
					"bashls",
					"eslint",
					"jsonls",
					"tailwindcss",
					"graphql",
					"html",
					"netcoredbg",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("austinwilcox.lsp")
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					-- null_ls.builtins.formatting.prettier,
					-- null_ls.builtins.diagnostics.eslint_d,
				},
			})

			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		end,
	},
	{
		"windwp/nvim-autopairs",
		enabled = true,
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"tpope/vim-commentary",
	},
	-- {
	-- 	"MunifTanjim/prettier.nvim",
	-- 	ft = { "css", "scss", "jsx", "tsx", "js", "html", "ts", "json", "graphql", "yaml", "markdown" },
	-- 	config = function()
	-- 		require("prettier").setup({
	-- 			bin = "prettier",
	-- 			filetypes = {
	-- 				"css",
	-- 				"graphql",
	-- 				"html",
	-- 				"javascript",
	-- 				"javascriptreact",
	-- 				"json",
	-- 				"less",
	-- 				"markdown",
	-- 				"scss",
	-- 				"typescript",
	-- 				"typescriptreact",
	-- 				"yaml",
	-- 			},
	-- 		})
	-- 	end,
	-- },
	-- {
	--   "shaunsingh/nord.nvim",
	--   lazy = false,
	--   priority = 1000,
	--   config = function()
	--     local colorscheme = "nord"
	--     local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
	--     if not status_ok then
	--       vim.notify("colorscheme " .. colorscheme .. " not found!")
	--       return
	--     end
	--   end,
	-- },
	-- {
	-- 	"ellisonleao/gruvbox.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		local colorscheme = "gruvbox"
	-- 		local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
	-- 		if not status_ok then
	-- 			vim.notify("colorscheme " .. colorscheme .. " not found!")
	-- 			return
	-- 		end
	-- 	end,
	-- },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local colorscheme = "tokyonight-storm"
			local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
			if not status_ok then
				vim.notify("colorscheme " .. colorscheme .. " not found!")
				return
			end
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"kyazdani42/nvim-web-devicons",
			opt = true,
		},
		config = function()
			require("lualine").setup({
				options = { theme = "gruvbox" },
			})
		end,
	},
	{
		"echasnovski/mini.surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("mini.surround").setup({})
		end,
	},
	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({
				-- NOTE: https://github.com/rmagatti/goto-preview#%EF%B8%8F-configuration
				width = 120,
				height = 30,
				border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
				default_mappings = false,
				debug = false,
				opacity = nil,
				post_open_hook = nil,
				focus_on_open = true,
				dismiss_on_move = false,
				force_close = true,
				bufhidden = "wipe",
			})
		end,
	},
	{
		"amrbashir/nvim-docs-view",
		lazy = true,
		cmd = "DocsViewToggle",
		opts = {
			position = "bottom",
		},
	},
	{
		"ThePrimeagen/git-worktree.nvim",
		config = function()
			require("telescope").load_extension("git_worktree")
			require("git-worktree").setup({
				update_on_change = true,
				clearjumps_on_change = true,
				autopush = false,
				autopull = true,
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{
		"folke/zen-mode.nvim",
		opts = {},
	},
	{
		"Hoffs/omnisharp-extended-lsp.nvim",
	},
	-- {
	-- 	"OmniSharp/omnisharp-vim",
	-- },
	{
		"chentoast/marks.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"MagicDuck/grug-far.nvim",
		config = function()
			require("grug-far").setup({})
		end,
	},
	{
		"R-nvim/R.nvim",
		lazy = false,
	},
	{
		"epwalsh/obsidian.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
		},
		version = "*",
		ft = "markdown",
		lazy = true,
		config = function()
			require("obsidian").setup({
				dir = "~/Zettelkasten-V2",
				note_id_func = function(title)
					-- NOTE: Create note IDs in a Zettelkasten format with a timestamp and a suffix.
					-- In this case a note with the title 'My new note' will given an ID that looks
					-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
					local suffix = ""
					if title ~= nil then
						suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
					else
						for _ = 1, 4 do
							suffix = suffix .. string.char(math.random(65, 90))
						end
					end
					return tostring(os.time()) .. "-" .. suffix
					-- return title
				end,
				daily_notes = {
					folder = "10-journals",
				},
				completion = {
					nvim_cmp = true,
					min_chars = 2,
				},
				mappings = {
					-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
					["gf"] = {
						action = function()
							return require("obsidian").util.gf_passthrough()
						end,
						opts = { noremap = false, expr = true, buffer = true },
					},
					-- Toggle check-boxes.
					["<leader>ch"] = {
						action = function()
							return require("obsidian").util.toggle_checkbox()
						end,
						opts = { buffer = true },
					},
					-- Smart action depending on context, either follow link or toggle checkbox.
					["<cr>"] = {
						action = function()
							return require("obsidian").util.smart_action()
						end,
						opts = { buffer = true, expr = true },
					},
				},
				new_notes_location = "current_dir",
				templates = {
					folder = "03-Resources/Templates",
				},
				finder = "telescope.nvim",
				open_notes_in = "current",
				disable_frontmatter = true,
				ui = {
					enable = false,
				},
				mapp,
			})
		end,
	},
	-- # Causes browser to crash when using within github
	-- { "glacambre/firenvim", build = ":call firenvim#install(0)" },
}

local opts = {}

require("lazy").setup(plugins, opts)

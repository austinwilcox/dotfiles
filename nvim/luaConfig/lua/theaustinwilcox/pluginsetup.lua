--Pretty Fold
require('pretty-fold').setup{ }
require('pretty-fold.preview').setup {
   key = 'h', -- choose 'h' or 'l' key
}

-- Ultisnips setup
vim.cmd[[
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpFowardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:UltiSnipsSnippetDirectories=["UltiSnips", "my_snippets"]
]]

--Nvim Surround
require('nvim-surround').setup()

--Colorizer setup
require('colorizer').setup()

require('lualine').setup{
  options = { theme = 'tokyonight' }
}

require'marks'.setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions. 
  -- higher values will have better performance but may cause visual lag, 
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world"
  },
  mappings = {}
}

-- Treesitter configuration
require'nvim-treesitter.configs'.setup {
	ensure_installed = { "c_sharp", "bash", "css", "html", "javascript", "json", "lua", "python", "regex", "scss", "tsx", "typescript", "vim", "yaml", "rust",  },
	highlight = {
		enable = true,
	},
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
      },
    },
  },
}

--GoTo Preview Setup
require('goto-preview').setup {
 -- SEE: https://github.com/rmagatti/goto-preview#%EF%B8%8F-configuration
	width = 120; -- Width of the floating window
	height = 30; -- Height of the floating window
	border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}; -- Border characters of the floating window
	default_mappings = false; -- Bind default mappings
	debug = false; -- Print debug information
	opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
	-- resizing_mappings = true; -- Binds arrow keys to resizing the floating window.
	post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
	references = { -- Configure the telescope UI for slowing the references cycling window.
		-- telescope = telescope.themes.get_dropdown({ hide_preview = false })
		-- telescope = require("telescope.themes").get_dropdown({ hide_preview = false, width = 0.75 })
	};
	-- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
	focus_on_open = true; -- Focus the floating window when opening it.
	dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
	force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
	bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
}

require("mason").setup()

-- local dap = require'dap'
-- dap.adapters.coreclr = {
--   type = "executable",
--   command = "/usr/local/netcoredbg",
--   args = {'--interpreter=vscode'}
-- }
-- dap.configurations.cs = {
--   {
--     type = "coreclr",
--     name = "launch - netcoredbg",
--     request = "launch",
--     program = function()
--         return vim.fn.input('Path to Executable', vim.fn.getcwd() .. '/bin/Debug/', 'file')
--     end,
--   },
-- }



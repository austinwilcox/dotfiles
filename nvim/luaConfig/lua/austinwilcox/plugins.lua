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

local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    -- build = ":TSUpdate",
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
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
      indent = { enable = true, disable = { "yaml"} },
    textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ii'] = '@conditional.inner',
            ['ai'] = '@conditional.outer',
            ['il'] = '@loop.inner',
            ['al'] = '@loop.outer',
            ['at'] = '@comment.outer',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
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
    },
    dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
    config=function(_, opts)
      require'nvim-treesitter.configs'.setup(opts)
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy=false,
    priority=1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      require('refactoring').setup({})
    end
  },
  {
    'ldelossa/gh.nvim',
    dependencies = {
      'ldelossa/litee.nvim'
    },
    config = function()
      require('litee.lib').setup()
    require('litee.gh').setup({
      -- deprecated, around for compatability for now.
      jump_mode   = "invoking",
      -- remap the arrow keys to resize any litee.nvim windows.
      map_resize_keys = false,
      -- do not map any keys inside any gh.nvim buffers.
      disable_keymaps = false,
      -- the icon set to use.
      icon_set = "default",
      -- any custom icons to use.
      icon_set_custom = nil,
      -- whether to register the @username and #issue_number omnifunc completion
      -- in buffers which start with .git/
      git_buffer_completion = true,
      -- defines keymaps in gh.nvim buffers.
      keymaps = {
          -- when inside a gh.nvim panel, this key will open a node if it has
          -- any futher functionality. for example, hitting <CR> on a commit node
          -- will open the commit's changed files in a new gh.nvim panel.
          open = "<CR>",
          -- when inside a gh.nvim panel, expand a collapsed node
          expand = "zo",
          -- when inside a gh.nvim panel, collpased and expanded node
          collapse = "zc",
          -- when cursor is over a "#1234" formatted issue or PR, open its details
          -- and comments in a new tab.
          goto_issue = "gd",
          -- show any details about a node, typically, this reveals commit messages
          -- and submitted review bodys.
          details = "d",
          -- inside a convo buffer, submit a comment
          submit_comment = "<C-s>",
          -- inside a convo buffer, when your cursor is ontop of a comment, open
          -- up a set of actions that can be performed.
          actions = "<C-a>",
          -- inside a thread convo buffer, resolve the thread.
          resolve_thread = "<C-r>",
          -- inside a gh.nvim panel, if possible, open the node's web URL in your
          -- browser. useful particularily for digging into external failed CI
          -- checks.
          goto_web = "gx"
      }
    })
    end
  },
  {
    "github/copilot.vim",
  },
  {
    "kyazdani42/nvim-web-devicons"
  },
  {
    "epwalsh/obsidian.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("obsidian").setup({
        dir = "~/Zettelkasten-v2",
        notes_subdir = "Fleeting Notes",
        note_id_func = function(title)
          -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
          -- In this case a note with the title 'My new note' will given an ID that looks
          -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
          local suffix = ""
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end,
        daily_notes = {
          folder = "Journal",
        },
        completion={
          nvim_cmp = true,
          min_chars=2,
          new_notes_location="current_dir",
        },
        templates = {
          subdir="Resources/Templates"
        },
        finder="telescope.nvim",
        open_notes_in="current",
        disable_frontmatter=true,
      })
    end
  },
  {
      "folke/trouble.nvim",
      config = function()
          require("trouble").setup {
              icons = true,
          }
      end
  },
  {
    --TODO Fast load this first thing
    "goolord/alpha-nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons"
    },
      config = function ()
          require'alpha'.setup(require'alpha.themes.dashboard'.config)
      end
  },
  {
    "Mofiqul/dracula.nvim",
  },
  {
    "gruvbox-community/gruvbox",
  },
  {
    "EdenEast/nightfox.nvim",
  },
  {
    "austinwilcox/hex2rgba",
  },
  {
    "austinwilcox/Obsidian-nvim-move-file",
    config=function()
      require("Obsidian-nvim-move-file").setup{
        dir = "/home/austin/Zettelkasten-v2",
      }
    end
  },
  {
    -- To get Telescope live grep working you need ripgrep
    -- Ubuntu/Debian based
    -- sudo apt install ripgrep
    "nvim-telescope/telescope.nvim",
    config=function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
              -- even more opts
            }
          }
        }
      }
      -- To get ui-select loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require("telescope").load_extension("ui-select")
    end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "mattn/emmet-vim",
    config=function()

    end
  },
  {
    "dense-analysis/ale"
  },

  {
    "nvim-lua/popup.nvim"
  },
  {
    "ap/vim-css-color"
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup()
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config=function()
      require("todo-comments").setup{}
    end
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup{}
    end
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = {
      "nvim-lua/plenary.nvim"
    }
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
		  -- LSP Support
		  'neovim/nvim-lspconfig',
		  'williamboman/mason.nvim',
		  'williamboman/mason-lspconfig.nvim',
		  -- Autocompletion
		  'hrsh7th/nvim-cmp',
		  'hrsh7th/cmp-buffer',
		  'hrsh7th/cmp-path',
		  'saadparwaiz1/cmp_luasnip',
		  'hrsh7th/cmp-nvim-lsp',
		  'hrsh7th/cmp-nvim-lua'
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("austinwilcox.lsp")
    end
  },
  {
    "hrsh7th/cmp-nvim-lsp"
  },
  {
    "hrsh7th/cmp-buffer"
  },
  {
    "L3MON4D3/LuaSnip",
    version = "2.*",
    build = "make install_jsregexp"
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
           luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ['<Tab>'] = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end,
            ['<S-Tab>'] = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
            before = function(entry, vim_item)
              --Can use this to further customize things with lspkind
              return vim_item
            end
          })
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp', max_item_count = 6 },
          { name = 'luasnip' },
          { name = "copilot" },
          { name = "path" },
        }, {
          { name = 'buffer' },
        })
      })
    end
  },
  {
    "lukas-reineke/lsp-format.nvim"
  },
  {
    "williamboman/mason.nvim",
    config=function()
      require("mason").setup({
        ensure_installed = { 'tsserver', "cssls", "denols", "lua_ls", "rust_analyzer", "vls", "gopls", "marksman" }
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim"
  },
  {
    "tjdevries/nlua.nvim",
    dependencies = {
      "nvim-lua/completion-nvim",
      "euclidianAce/BetterLua.vim"
    }
  },
  {
    "onsails/lspkind.nvim"
  },
  {
    "windwp/nvim-autopairs",
    config = function ()
      require("nvim-autopairs").setup{}
    end
  },
  {
    "tpope/vim-fugitive"
  },
  {
    "tpope/vim-commentary"
  },
  {
    "mhinz/vim-signify"
  },
  {
    "junegunn/gv.vim"
  },
  {
    "chentoast/marks.nvim",
    config=function()
      require'marks'.setup {
        default_mappings = true,
        builtin_marks = { ".", "<", ">", "^" },
        cyclic = true,
        force_write_shada = false,
        refresh_interval = 250,
        sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
        excluded_filetypes = {},
        bookmark_0 = {
          sign = "⚑",
          virt_text = "hello world"
        },
        mappings = {}
      }
      end
    },
  {
    "MunifTanjim/prettier.nvim",
    config=function()
      require("prettier").setup({
        bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
        filetypes = {
          "css",
          "graphql",
          "html",
          "javascript",
          "javascriptreact",
          "json",
          "less",
          "markdown",
          "scss",
          "typescript",
          "typescriptreact",
          "yaml",
        },
      })
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons", opt=true
    },
    config = function()
      require('lualine').setup{
        options = { theme = 'tokyonight' }
      }
    end
  },
  {
    "luochen1990/rainbow"
  },
  {
    "kylechui/nvim-surround",
    version="*",
    event="VeryLazy",
    config = function()
        require("nvim-surround").setup({})
    end
  },
  {
    "rmagatti/goto-preview",
    config = function()
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
    end
  }
}

local opts = {}

require("lazy").setup(plugins, opts)

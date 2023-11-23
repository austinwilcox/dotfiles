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
          lookahead = true,
          keymaps = {
            -- NOTE: You can use the capture groups defined in textobjects.scm
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
          set_jumps = true,
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
      local colorscheme = "tokyonight-storm"
      local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
      if not status_ok then
        vim.notify("colorscheme " .. colorscheme .. " not found!")
        return
      end
    end
  },
  -- {
  --   "folke/noice.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "rcarriga/nvim-notify",
  --   },
  --   config=function()
  --     require("noice").setup({
  --       lsp = {
  --         -- NOTE: override markdown rendering so that **cmp** and other plugins use **Treesitter**
  --         override = {
  --           ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  --           ["vim.lsp.util.stylize_markdown"] = true,
  --           ["cmp.entry.get_documentation"] = true,
  --         },
  --       },
  --       -- NOTE: you can enable a preset for easier configuration
  --       presets = {
  --         bottom_search = true,
  --         command_palette = true,
  --         long_message_to_split = true,
  --         inc_rename = false,
  --         lsp_doc_border = false,
  --       },
  --     })
  --   end
  -- },
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
      -- NOTE: deprecated, around for compatability for now.
      jump_mode   = "invoking",
      -- NOTE: remap the arrow keys to resize any litee.nvim windows.
      map_resize_keys = false,
      -- NOTE: do not map any keys inside any gh.nvim buffers.
      disable_keymaps = false,
      -- NOTE: the icon set to use.
      icon_set = "default",
      -- NOTE: any custom icons to use.
      icon_set_custom = nil,
      git_buffer_completion = true,
      keymaps = {
          -- NOTE: when inside a gh.nvim panel, this key will open a node if it has
          -- any futher functionality. for example, hitting <CR> on a commit node
          -- will open the commit's changed files in a new gh.nvim panel.
          open = "<CR>",
          -- NOTE: when inside a gh.nvim panel, expand a collapsed node
          expand = "zo",
          -- NOTE: when inside a gh.nvim panel, collpased and expanded node
          collapse = "zc",
          -- NOTE: when cursor is over a "#1234" formatted issue or PR, open its details
          -- and comments in a new tab.
          goto_issue = "gd",
          -- NOTE: show any details about a node, typically, this reveals commit messages
          -- and submitted review bodys.
          details = "d",
          -- NOTE: inside a convo buffer, submit a comment
          submit_comment = "<C-s>",
          -- NOTE: inside a convo buffer, when your cursor is ontop of a comment, open
          -- NOTE: up a set of actions that can be performed.
          actions = "<C-a>",
          -- NOTE: inside a thread convo buffer, resolve the thread.
          resolve_thread = "<C-r>",
          -- NOTE: inside a gh.nvim panel, if possible, open the node's web URL in your
          -- browser. useful particularily for digging into external failed CI
          -- checks.
          goto_web = "gx"
      }
    })
    end
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
    -- TODO: Fast load this first thing
    "goolord/alpha-nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons"
    },
      config = function ()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        dashboard.section.header.val = {"BANNER"}
        alpha.setup(dashboard.opts)
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
    "austinwilcox/ZKMoveFile",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config=function()
      require("ZKMoveFile").setup{
        dir = "/home/austin/Zettelkasten-v2",
        permanent_notes_dir = "Permanent Notes",
        title = "ZK Directories",
        layers = 1
      }
    end
  },
  {
    -- NOTE: To get Telescope live grep working you need ripgrep
    -- Ubuntu/Debian based
    -- sudo apt install ripgrep
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-ui-select.nvim",
    },
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
      -- NOTE: To get ui-select loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require("telescope").load_extension("ui-select")
    end
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
    },
    config = function()
      require("telescope").load_extension('harpoon')
    end
  },
  {
    "github/copilot.vim"
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
    dependencies = {
      "onsails/lspkind.nvim"
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
      end

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
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- NOTE: Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
            symbol_map = { Copilot = "" },
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
    "tjdevries/nlua.nvim",
    dependencies = {
      "nvim-lua/completion-nvim",
      "euclidianAce/BetterLua.vim"
    }
  },
  {
    "windwp/nvim-autopairs",
    enabled=true,
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
    "mhinz/vim-signify",
    config=function()
      vim.cmd[[
      let g:signify_sign_add = '+'
      let g:signify_sign_delete = '_'
      let g:signify_sign_delete_first_line = '‾'
      let g:signify_sign_change = '~'

      let g:signify_sign_show_count = 0
      let g:signify_sign_show_text = 1
      ]]
    end
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
    ft = {"css", "scss", "jsx", "tsx", "js", "html", "ts", "json", "graphql", "yaml", "markdown"},
    config=function()
      require("prettier").setup({
        bin = 'prettier',
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
       -- NOTE: https://github.com/rmagatti/goto-preview#%EF%B8%8F-configuration
        width = 120;
        height = 30;
        border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"};
        default_mappings = false;
        debug = false;
        opacity = nil;
        post_open_hook = nil;
        focus_on_open = true;
        dismiss_on_move = false;
        force_close = true,
        bufhidden = "wipe",
      }
    end
  },
  {
    "nvim-neotest/neotest",
    ft = "cs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim"
    }
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require('dap')
      -- TODO: Move these items to their own file and then load them in on a cs project
      local function read_json_file(file_path)
          local file = io.open(file_path, "r")
          if not file then
              return nil, "Unable to open file: " .. file_path
          end

          local content = file:read("*all")
          file:close()

          local success, data = pcall(vim.fn.json_decode, content)
          if not success then
              return nil, "Error decoding JSON: " .. data
          end

          return data
      end
      local json_data, _ = read_json_file("/home/austin/Software/arbinger/web/ArbingerAPI/ArbingerAPI/appsettings.Development.json")
      dap.adapters.coreclr = {
        type = 'executable',
        command = '/usr/local/bin/netcoredbg/netcoredbg',
        args = {'--interpreter=vscode'}
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
              return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/net6.0/', 'file')
          end,
          env = {
            Environment=json_data.Environment,
            ConnectionStrings__Local=json_data.ConnectionStrings.Local,
            ConnectionStrings__LocalLicenseKey=json_data.ConnectionStrings.LocalLicenseKey,
            ConnectionStrings__Staging=json_data.ConnectionStrings.Staging,
            ConnectionStrings__StagingLicenseKey=json_data.ConnectionStrings.StagingLicenseKey,
            ConnectionStrings__Production=json_data.ConnectionStrings.Production,
            ConnectionStrings__ProductionLicenseKey=json_data.ConnectionStrings.ProductionLicenseKey,
            EmailServer__APIKey=json_data.EmailServer.APIKey,
            EmailServer__MailFrom=json_data.EmailServer.MailFrom,
            EmailServer__Username=json_data.EmailServer.Username,
            ServiceConfiguration__JwtSettings__Secret=json_data.ServiceConfiguration.JwtSettings.Secret,
            ServiceConfiguration__JwtSettings__Issuer=json_data.ServiceConfiguration.JwtSettings.Issuer,
            ServiceConfiguration__JwtSettings__TokenLifetime=json_data.ServiceConfiguration.JwtSettings.TokenLifetime,
            ServiceConfiguration__SecurePath=json_data.ServiceConfiguration.SecurePath,
            SupportEmail=json_data.SupportEmail
          }
        },
      }

      vim.cmd[[
        nnoremap <silent> <leader>dc <Cmd>lua require'dap'.continue()<CR>
        nnoremap <silent> <leader>do <Cmd>lua require'dap'.step_over()<CR>
        nnoremap <silent> <leader>di <Cmd>lua require'dap'.step_into()<CR>
        nnoremap <silent> <leader>dO <Cmd>lua require'dap'.step_out()<CR>
        nnoremap <silent> <leader>db <Cmd>lua require'dap'.toggle_breakpoint()<CR>
        nnoremap <silent> <leader>dB <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
        nnoremap <silent> <leader>dp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
        nnoremap <silent> <leader>dr <Cmd>lua require'dap'.repl.open()<CR>
        nnoremap <silent> <leader>dl <Cmd>lua require'dap'.run_last()<CR>
      ]]
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    config=function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        -- Use this to override mappings for specific elements
        element_mappings = {
          -- Example:
          -- stacks = {
          --   open = "<CR>",
          --   expand = "o",
          -- }
        },
        -- Expand lines larger than the window
        -- Requires >= 0.7
        expand_lines = vim.fn.has("nvim-0.7") == 1,
        -- Layouts define sections of the screen to place windows.
        -- The position can be "left", "right", "top" or "bottom".
        -- The size specifies the height/width depending on position. It can be an Int
        -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
        -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
        -- Elements are the elements shown in the layout (in order).
        -- Layouts are opened in order so that earlier layouts take priority in window sizing.
        layouts = {
          {
            elements = {
            -- Elements can be strings or table with id and size keys.
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40, -- 40 columns
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
          },
        },
        controls = {
          -- Requires Neovim nightly (or 0.8 when released)
          enabled = true,
          -- Display controls in this element
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "↻",
            terminate = "□",
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          border = "single", -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
          max_value_lines = 100, -- Can be integer or nil.
        }
      })


      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    'David-Kunz/gen.nvim'
  }
}

local opts = {}

require("lazy").setup(plugins, opts)

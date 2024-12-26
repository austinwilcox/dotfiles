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
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        icons = true,
      })
    end,
  },
  {
    -- TODO: Fast load this first thing
    "goolord/alpha-nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = { "BANNER" }
      alpha.setup(dashboard.opts)
    end,
  },
  {
    "austinwilcox/hex2rgba",
  },
  {
    "austinwilcox/ZKMoveFile",
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
    }
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
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- NOTE: Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            symbol_map = { Copilot = "" },
          }),
        },
        sources = cmp.config.sources({
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
          "denols",
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
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.eslint_d,
        },
      })

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
  },
  {
    "tjdevries/nlua.nvim",
    dependencies = {
      "nvim-lua/completion-nvim",
      "euclidianAce/BetterLua.vim",
    },
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
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          -- map("n", "<leader>hs", gs.stage_hunk)
          -- map("n", "<leader>hr", gs.reset_hunk)
          -- map("v", "<leader>hs", function()
          -- 	gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          -- end)
          -- map("v", "<leader>hr", function()
          -- 	gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          -- end)
          -- map("n", "<leader>hS", gs.stage_buffer)
          -- map("n", "<leader>hu", gs.undo_stage_hunk)
          -- map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end)
          map("n", "<leader>tb", gs.toggle_current_line_blame)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end)
          map("n", "<leader>td", gs.toggle_deleted)

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      })
    end,
  },
  {
    --NOTE:
    --:GV to open commit browser, You can pass git log options to the command, e.g. :GV -S foobar -- plugins.
    -- :GV! will only list commits that affected the current file
    -- :GV? fills the location list with the revisions of the current file
    -- :GV or :GV? can be used in visual mode to track the changes in the selected lines.
    "junegunn/gv.vim",
  },
  {
    "tpope/vim-commentary",
  },
  {
    "MunifTanjim/prettier.nvim",
    ft = { "css", "scss", "jsx", "tsx", "js", "html", "ts", "json", "graphql", "yaml", "markdown" },
    config = function()
      require("prettier").setup({
        bin = "prettier",
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
    end,
  },
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
  -- {
  --   "mfussenegger/nvim-dap",
  --   config = function()
  --     local dap = require("dap")
  --     -- TODO: Move these items to their own file and then load them in on a cs project
  --     -- local function read_json_file(file_path)
  --     --     local file = io.open(file_path, "r")
  --     --     if not file then
  --     --         return nil, "Unable to open file: " .. file_path
  --     --     end

  --     --     local content = file:read("*all")
  --     --     file:close()

  --     --     local success, data = pcall(vim.fn.json_decode, content)
  --     --     if not success then
  --     --         return nil, "Error decoding JSON: " .. data
  --     --     end

  --     --     return data
  --     -- end
  --     -- local json_data, _ = read_json_file("/home/austin/Software/arbinger/web/ArbingerAPI/ArbingerAPI/appsettings.Development.json")
  --     -- dap.adapters.coreclr = {
  --     --   type = 'executable',
  --     --   command = '/usr/local/bin/netcoredbg/netcoredbg',
  --     --   args = {'--interpreter=vscode'}
  --     -- }

  --     -- dap.configurations.cs = {
  --     --   {
  --     --     type = "coreclr",
  --     --     name = "launch - netcoredbg",
  --     --     request = "launch",
  --     --     program = function()
  --     --         return vim.fn.getcwd() .. '/bin/Debug/net6.0/ArbingerAPI.dll' -- vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/net6.0/', 'file')
  --     --     end,
  --     --     env = {
  --     --       Environment=json_data.Environment,
  --     --       ConnectionStrings__Local=json_data.ConnectionStrings.Local,
  --     --       ConnectionStrings__LocalLicenseKey=json_data.ConnectionStrings.LocalLicenseKey,
  --     --       ConnectionStrings__Staging=json_data.ConnectionStrings.Staging,
  --     --       ConnectionStrings__StagingLicenseKey=json_data.ConnectionStrings.StagingLicenseKey,
  --     --       ConnectionStrings__Production=json_data.ConnectionStrings.Production,
  --     --       ConnectionStrings__ProductionLicenseKey=json_data.ConnectionStrings.ProductionLicenseKey,
  --     --       EmailServer__APIKey=json_data.EmailServer.APIKey,
  --     --       EmailServer__MailFrom=json_data.EmailServer.MailFrom,
  --     --       EmailServer__Username=json_data.EmailServer.Username,
  --     --       ServiceConfiguration__JwtSettings__Secret=json_data.ServiceConfiguration.JwtSettings.Secret,
  --     --       ServiceConfiguration__JwtSettings__Issuer=json_data.ServiceConfiguration.JwtSettings.Issuer,
  --     --       ServiceConfiguration__JwtSettings__TokenLifetime=json_data.ServiceConfiguration.JwtSettings.TokenLifetime,
  --     --       ServiceConfiguration__SecurePath=json_data.ServiceConfiguration.SecurePath,
  --     --       SupportEmail=json_data.SupportEmail
  --     --     }
  --     --   },
  --     -- }

  --     vim.cmd([[
  --       nnoremap <silent> <leader>dc <Cmd>lua require'dap'.continue()<CR>
  --       nnoremap <silent> <leader>do <Cmd>lua require'dap'.step_over()<CR>
  --       nnoremap <silent> <leader>di <Cmd>lua require'dap'.step_into()<CR>
  --       nnoremap <silent> <leader>dO <Cmd>lua require'dap'.step_out()<CR>
  --       nnoremap <silent> <leader>db <Cmd>lua require'dap'.toggle_breakpoint()<CR>
  --       nnoremap <silent> <leader>dB <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
  --       nnoremap <silent> <leader>dp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
  --       nnoremap <silent> <leader>dr <Cmd>lua require'dap'.repl.open()<CR>
  --       nnoremap <silent> <leader>dl <Cmd>lua require'dap'.run_last()<CR>
  --     ]])
  --   end,
  -- },
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   config = function()
  --     local dap, dapui = require("dap"), require("dapui")

  --     dapui.setup({
  --       icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  --       mappings = {
  --         -- NOTE:
  --         -- Use a table to apply multiple mappings
  --         expand = { "<CR>", "<2-LeftMouse>" },
  --         open = "o",
  --         remove = "d",
  --         edit = "e",
  --         repl = "r",
  --         toggle = "t",
  --       },
  --       -- NOTE:
  --       -- Use this to override mappings for specific elements
  --       element_mappings = {
  --         -- NOTE:
  --         -- Example:
  --         -- stacks = {
  --         --   open = "<CR>",
  --         --   expand = "o",
  --         -- }
  --       },
  --       -- NOTE:
  --       -- Expand lines larger than the window
  --       -- Requires >= 0.7
  --       expand_lines = vim.fn.has("nvim-0.7") == 1,
  --       -- NOTE:
  --       -- Layouts define sections of the screen to place windows.
  --       -- The position can be "left", "right", "top" or "bottom".
  --       -- The size specifies the height/width depending on position. It can be an Int
  --       -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  --       -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  --       -- Elements are the elements shown in the layout (in order).
  --       -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  --       layouts = {
  --         {
  --           elements = {
  --             -- Elements can be strings or table with id and size keys.
  --             { id = "scopes", size = 0.25 },
  --             "breakpoints",
  --             "stacks",
  --             "watches",
  --           },
  --           size = 40, -- 40 columns
  --           position = "left",
  --         },
  --         {
  --           elements = {
  --             "repl",
  --             "console",
  --           },
  --           size = 0.25, -- 25% of total lines
  --           position = "bottom",
  --         },
  --       },
  --       controls = {
  --         -- Requires Neovim nightly (or 0.8 when released)
  --         enabled = true,
  --         -- Display controls in this element
  --         element = "repl",
  --         icons = {
  --           pause = "",
  --           play = "",
  --           step_into = "",
  --           step_over = "",
  --           step_out = "",
  --           step_back = "",
  --           run_last = "↻",
  --           terminate = "□",
  --         },
  --       },
  --       floating = {
  --         max_height = nil, -- These can be integers or a float between 0 and 1.
  --         max_width = nil, -- Floats will be treated as percentage of your screen.
  --         border = "single", -- Border style. Can be "single", "double" or "rounded"
  --         mappings = {
  --           close = { "q", "<Esc>" },
  --         },
  --       },
  --       windows = { indent = 1 },
  --       render = {
  --         max_type_length = nil, -- Can be integer or nil.
  --         max_value_lines = 100, -- Can be integer or nil.
  --       },
  --     })

  --     dap.listeners.after.event_initialized["dapui_config"] = function()
  --       dapui.open()
  --     end
  --     dap.listeners.before.event_terminated["dapui_config"] = function()
  --       dapui.close()
  --     end
  --     dap.listeners.before.event_exited["dapui_config"] = function()
  --       dapui.close()
  --     end
  --   end,
  -- },
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
      require 'lsp_signature'.setup(opts)
    end
  },
  {
    "NStefan002/screenkey.nvim",
    lazy = false,
    version = "*", -- or branch = "dev", to use the latest commit
  },
  {
    "folke/zen-mode.nvim",
    opts = { }
  }
}

if utils.OS() == 'unix' then
  table.insert(plugins, {
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
        notes_subdir = "pages",
        note_id_func = function(title)
          --TODO: Create a parser here that will figure out the context of where I'm at,
          --and if it can't figure out the context of where I'm at, lets create a new note number
          -- NOTE: Create note IDs in a Zettelkasten format with a timestamp and a suffix.
          -- In this case a note with the title 'My new note' will given an ID that looks
          -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
          -- local suffix = ""
          -- if title ~= nil then
          --   suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          -- else
          --   for _ = 1, 4 do
          --     suffix = suffix .. string.char(math.random(65, 90))
          --   end
          -- end
          -- return tostring(os.time()) .. "-" .. suffix
          return title
        end,
        daily_notes = {
          folder = "journals",
        },
        completion = {
          nvim_cmp = true,
          min_chars = 2,
          new_notes_location = "current_dir",
        },
        templates = {
          subdir = "",
        },
        finder = "telescope.nvim",
        open_notes_in = "current",
        disable_frontmatter = true,
        ui = {
          enable = false,
        },
      })
    end,
  })
end

local opts = {}

require("lazy").setup(plugins, opts)

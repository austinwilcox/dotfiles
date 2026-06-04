return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "lukas-reineke/lsp-format.nvim",
      "ray-x/lsp_signature.nvim",
    },
    config = function()
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      require("lsp_signature").setup({
        bind = true,
        handler_opts = { border = "rounded" },
      })

      require("lsp-format").setup({})

      local function on_attach(client)
        local map = vim.keymap.set
        local opts = { buffer = 0 }

        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "]d", vim.diagnostic.goto_next, opts)
        map("n", "[d", vim.diagnostic.goto_prev, opts)
        map("n", "<leader>gr", vim.lsp.buf.rename, opts)
        map("n", "<leader>gR", vim.lsp.buf.references, opts)
        map("n", "gt", vim.lsp.buf.type_definition, opts)
        map("n", "gi", vim.lsp.buf.implementation, opts)
        map("n", "<leader>gl", "<cmd>Telescope diagnostics<cr>", opts)
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        -- Prevent denols and ts_ls from conflicting
        local active_clients = vim.lsp.get_clients()
        if client.name == "denols" then
          for _, c in pairs(active_clients) do
            if c.name == "ts_ls" then c.stop() end
          end
        elseif client.name == "ts_ls" then
          for _, c in pairs(active_clients) do
            if c.name == "denols" then client.stop() end
          end
        end
      end

      -- Lua (lazydev handles vim.* types, no need for globals hack)
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "lua" },
      })
      vim.lsp.enable("lua_ls")

      -- TypeScript (Node projects). root_markers excludes Deno projects so
      -- denols owns those instead.
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        root_markers = { "package.json" },
        -- Don't attach in a Deno project even if a stray package.json exists.
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          if vim.fs.root(fname, { "deno.json", "deno.jsonc" }) then
            return
          end
          on_dir(vim.fs.root(fname, { "package.json", "tsconfig.json", "jsconfig.json" }))
        end,
      })
      vim.lsp.enable("ts_ls")

      -- Deno: starts only when a deno.json/deno.jsonc is present in the project.
      vim.lsp.config("denols", {
        capabilities = capabilities,
        on_attach = on_attach,
        root_markers = { "deno.json", "deno.jsonc" },
        settings = {
          deno = {
            enable = true,
            lint = true,
            unstable = true,
          },
        },
      })
      vim.lsp.enable("denols")

      -- Biome
      vim.lsp.enable("biome")

      -- R
      vim.lsp.config("r_language_server", {
        on_attach = on_attach,
        flags = { debounc_text_changes = 150 },
      })
      vim.lsp.enable("r_language_server")

      -- Markdown
      vim.lsp.config("marksman", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "markdown" },
      })
      vim.lsp.enable("marksman")

      -- CSS
      vim.lsp.config("cssls", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.enable("cssls")

      -- TailwindCSS
      vim.lsp.config("tailwindcss", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.enable("tailwindcss")

      -- Go
      vim.lsp.config("gopls", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.enable("gopls")

      -- Rust
      vim.lsp.config("rust_analyzer", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.enable("rust_analyzer")

      -- Bash
      vim.lsp.config("bashls", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.enable("bashls")

      -- ESLint
      vim.lsp.config("eslint", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.enable("eslint")

      -- JSON
      vim.lsp.config("jsonls", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.enable("jsonls")

      -- GraphQL
      vim.lsp.config("graphql", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.enable("graphql")

      -- HTML
      vim.lsp.config("html", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.enable("html")

      -- Vue
      vim.lsp.config("vls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "vue" },
        cmd = { "vls" },
      })
      vim.lsp.enable("vls")

      -- Emmet
      vim.lsp.config("emmet_language_server", { capabilities = capabilities })
      vim.lsp.enable("emmet_language_server")

      -- C# (Roslyn LS) — disabled, requires .NET 10. Re-enable when system has it.
      -- vim.lsp.config("roslyn_ls", {
      --   cmd = {
      --     vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "roslyn"),
      --     "--logLevel", "Information",
      --     "--extensionLogDirectory", vim.fs.joinpath(vim.uv.os_tmpdir(), "roslyn_ls/logs"),
      --     "--stdio",
      --   },
      --   capabilities = capabilities,
      --   on_attach = function(client, bufnr)
      --     require("lsp-format").on_attach(client)
      --     on_attach(client)
      --   end,
      --   settings = {
      --     ["csharp|background_analysis"] = {
      --       dotnet_analyzer_diagnostics_scope = "openFiles",
      --       dotnet_compiler_diagnostics_scope = "openFiles",
      --     },
      --     ["csharp|inlay_hints"] = {
      --       csharp_enable_inlay_hints_for_implicit_object_creation = true,
      --       csharp_enable_inlay_hints_for_implicit_variable_types = true,
      --       csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      --       csharp_enable_inlay_hints_for_types = true,
      --     },
      --   },
      -- })
      -- vim.lsp.enable("roslyn_ls")

      -- C# (OmniSharp) — Mason installs binary at mason/bin/OmniSharp.
      vim.lsp.config("omnisharp", {
        cmd = {
          vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "OmniSharp"),
          "-z",
          "--hostPID", tostring(vim.fn.getpid()),
          "DotNet:enablePackageRestore=false",
          "--encoding", "utf-8",
          "--languageserver",
        },
        capabilities = capabilities,
        on_attach = on_attach,
      })
      vim.lsp.enable("omnisharp")

      vim.diagnostic.config({
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ensure_installed = {
          "ts_ls", "denols", "cssls", "lua_ls", "rust_analyzer", "vls",
          "gopls", "marksman", "bashls", "eslint", "jsonls",
          "tailwindcss", "graphql", "html", "netcoredbg",
          "omnisharp", "stylua", "prettierd", "goimports",
        },
        automatic_installation = true,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
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
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            symbol_map = { Copilot = "" },
          }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "lazydev", group_index = 0 },
          { name = "copilot" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}

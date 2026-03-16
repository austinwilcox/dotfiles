return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "Hoffs/omnisharp-extended-lsp.nvim",
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

      -- TypeScript
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        root_markers = { "package.json" },
      })
      vim.lsp.enable("ts_ls")

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

      -- C# (Omnisharp)
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/omnisharp"
      vim.lsp.config("omnisharp", {
        cmd = {
          mason_path .. "/omnisharp", "-z",
          "--hostPID", tostring(vim.fn.getpid()),
          "DotNet:enablePackageRestore=false",
          "--encoding", "utf-8",
          "--languageserver",
        },
        capabilities = capabilities,
        on_attach = function(client)
          require("lsp-format").on_attach(client)
          on_attach(client)
        end,
        filetypes = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets", "tproj", "slngen", "fproj" },
        settings = {
          FormattingOptions = { OrganizeImports = true },
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = false,
            EnableImportCompletion = true,
            EnableDecompilationSupport = true,
          },
        },
        handlers = {
          ["textDocument/definition"] = require("omnisharp_extended").definition_handler,
          ["textDocument/typeDefinition"] = require("omnisharp_extended").type_definition_handler,
          ["textDocument/references"] = require("omnisharp_extended").references_handler,
          ["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
        },
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
          "ts_ls", "cssls", "lua_ls", "rust_analyzer", "vls",
          "gopls", "marksman", "bashls", "eslint", "jsonls",
          "tailwindcss", "graphql", "html", "netcoredbg",
          "stylua", "prettierd", "goimports",
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

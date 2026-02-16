local nmap = require("austinwilcox.keymap").nmap

local buf_nnoremap = function(opts)
  if opts[3] == nil then
    opts[3] = {}
  end
  opts[3].buffer = 0

  nmap(opts)
end

local custom_attach = function(client)
  local active_clients = vim.lsp.get_clients()
  local buffer_number = vim.api.nvim_get_current_buf()
  if client.name == "denols" then
    for _, client_ in pairs(active_clients) do
      -- stop ts_ls if denols is already active
      if client_.name == "ts_ls" then
        client_.stop()
      end
    end
  elseif client.name == "ts_ls" then
    for _, client_ in pairs(active_clients) do
      -- prevent ts_ls from starting if denols is already active
      if client_.name == "denols" then
        client.stop()
      end
    end
  end

  --Older native lsp configuration options
  buf_nnoremap({ "K", vim.lsp.buf.hover })
  buf_nnoremap({ "gd", vim.lsp.buf.definition })
  buf_nnoremap({ "]d", vim.diagnostic.goto_next })
  buf_nnoremap({ "[d[", vim.diagnostic.goto_prev })
  buf_nnoremap({ "<leader>gr", vim.lsp.buf.rename })
  buf_nnoremap({ "<leader>gR", vim.lsp.buf.references })
  buf_nnoremap({ "gt", vim.lsp.buf.type_definition })
  buf_nnoremap({ "gi", vim.lsp.buf.implementation })
  buf_nnoremap({ "<leader>gl", "<cmd>Telescope diagnostics<cr>" })
  buf_nnoremap({ "<leader>ca", vim.lsp.buf.code_action })
end

require("lsp_signature").setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded",
  },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Lua Setup
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  on_attach = custom_attach,
  filetypes = { "lua" },
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})
vim.lsp.enable("lua_ls")

-- R Language Server
vim.lsp.config("r_language_server", {
  on_attach = custom_attach,
  flags = { debounc_text_changes = 150 },
})
vim.lsp.enable("r_language_server")

-- BIOME setup
vim.lsp.enable("biome")

-- Typescript Setup
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  on_attach = custom_attach,
  root_markers = { "package.json" },
})
vim.lsp.enable("ts_ls")

-- Deno Setup
-- vim.lsp.config("denols", {
--   capabilities = capabilities,
--   on_attach = custom_attach,
--   root_markers = { "deno.json", "deno.jsonc" },
-- })
-- vim.lsp.enable("denols")

-- Marksman (Markdown)
vim.lsp.config("marksman", {
  capabilities = capabilities,
  on_attach = custom_attach,
  filetypes = { "md" },
})
vim.lsp.enable("marksman")

-- CSS
-- Installation: npm install --location=global vscode-langservers-extracted
vim.lsp.config("cssls", {
  capabilities = capabilities,
  on_attach = custom_attach,
})
vim.lsp.enable("cssls")

-- TailwindCSS
vim.lsp.config("tailwindcss", {
  capabilities = capabilities,
  on_attach = custom_attach,
})
vim.lsp.enable("tailwindcss")

-- GO
vim.lsp.config("gopls", {
  capabilities = capabilities,
  on_attach = custom_attach,
})
vim.lsp.enable("gopls")

-- Vue
vim.lsp.config("vls", {
  capabilities = capabilities,
  on_attach = custom_attach,
  filetypes = { "vue" },
  cmd = { "vls" },
})
vim.lsp.enable("vls")

-- Omnisharp Setup
require("lsp-format").setup({})
local on_attach = function(client)
  require("lsp-format").on_attach(client)
  vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")
  custom_attach(client)
end

local mason_path = vim.fn.stdpath("data") .. "/mason/packages/omnisharp"
local omnisharp_bin = mason_path .. "/omnisharp"

vim.lsp.config("omnisharp", {
  cmd = {
    omnisharp_bin,
    "-z",
    "--hostPID",
    tostring(vim.fn.getpid()),
    "DotNet:enablePackageRestore=false",
    "--encoding",
    "utf-8",
    "--languageserver",
  },
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets", "tproj", "slngen", "fproj" },
  settings = {
    FormattingOptions = {
      OrganizeImports = true,
    },
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

-- Emmet
vim.lsp.config("emmet_language_server", {
  capabilities = capabilities,
})
vim.lsp.enable("emmet_language_server")

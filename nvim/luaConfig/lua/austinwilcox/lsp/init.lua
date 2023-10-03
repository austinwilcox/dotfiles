local imap = require("austinwilcox.keymap").imap
local nmap = require("austinwilcox.keymap").nmap

local has_lsp, lspconfig = pcall(require, "lspconfig")
if not has_lsp then
  return
end

local buf_inoremap = function(opts)
  if opts[3] == nil then
    opts[3] = {}
  end
  opts[3].buffer = 0
  imap(opts)
end

local buf_nnoremap = function(opts)
  if opts[3] == nil then
    opts[3] = {}
  end
  opts[3].buffer = 0

  nmap(opts)
end

local custom_attach = function(client)
  local active_clients = vim.lsp.get_active_clients()
  if client.name == "denols" then
    for _, client_ in pairs(active_clients) do
      -- stop tsserver if denols is already active
      if client_.name == "tsserver" then
        client_.stop()
      end
    end
  elseif client.name == "tsserver" then
    for _, client_ in pairs(active_clients) do
      -- prevent tsserver from starting if denols is already active
      if client_.name == "denols" then
        client.stop()
      end
    end
  end
  --Older native lsp configuration options
  buf_nnoremap { "K", vim.lsp.buf.hover }
  buf_nnoremap { "gd", vim.lsp.buf.definition }
  buf_nnoremap { "<leader>gn", vim.diagnostic.goto_next }
  buf_nnoremap { "<leader>gp", vim.diagnostic.goto_prev }
  buf_nnoremap { "<leader>gr", vim.lsp.buf.rename }
  buf_nnoremap { "<leader>gR", vim.lsp.buf.references}
  buf_nnoremap { "gt", vim.lsp.buf.type_definition }
  buf_nnoremap { "gi", vim.lsp.buf.implementation }
  buf_nnoremap { "<leader>gl", "<cmd>Telescope diagnostics<cr>"} 
  buf_nnoremap { "<leader>ca", vim.lsp.buf.code_action }
end

-- Rust Setup
require'lspconfig'.rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = custom_attach
})

-- Lua Setup
require'lspconfig'.lua_ls.setup({
  capabilities = capabilities,
  on_attach = custom_attach,
  filetypes = {"lua"},
})

-- Typescript Setup
require'lspconfig'.tsserver.setup{
  capabilities = capabilities,
  on_attach = custom_attach,
  root_dir = require'lspconfig'.util.root_pattern("package.json")
}

-- Deno Setup
-- Currently this interferes to much with tsserver
 require'lspconfig'.denols.setup({
   capabilities = capabilities,
   on_attach = custom_attach,
   root_dir = require'lspconfig'.util.root_pattern("deno.json", "deno.jsonc")
 })

 require'lspconfig'.marksman.setup({
   capabilities = capabilities,
   on_attach = custom_attach,
   filetypes = {"md"},
 })

-- LUA
-- Installation
-- Install via VSCode
-- require'lspconfig'.sumneko_lua.setup{
--   capabilities = capabilities,
--   on_attach = custom_attach
-- }

--CSS
--Installation
--npm install --location=global vscode-langservers-extracted
--npm install --save vscode-css-languageservice
require'lspconfig'.cssls.setup{
  capabilities = capabilities,
  on_attach = custom_attach
}

-- Omnisharp Setup
require("lsp-format").setup {}
local on_attach = function(client)
  require "lsp-format".on_attach(client)
  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  custom_attach(client)
end

require'lspconfig'.omnisharp.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {"cs", "csx"},
  cmd = { "/home/austin/.config/omnisharp/OmniSharp", "--languageserver" , "--hostPID", tostring(pid) },
}

--GO
require'lspconfig'.gopls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

require'lspconfig'.vls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {"vue"},
  cmd = { "vls" },
}

local imap = require("theaustinwilcox.keymap").imap
local nmap = require("theaustinwilcox.keymap").nmap

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

local cmp = require'cmp'
cmp.setup({
 snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
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
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' }
  }, {
    { name = 'buffer' },
  })
})


local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local custom_attach = function(client)
  buf_nnoremap { "K", vim.lsp.buf.hover }
  buf_nnoremap { "gd", vim.lsp.buf.definition }
  buf_nnoremap { "gt", vim.lsp.buf.type_definition }
  buf_nnoremap { "gi", vim.lsp.buf.implementation }
  buf_nnoremap { "<leader>df", vim.diagnostic.goto_next }
  buf_nnoremap { "<leader>dp", vim.diagnostic.goto_prev }
  buf_nnoremap { "<leader>dr", vim.lsp.buf.rename }
  buf_nnoremap { "<leader>dl", "<cmd>Telescope diagnostics<cr>"} 
  buf_nnoremap { "<leader>ca", vim.lsp.buf.code_action }
end

-- Typescript Setup
require'lspconfig'.tsserver.setup{
  capabilities = capabilities,
  on_attach = custom_attach
}

--CSS
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require'lspconfig'.cssls.setup{
  capabilities = capabilities
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
  cmd = { "/home/austin/.config/omnisharp/OmniSharp", "--languageserver" , "--hostPID", tostring(pid) },
}

--GO
require'lspconfig'.gopls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

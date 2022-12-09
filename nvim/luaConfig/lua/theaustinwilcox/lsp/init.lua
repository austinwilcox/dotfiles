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

local lspkind = require('lspkind')
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
    { name = 'nvim_lsp' },
    { name = 'ultisnips' }
  }, {
    { name = 'buffer' },
  })
})


local capabilities = require('cmp_nvim_lsp').default_capabilities()
local custom_attach = function(client)
  --Older native lsp configuration options
  buf_nnoremap { "K", vim.lsp.buf.hover }
  buf_nnoremap { "gd", vim.lsp.buf.definition }
  buf_nnoremap { "<leader>gn", vim.diagnostic.goto_next }
  buf_nnoremap { "<leader>gp", vim.diagnostic.goto_prev }
  buf_nnoremap { "<leader>gr", vim.lsp.buf.rename }
  buf_nnoremap { "gt", vim.lsp.buf.type_definition }
  buf_nnoremap { "gi", vim.lsp.buf.implementation }
  buf_nnoremap { "<leader>gl", "<cmd>Telescope diagnostics<cr>"} 
  buf_nnoremap { "<leader>ca", vim.lsp.buf.code_action }
  --LSP Saga additions
  -- buf_inoremap { "<C-k>", "<Cmd>Lspsaga signature_help<cr>" }
  -- buf_nnoremap { "<leader>gr", "<Cmd>Lspsaga rename<cr>"}
  -- buf_nnoremap { "K", "<Cmd>Lspsaga hover_doc<cr>" }
  -- buf_nnoremap { "gd", "<Cmd>Lspsaga lsp_finder<cr>"}
  -- buf_nnoremap { "<leader>gn", "<Cmd>Lspsaga diagnostic_jump_next<cr>"}
  -- buf_nnoremap { "<leader>gp", "<Cmd>Lspsaga diagnostic_jump_prev<cr>" }
end

-- This is supposed to show this in a popup window, but it is not working. Likely a conflict with ALE
-- vim.diagnostic.config({
--   virtual_text = false
-- })
-- vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- Lua Setup - need to get sunmeko setup
-- require('nlua.lsp.nvim').setup(require('lspconfig'), {
--   on_attach = custom_attach,
--   globals = {
--     -- Colorbuddy
--     "Color", "c", "Group", "g", "s"
--   }
-- })

-- Rust Setup
require'lspconfig'.rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = custom_attach
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

-- LUA
-- Installation
-- Install via VSCode
require'lspconfig'.sumneko_lua.setup{
  capabilities = capabilities,
  on_attach = custom_attach
}

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

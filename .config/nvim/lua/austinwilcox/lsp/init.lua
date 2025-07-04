local nmap = require("austinwilcox.keymap").nmap

local has_lsp, _ = pcall(require, "lspconfig")
if not has_lsp then
	return
end

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

	--NOTE: This is adding floating window help for functions while typing
	-- require "lsp_signature".on_attach({
	--   bind = true, -- This is mandatory, otherwise border config won't get registered.
	--   handler_opts = {
	--     border = "rounded"
	--   }
	-- }, buffer_number)

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
-- capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Rust Setup
-- require'lspconfig'.rust_analyzer.setup({
--   capabilities = capabilities,
--   on_attach = custom_attach
-- })

-- Lua Setup
require("lspconfig").lua_ls.setup({
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

require("lspconfig").r_language_server.setup({
	-- capabilities = custom_attach,
	on_attach = custom_attach,
	flags = { debounc_text_changes = 150 },
})

-- vim.lsp.start({
--   name = 'bash-language-server',
--   cmd = {'bash-language-server', 'start'},
--   capabilities = capabilities,
--   on_attach = custom_attach,
-- })
-- -- Bash Lanaguage Server
-- require'lspconfig'.bashlanguageserver.setup{
-- }

-- Typescript Setup
require("lspconfig").ts_ls.setup({
	capabilities = capabilities,
	on_attach = custom_attach,
	root_dir = require("lspconfig").util.root_pattern("package.json"),
})

-- Deno Setup
-- Currently this interferes to much with ts_ls
require("lspconfig").denols.setup({
	capabilities = capabilities,
	on_attach = custom_attach,
	root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
})

require("lspconfig").marksman.setup({
	capabilities = capabilities,
	on_attach = custom_attach,
	filetypes = { "md" },
})

--CSS
--Installation
--npm install --location=global vscode-langservers-extracted
--npm install --save vscode-css-languageservice
require("lspconfig").cssls.setup({
	capabilities = capabilities,
	on_attach = custom_attach,
})

-- TailwindCSS
require("lspconfig").tailwindcss.setup({
	capabilities = capabilities,
	on_attach = custom_attach,
})

--GO
require("lspconfig").gopls.setup({
	capabilities = capabilities,
	on_attach = custom_attach,
})

require("lspconfig").vls.setup({
	capabilities = capabilities,
	on_attach = custom_attach,
	filetypes = { "vue" },
	cmd = { "vls" },
})

-- Omnisharp Setup
require("lsp-format").setup({})
local on_attach = function(client)
	require("lsp-format").on_attach(client)
	vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")
	custom_attach(client)
end

-- local mason_root = vim.fn.stdpath "data" .. "/mason/packages/"
-- require("lspconfig").omnisharp.setup({
-- 	cmd = { "dotnet", mason_root .. "omnisharp/libexec/OmniSharp.dll" },
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- 	filetypes = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets", "tproj", "slngen", "fproj" },
-- 	settings = {
-- 		FormattingOptions = {
-- 			OrganizeImports = true,
-- 		},
-- 	},
-- })

require("lspconfig").omnisharp.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets", "tproj", "slngen", "fproj" },
	enable_roslyn_analysers = true,
	enable_import_completion = true,
	organize_imports_on_format = true,
	enable_decompilation_support = true,
	handlers = {
		["textDocument/definition"] = require("omnisharp_extended").definition_handler,
		["textDocument/typeDefinition"] = require("omnisharp_extended").type_definition_handler,
		["textDocument/references"] = require("omnisharp_extended").references_handler,
		["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
	},
	cmd = { "dotnet",
	  "/home/austin/Downloads/omnisharp-linux-x64-net6.0/OmniSharp.dll",
	},
})

require("lspconfig").emmet_language_server.setup(capabilities)

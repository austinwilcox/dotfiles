   " _____                   __   .__              __      __ .__ .__                          
  " /  _  \   __ __  _______/  |_ |__|  ____      /  \    /  \|__||  |    ____   ____ ___  ___ 
 " /  /_\  \ |  |  \/  ___/\   __\|  | /    \     \   \/\/   /|  ||  |  _/ ___\ /  _ \\  \/  / 
" /    |    \|  |  /\___ \  |  |  |  ||   |  \     \        / |  ||  |__\  \___(  <_> )>    <  
" \____|__  /|____//____  > |__|  |__||___|  /      \__/\  /  |__||____/ \___  >\____//__/\_ \ 
   "      \/            \/                 \/            \/                  \/             \/ 
                                                                                             
 " _______         .__              _________                   _____ .__    ____              
 " \      \ ___  __|__|  _____      \_   ___ \   ____    ____ _/ ____\|__|  / ___\             
 " /   |   \\  \/ /|  | /     \     /    \  \/  /  _ \  /    \\   __\ |  | / /_/  >            
" /    |    \\   / |  ||  Y Y  \    \     \____(  <_> )|   |  \|  |   |  | \___  /             
" \____|__  / \_/  |__||__|_|  /     \______  / \____/ |___|  /|__|   |__|/_____/              
   "      \/                 \/             \/              \/                                 

syntax on
set ignorecase
set smartcase
set noerrorbells
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set nowrap
set noswapfile
set nobackup
set incsearch
set smartindent
set showmatch
set wildmenu
set autoindent
set relativenumber
set nu
set hidden
set undodir=~/.vim/undodir
set undofile
set signcolumn=yes
set modifiable
set encoding=UTF-8
set clipboard=unnamedplus       " Copy/paste between vim and other programs.
filetype indent on
set colorcolumn=80
highlight ColorColumn ctermbg=7

"-- Auto Completion --"
filetype plugin on
set omnifunc=syntaxcomplete#Complete

call plug#begin('~/.config/nvim/plugged')
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'austinwilcox/pretty-fold.nvim'
Plug 'arcticicestudio/nord-vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

<<<<<<< HEAD
" Testing out lsp for typescript
Plug 'neovim/nvim-lspconfig'
=======
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
>>>>>>> 54dfe60e18971df09163eb968f434ebc50eeb758

Plug 'kyoz/purify', { 'rtp': 'vim' }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'ray-x/go.nvim'

" Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'leoluz/nvim-dap-go'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'nvim-telescope/telescope-dap.nvim'

Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dotenv'

Plug 'gruvbox-community/gruvbox'

" Prettier code formatter for web dev stack
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }

Plug 'nvim-telescope/telescope.nvim'
Plug 'dracula/vim', { 'as':'dracula' }
Plug 'leafgarland/typescript-vim'
Plug 'ternjs/tern_for_vim', { 'do' : 'npm install' }
Plug 'preservim/nerdtree' | 
  \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color' " Color previews for CSS
Plug 'dense-analysis/ale'

Plug 'sindrets/winshift.nvim'
Plug 'jiangmiao/auto-pairs' "this will auto close ( [ {
"
" these two plugins will add highlighting and indenting to JSX and TSX files.
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
call plug#end()

colorscheme gruvbox
highlight Normal guibg=none
set background=dark

"Formatting for GOlang
autocmd BufWritePre *.go :silent! lua require('go.format').gofmt()
lua <<EOF
require('go').setup()
EOF

nnoremap <leader>gf :lua require("go.format").gofmt()<cr>


let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

let g:UltiSnipsSnippetDirectories=['~/.dotfiles/snippets/']
let g:UltiSnipsExpandTrigger="<tab>"               
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
"Add CSharp Snippets
"Not needed, but this syntax could be useful
"autocmd BufNewFile,BufRead cs UltiSnipsAddFileTypes cs

let g:user_emmet_leader_key=','
let g:AutoPairsShortcutToggle = ''
nnoremap <M-p> <Nop>

"I wanted an easier way to quickly go in and change up commands in my vimrc
nnoremap <leader>ev :e ~/.config/nvim/init.vim<CR>

"Number 1 Primeagen vim remap
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==

"What should be the default in vim
nnoremap Y y$

"Why is this not the default? reposition the find to the middle of the screen.
nmap n nzz

"Forgot to run vim as sudo? Not a problem, this command fixes that and allows
"you to save the file still
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

let mapleader = " "
nnoremap <leader>wh :wincmd h<CR>
nnoremap <leader>wj :wincmd j<CR>
nnoremap <leader>wk :wincmd k<CR>
nnoremap <leader>wl :wincmd l<CR>
nnoremap <silent> <Leader>+ :vertical resize +5<CR>
nnoremap <silent> <Leader>- :vertical resize -5<CR>

" ALE: {{{
let g:ale_sign_error = '•'
let g:ale_sign_warning = '•'
let g:ale_sign_info = '·'
let g:ale_sign_style_error = '·'
let g:ale_sign_style_warning = '·'

let g:ale_linters = { 'cs': ['OmniSharp'] }
" }}}

inoremap <c-u> <c-r>=trim(system('uuidgen'))<cr>

" Vim Fugitive keybindings
nmap <leader>gn :diffget //3<CR>
nmap <leader>gt :diffget //2<CR>
nmap <leader>gs :G<CR>

"Harpoon key bindings
nnoremap <leader>ha :lua require("harpoon.mark").add_file()<cr>
nnoremap <leader>hs :lua require("harpoon.ui").toggle_quick_menu()<cr>
nnoremap <leader>hn :lua require("harpoon.ui").nav_file(1)<cr>
nnoremap <leader>he :lua require("harpoon.ui").nav_file(2)<cr>
nnoremap <leader>hi :lua require("harpoon.ui").nav_file(3)<cr>
nnoremap <leader>ho :lua require("harpoon.ui").nav_file(4)<cr>

" Nerd Tree Bindings "
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Custom convert hex to rgba
nnoremap <leader>cs :call v:lua.hex2rgb()<CR>

nnoremap <leader>vtt :call v:lua.VimTODOTree()<CR>

" Search with the visually selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Snippets in my dotfiles folder
nnoremap ,html :-1read $HOME/.dotfiles/skeletons/skeleton.html<CR>3jwf>a
nnoremap ,react :-1read $HOME/.dotfiles/skeletons/skeleton.jsx<CR>2j3wce
nnoremap ,vue :-1read $HOME/.dotfiles/skeletons/skeleton.vue<CR>ja
nnoremap ,csdto :-1read $HOME/.dotfiles/skeletons/csdto.cs<CR>4jwce

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Open terminal inside Vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Leader>tt :vnew term://bash<CR>
:tnoremap <Esc> <C-\><C-n>

autocmd BufNewFile,BufRead *.cs set formatprg=astyle\ -T4pb

" Exit Vim if NERDTree is the only window left "
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
"Autocomplete config
lua <<EOF
local cmp = require 'cmp'
cmp.setup {
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  },
  sources = {
    { name = 'nvim_lsp' },
  }
}
EOF

" Gopls
lua <<EOF
  require'lspconfig'.gopls.setup{}
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
-- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require'lspconfig'.tsserver.setup {
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
      vim.keymap.set("n", "<leader>df", vim.diagnostic.goto_next, {buffer=0})
      vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer=0})
      vim.keymap.set("n", "<leader>dr", vim.lsp.buf.rename, {buffer=0})
      vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {buffer=0})
    end
  }

EOF

lua <<EOF
  require'lspconfig'.gopls.setup{}
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
-- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require'lspconfig'.tsserver.setup {
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
      vim.keymap.set("n", "<leader>df", vim.diagnostic.goto_next, {buffer=0})
      vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer=0})
      vim.keymap.set("n", "<leader>dr", vim.lsp.buf.rename, {buffer=0})
      vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {buffer=0})
    end
  }

EOF


" Volar vuejs
lua <<EOF
-- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  require'lspconfig'.vls.setup {
    capabilities = capabilities,
  }
EOF


" Tsserver with lsp
lua <<EOF
  require'lspconfig'.tsserver.setup{}
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
-- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require'lspconfig'.tsserver.setup {
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
      vim.keymap.set("n", "<leader>df", vim.diagnostic.goto_next, {buffer=0})
      vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer=0})
      vim.keymap.set("n", "<leader>dr", vim.lsp.buf.rename, {buffer=0})
      vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {buffer=0})
    end
  }
EOF


" Omnisharp with lsp
lua <<EOF
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
require'lspconfig'.omnisharp.setup {
  capabilities = capabilities,
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
    vim.keymap.set("n", "<leader>df", vim.diagnostic.goto_next, {buffer=0})
    vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer=0})
    vim.keymap.set("n", "<leader>dr", vim.lsp.buf.rename, {buffer=0})
    vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {buffer=0})
  end,
  cmd = { "/home/austin/.config/omnisharp/OmniSharp", "--languageserver" , "--hostPID", tostring(pid) },
}

require("nvim-lsp-installer").setup({
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})
EOF

lua <<EOF

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require'lspconfig'.cssls.setup{
  capabilities = capabilities
}
EOF

lua <<EOF
require('pretty-fold').setup{ }
require('pretty-fold.preview').setup {
   key = 'h', -- choose 'h' or 'l' key
}
require('lualine').setup {
    options = { theme = 'gruvbox' }
  }
EOF

lua <<EOF
function _G.hex2rgb()
  local r,c = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = vim.api.nvim_buf_get_lines(0,r-1,r,false)
  local line = unpack(lines)
  local beginningindexofhexcode = string.find(line, '#%x%x%x%x%x')
  local length = 6
  if beginningindexofhexcode == nil then
    beginningindexofhexcode = string.find(line, '#%x%x%x')
    length = 3
    if beginningindexofhexcode == nil then
      return ''
    end
  end
  local hexcode = string.sub(line, beginningindexofhexcode, beginningindexofhexcode + length)
  local rgba = getrgbafromhex(hexcode)
  vim.api.nvim_buf_set_text(0,r-1,beginningindexofhexcode -1,r-1,beginningindexofhexcode + hexcode:len() -1,{rgba})
  return ''
end

function getrgbafromhex(hex)
  local hexwithnopoundsign = hex:gsub("#","")
  local red, green, blue
  if hexwithnopoundsign:len() == 3 then
    red = tonumber("0x"..hexwithnopoundsign:sub(1,1)) * 17
    green = tonumber("0x"..hexwithnopoundsign:sub(2,2)) * 17
    blue = tonumber("0x"..hexwithnopoundsign:sub(3,3)) * 17
  else
    red = tonumber("0x"..hexwithnopoundsign:sub(1,2))
    green = tonumber("0x"..hexwithnopoundsign:sub(3,4))
    blue = tonumber("0x"..hexwithnopoundsign:sub(5,6))
  end
  local rgba = "rgba(" .. tostring(red) ..  "," .. tostring(green) .. "," .. blue ..",1.0)"

  return rgba
end
EOF

lua <<EOF
<<<<<<< HEAD

=======
function _G.VimTODOTree()
  vim.cmd('20 vsplit')
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, buf)

  print("Test this out");
end
>>>>>>> 54dfe60e18971df09163eb968f434ebc50eeb758
EOF

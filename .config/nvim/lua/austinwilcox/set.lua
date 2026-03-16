local utils = require("austinwilcox.utils")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.loaded_matchparen = 1
vim.g.copilot_assume_mapped = true

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
vim.opt.conceallevel = 0
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false

if utils.IsUnix() then
  local undodir = os.getenv("HOME") .. "/.vim/undodir"
  vim.fn.mkdir(undodir, "p")
  vim.opt.undodir = undodir
end

vim.opt.undofile = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.wildmenu = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.cmdheight = 1
vim.opt.updatetime = 50
vim.opt.colorcolumn = "120"
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "UTF-8"
vim.opt.modifiable = true
vim.opt.background = "dark"

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

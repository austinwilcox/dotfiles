-- Ultisnips setup
vim.cmd[[
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpFowardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:UltiSnipsSnippetDirectories=["UltiSnips", "my_snippets"]
]]

-- Signify Setup
vim.cmd[[
let g:signify_sign_add = '+'
let g:signify_sign_delete = '_'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change = '~'

let g:signify_sign_show_count = 0
let g:signify_sign_show_text = 1
]]

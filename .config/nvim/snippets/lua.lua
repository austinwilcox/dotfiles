local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {}

local group = vim.api.nvim_create_augroup("Lua Snippets", { clear = true })
local file_pattern = "*.lua"

local myFirstSnippet = s("myFirstSnippet", {
  t("Hi! This is my first snippet in Luasnip"),
  i(1, "Placeholder text"),
  t({ "", "this is another text node just below it"})
})
table.insert(snippets, myFirstSnippet)

local mySecondSnippet = s("mySecondSnippet", fmt([[
local {} = function({})
{}
end
]], {
    i(1, "myVar"),
    i(2, "myArg"),
    i(3, "~~ TOD: Something"),
  }))
table.insert(snippets, mySecondSnippet)

return snippets, autosnippets


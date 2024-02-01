-- local ls = require("luasnip")

-- require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

-- ls.config.set_config({
--   history = true,
--   updateevents = "TextChanged,TextChangedI",
--   enable_autosnippets = true,
--   ext_opts = {
--     [require("luasnip.util.types").choiceNode] = {
--       active = {
--         virt_text = { { "*", "GruvboxOrange"} },
--       },
--     },
--   },
-- })

-- vim.keymap.set({ "i", "s" }, "<a-p>", function()
--   if ls.expand_or_jumpable() then
--     ls.expand()
--   end
-- end)


-- vim.keymap.set({ "i", "s" }, "<a-k>", function()
--   if ls.jumpable(1) then
--     ls.jump(1)
--   end
-- end)
-- vim.keymap.set({ "i", "s" }, "<a-j>", function()
--   if ls.jumpable(-1) then
--     ls.jump(-1)
--   end
-- end)

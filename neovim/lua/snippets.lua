local ls = require"luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local rep = require("luasnip.extras").rep

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
-- local function copy(args)
-- 	return args[1]
-- end

ls.add_snippets("go", {
    --s("fn", {
    --    -- Simple static text.
	--	t("// Descripion... "),
	--	-- function, first parameter is the function, second the Placeholders
	--	-- whose text it gets as input.
	--	f(copy, 2),
	--	t({ "", "func" }),
	--	-- Placeholder/Insert.
	--	i(1),
	--	t("("),
	--	-- Placeholder with initial text.
	--	i(2, "foo int"),
	--	-- Linebreak
	--	t({ ") {", "\t" }),
	--	-- Last Placeholder, exit Point of the snippet.
	--	i(0),
	--	t({ "", "}" }),
    --}),
    s("fn", fmt("// {} doos the following.\n{} func {}({}) {} {{\n\t{}\n}}\n", {i(1), i(2), rep(1), i(3), i(4), i(5)})),
    s("Desc", fmt("var _ = Describe(\"{}\", func() {{\n\t{}\n}})", {i(1), i(0)})),
    s("Cont", fmt("Context(\"{}\", func() {{\n\t{}\n}})", {i(1), i(0)})),
    s("It", fmt("It(\"{}\", func() {{\n\t{}\n}})", {i(1), i(0)})),
    s("Before", fmt("BeforeEach(func() {{\n\t{}\n}})", {i(0)})),
    s("Just", fmt("JustBeforeEach(func() {{\n\t{}\n}})", {i(0)})),
})

vim.opt.termguicolors = true            -- True color support

-- theme
--
vim.cmd('colorscheme solarized')

-- lualine
--
require('lualine').setup {
    options = { theme  = 'solarized_dark'}
}

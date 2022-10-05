-- telescope
--
require('telescope').setup {
  defaults = {
      mappings = {
          n = {
            ["q"] = require('telescope.actions').close
          }
      },
      file_ignore_patterns = {
          "node_modules",
      }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      case_mode = "ignore_case",       -- ignore case
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
    }
  }
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')


local tb = require 'telescope.builtin'
local te = require 'telescope'.extensions
-- Find files
vim.keymap.set("n", "<leader>o", tb.find_files, opts)
-- Grep string under cursor
vim.keymap.set("n", "<leader>s", tb.grep_string, opts)
-- Live grep files
vim.keymap.set("n", "<leader>r", tb.live_grep, opts)
-- List buffers
vim.keymap.set("n", "<leader>b", tb.buffers, opts)
-- Pick git branch
vim.keymap.set("n", "<leader>gb", tb.git_branches, opts)
-- symbols
vim.keymap.set("n", "<leader>t", tb.lsp_document_symbols, opts)
-- file explorer
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<cr>", opts)
-- vim.keymap.set("n", "<leader>f", te.file_browser.file_browser, opts)

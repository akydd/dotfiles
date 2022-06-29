-- Helper functions
--
local nmap = function(key)
  -- get the extra options
  local opts = {noremap = true}
  for i, v in pairs(key) do
    if type(i) == 'string' then opts[i] = v end
  end

  vim.api.nvim_set_keymap("n", key[1], key[2], opts)
end

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

-- Find files
nmap{"<leader>o", ":lua require('telescope.builtin').find_files()<CR>", opts}
-- Grep string under cursor
nmap{"<leader>s", ":lua require('telescope.builtin').grep_string()<CR>", opts}
-- Live grep files
nmap{"<leader>r", ":lua require('telescope.builtin').live_grep()<CR>", opts}
-- List buffers
nmap{"<leader>b", ":lua require('telescope.builtin').buffers()<CR>", opts}
-- Pick git branch
nmap{"<leader>gb", ":lua require('telescope.builtin').git_branches()<CR>", opts}
-- symbols
nmap{"<leader>t", ":lua require('telescope.builtin').lsp_document_symbols()<CR>", opts}


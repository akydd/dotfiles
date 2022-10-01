local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g      -- a table to access global variables

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

-- Make <space> the leader key
--
nmap{'<space>', '<nop>'}
g.mapleader = " "

require('plugins')
require('treesitter')
require('theme')
require('options')
require('ts') -- telescope
require('snippets')
require('autocomplete')
require('git')
require('tm') -- tmux

-- quick reload of snippets
vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/snippets.lua<CR>")

-- linters. I rely on jshint for anything js related because dev node version is too old to run tsserver.
--
g.ale_linters = {
    elm = 'elm_ls',
    javascript = 'eslint',
}

-- lsp
--
local nvim_lsp = require 'lspconfig'

-- diagnostics
local lspopts = { noremap=true, silent=true }

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, lspopts)
vim.keymap.set("n", "<leader>pe", vim.lsp.diagnostic.goto_prev, lspopts)
vim.keymap.set("n", "<leader>ne", vim.lsp.diagnostic.goto_next, lspopts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, lspopts)

-- disable virtual_text (inline) diagnostics and use floating window
-- format the message such that it shows source, message and
-- the error code. Show the message with <space>e
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	float = {
		border = "single",
		format = function(diagnostic)
			return string.format(
				"%s (%s) [%s]",
				diagnostic.message,
				diagnostic.source,
				diagnostic.code or diagnostic.user_data.lsp.code
			)
		end,
	},
})

-- update the quickfix list with up-to-date diagnostic info
vim.api.nvim_create_augroup('diagnostics', { clear = true })

  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    group = 'diagnostics',
    callback = function(args)
      vim.diagnostic.setqflist({ open = false })
    end,
  })

-- autocommand group for lsp formatting
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- format on save, if supported
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                vim.lsp.buf.formatting_sync()
            end,
        })
    end

    -- organize imports, for go only
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        -- pattern = { "*.go" },
        callback = function()
            local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
            params.context = {only = {"source.organizeImports"}}

            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
            for _, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                    if r.edit then
                        vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
                    else
                        vim.lsp.buf.execute_command(r.command)
                    end
                end
            end
        end,
    })


    local lspbufopts = { noremap=true, silent=true, buffer=bufnr }

    -- Enable completion triggered by <c-x><c-o>
    -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, lspopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, lspopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, lspopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, lspbufopts)
    vim.keymap.set("n", "gn", vim.lsp.buf.rename, lspbufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, lspbufopts)
    vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, lspbufopts)
    --vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, lspbufopts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, lspbufopts)
    vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, lspbufopts)

    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, lspbufopts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, lspbufopts)
    vim.keymap.set("n", "<space>wl", vim.inspect(vim.lsp.buf.list_workspace_folders), lspbufopts)
end

local servers = { 'gopls', 'eslint', 'ccls', 'pylsp' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- sort imports for go on save
--
function OrgImports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit)
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end 
end

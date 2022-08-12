local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()

local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

-- Plugins
--
require "paq" {
    "ishan9299/nvim-solarized-lua";
    "savq/paq-nvim";                  -- Let Paq manage itself

    -- Treesitter
    {"nvim-treesitter/nvim-treesitter", run = 'TSUpdate'};
    "nvim-treesitter/nvim-treesitter-textobjects";

    -- lualine
    "nvim-lualine/lualine.nvim";
    "kyazdani42/nvim-web-devicons";

    "neovim/nvim-lspconfig";

    -- autocomplete plugins
    "hrsh7th/nvim-cmp";
    "hrsh7th/cmp-nvim-lsp";

    -- snippets
    "L3MON4D3/LuaSnip";
    "saadparwaiz1/cmp_luasnip";

    -- telescope
    "nvim-lua/plenary.nvim";
    "nvim-lua/popup.nvim";
    "nvim-telescope/telescope.nvim";
    {"nvim-telescope/telescope-fzf-native.nvim", run = 'make'};
    "nathom/tmux.nvim";

    "dense-analysis/ale";

    "machakann/vim-sandwich";

    -- tmux window switching
    "nathom/tmux.nvim";
}


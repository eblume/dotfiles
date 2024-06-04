-- Install Packer if it hasn't been installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- tpope
  use 'tpope/vim-sensible'  -- sensible defaults
  use 'tpope/vim-fugitive' -- git integration
  use 'tpope/vim-rhubarb' -- fugitive for github
  use 'tpope/vim-vinegar' -- enhancements to netrw
  use 'tpope/vim-eunuch'  -- :Move, :Rename, etc
  use 'tpope/vim-projectionist'  -- project-specific configuration
  use 'tpope/vim-surround' -- eg. cs"' to change surrounding quotes
  

  -- 'vim-fubitive' - vim-fugitive for bitbucket. Note g:fubitive_domain_pattern config.
  use 'tommcdo/vim-fubitive'

  -- autoclose.nvim -- lua-based autoclose with smart newlines and such. Minimal.
  use 'm4xshen/autoclose.nvim'

  -- lualine (statusline)
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Configurations for Nvim LSP
  use 'neovim/nvim-lspconfig'

  -- Crystal syntax, etc.
  use 'vim-crystal/vim-crystal'

  -- Tokyo Night color scheme
  use 'folke/tokyonight.nvim'

  -- fzf file finder (mru, history, etc.)
  use 'junegunn/fzf'  -- We will let `yadm bootstrap` handle upgrading fzf, so no fzf#install()
  use 'junegunn/fzf.vim'

  -- Syntax support for 100+ languages
  use 'sheerun/vim-polyglot'

  -- Dim Inactive Windows
  use 'blueyed/vim-diminactive'

  -- nvim-cmp (autocomplete/snippeting for nvim-lspconfig)
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/cmp-vsnip'

  -- python black
  use 'averms/black-nvim'

  -- github copilot
  -- (this costs $10/month, lol)
  use 'github/copilot.vim'


  -- Indentation movement with [-, [+, and [=  (and the ]-versions of those)
  use 'jeetsukumaran/vim-indentwise'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

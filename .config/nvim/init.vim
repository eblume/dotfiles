" Load packer.nvim plugins (via .config/nvim/lua/plugins.lua)
lua require('plugins')

" Configure lualine
lua << EOD
  require('lualine').setup()
EOD


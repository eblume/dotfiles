{ pkgs, ... }:
{

  plugins = [
    pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    pkgs.vimPlugins.vim-matchup # Better % jumping in languages
    pkgs.vimPlugins.nginx-vim
    pkgs.vimPlugins.vim-helm
    (pkgs.vimUtils.buildVimPlugin {
      # Noah built this thing which does something I don't get to indentation
      pname = "nmasur";
      version = "0.1";
      src = ../plugin;
    })
  ];

  setup."nvim-treesitter.configs" = {
    highlight = {
      enable = true;
    };
    indent = {
      enable = true;
    };
    matchup = {
      enable = true;
    }; # Uses vim-matchup

    textobjects = {
      select = {
        enable = true;
        lookahead = true; # Jump forward automatically

        keymaps = {
          "['af']" = "@function.outer";
          "['if']" = "@function.inner";
          "['ac']" = "@class.outer";
          "['ic']" = "@class.inner";
          "['al']" = "@loop.outer";
          "['il']" = "@loop.inner";
          "['aa']" = "@call.outer";
          "['ia']" = "@call.inner";
          "['ar']" = "@parameter.outer";
          "['ir']" = "@parameter.inner";
          "['aC']" = "@comment.outer";
          "['iC']" = "@comment.outer";
          "['a/']" = "@comment.outer";
          "['i/']" = "@comment.outer";
          "['a;']" = "@statement.outer";
          "['i;']" = "@statement.outer";
        };
      };
    };
  };

  # Use mkAfter to ensure tree-sitter is already loaded
  # lua = lib.mkAfter ''
  #   -- Use HCL parser with .tf files
  #   vim.treesitter.language.register('hcl', 'terraform')
  # '';
}

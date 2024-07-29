# Gitlab support (mainly vim-fugitive + vim-fugitive-gitlab)
{ pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  # TODO: support WSL with 'start' maybe?
  open = if isLinux then "{pkgs.xdg-utils}/bin/xdg-open" else "open";
in
{

  # See https://github.com/shumphrey/fugitive-gitlab.vim/

  plugins = [
    pkgs.vimPlugins.vim-fugitive
    pkgs.vimPlugins.fugitive-gitlab-vim
  ];

  # Enable :GBrowse even though NetRW is disabled
  # thanks: https://vi.stackexchange.com/questions/38447/vim-fugitive-netrw-not-found-define-your-own-browse-to-use-gbrowse
  lua = ''
    -- Lua-based :Browse (fixes fugitive without NetRW)
    vim.api.nvim_create_user_command(
      'Browse',
      function (opts)
        vim.fn.system { '${open}', opts.fargs[1] }
      end,
      { nargs = 1 }
    )
  '';

}

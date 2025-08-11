{ pkgs, dsl, ... }:
{

  plugins = [
    pkgs.vimPlugins.blink-cmp
    pkgs.vimPlugins.luasnip
    pkgs.vimPlugins.friendly-snippets
  ];

  use.blink-cmp.setup = dsl.callWith {
    # https://cmp.saghen.dev/configuration/general.html
    opts = {
      keymap.preset = "default"; # like neovim default, ctrl-y to accept
      appearance.nerd_font_variant = "mono";
      completion.documentation.auto_show = true;
      sources.default = [
        "lsp"
        "path"
        "snippets"
        "buffer"
      ];
      fuzzy.implementation = "prefer_rust_with_warning";
      signature.enabled = true;
    };
    dependencies =
      dsl.rawLua # lua
        ''
          { 'L3MON4D3/LuaSnip', version = 'v2.*' }
        '';
  };
}

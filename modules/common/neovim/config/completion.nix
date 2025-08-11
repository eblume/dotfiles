{ pkgs, dsl, ... }:
{

  plugins = [
    pkgs.vimPlugins.blink-cmp
    pkgs.vimPlugins.luasnip
    pkgs.vimPlugins.friendly-snippets
  ];

  use."blink.cmp".setup = dsl.callWith {
    # https://cmp.saghen.dev/configuration/general.html
    keymap =
      dsl.rawLua # lua
        ''
          {
            preset = "default", -- like neovim default, <C-y> to accept
            ["<C-d>"] = { "show", "show_documentation", "hide_documentation"}, -- <C-space> def conflicts with hammerspoon
          }
        '';
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
}

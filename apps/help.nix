{ pkgs, ... }:
{

  type = "app";

  program = builtins.toString (
    pkgs.writeShellScript "default" ''
      ${pkgs.gum}/bin/gum style --margin "1 2" --padding "0 2" --foreground "15" --background "55" "Options"
      ${pkgs.gum}/bin/gum format --type=template -- '  {{ Italic "Run with" }} {{ Color "15" "69" " nix run github:eblume/dotfiles#" }}{{ Color "15" "62" "someoption" }}{{ Color "15" "69" " " }}.'
      echo ""
      echo ""
      ${pkgs.gum}/bin/gum format --type=template -- \
          '  • {{ Color "15" "57" " rebuild " }} {{ Italic "Switch to this configuration." }}' \
          '  • {{ Color "15" "57" " neovim " }} {{ Italic "Test out the Neovim package." }}' \
          '  • {{ Color "15" "57" " help " }} {{ Italic "Show this help message." }}'
      echo ""
      echo ""
    ''
  );
}

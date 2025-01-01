{
  pkgs,
  lib,
  dsl,
  ...
}:
{

  options.github = lib.mkEnableOption "Whether to enable GitHub features";
  options.kubernetes = lib.mkEnableOption "Whether to enable Kubernetes features";

  config = {
    plugins = [
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.conform-nvim
      pkgs.vimPlugins.fidget-nvim
      pkgs.vimPlugins.nvim-lint
      pkgs.vimPlugins.vim-table-mode
    ];

    setup.fidget = { };

    use.lspconfig.lua_ls.setup = dsl.callWith {
      settings = {
        Lua = {
          diagnostics = {
            globals = [
              "vim"
              "hs"
            ];
          };
        };
      };
      capabilities = dsl.rawLua "require('cmp_nvim_lsp').default_capabilities()";
      cmd = [ "${pkgs.lua-language-server}/bin/lua-language-server" ];
    };

    use.lspconfig.ansiblels.setup = dsl.callWith {
      capabilities = dsl.rawLua "require('cmp_nvim_lsp').default_capabilities()";
      cmd = [
        "${pkgs.ansible-language-server}/bin/ansible-language-server"
        "--stdio"
      ];
    };

    use.lspconfig.nixd.setup = dsl.callWith {
      cmd = [ "${pkgs.nixd}/bin/nixd" ];
      capabilities = dsl.rawLua "require('cmp_nvim_lsp').default_capabilities()";
      extraOptions.offset_encoding = "utf-8"; # See https://github.com/neovim/neovim/issues/30675
    };

    # DISABLED 1 Jan 2025 [happy new year :(]
    # because of this: https://github.com/razzmatazz/csharp-language-server/issues/211
    # Or rather because of that bug reporter marking the package as unsafe
    # and then I could not find a way to roll back to 0.15
    #
    # use.lspconfig.csharp_ls.setup = dsl.callWith {
    #   capabilities = dsl.rawLua "require('cmp_nvim_lsp').default_capabilities()";
    #   cmd = [
    #     "${pkgs.csharp-ls}/bin/csharp-ls"
    #   ];
    #   # The default config will chdir to the containing .sln or .csproj file, which
    #   # makes sense in most C# projects but completely breaks our pulumi infra repo
    #   # So instead, we root on .git
    #   root_dir = dsl.rawLua "require('lspconfig.util').root_pattern('.git')";
    # };

    use.lspconfig.pyright.setup = dsl.callWith {
      capabilities = dsl.rawLua "require('cmp_nvim_lsp').default_capabilities()";
      cmd = [
        "${pkgs.pyright}/bin/pyright-langserver"
        "--stdio"
      ];
    };

    use.lspconfig.tsserver.setup = dsl.callWith {
      capabilities = dsl.rawLua "require('cmp_nvim_lsp').default_capabilities()";
      cmd = [
        "${pkgs.nodePackages_latest.typescript-language-server}/bin/typescript-language-server"
        "--stdio"
      ];
    };

    use.lspconfig.rust_analyzer.setup = dsl.callWith {
      capabilities = dsl.rawLua "require('cmp_nvim_lsp').default_capabilities()";
      cmd = [ "${pkgs.rust-analyzer}/bin/rust-analyzer" ];
      settings = {
        "['rust-analyzer']" = {
          check = {
            command = "clippy";
          };
          files = {
            excludeDirs = [ ".direnv" ];
          };
        };
      };
    };

    setup.conform = {
      format_on_save = {
        # These options will be passed to conform.format()
        timeout_ms = 1500;
        lsp_fallback = true;
      };
      formatters_by_ft = {
        lua = [ "stylua" ];
        python = [ "black" ];
        fish = [ "fish_indent" ];
        nix = [ "nixfmt" ];
        rust = [ "rustfmt" ];
        sh = [ "shfmt" ];
        hcl = [ "hcl" ];
      };
      formatters = {
        lua.command = "${pkgs.stylua}/bin/stylua";
        black.command = "${pkgs.black}/bin/black";
        fish_indent.command = "${pkgs.fish}/bin/fish_indent";
        nixfmt.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        rustfmt.command = "${pkgs.rustfmt}/bin/rustfmt";
        shfmt = {
          command = "${pkgs.shfmt}/bin/shfmt";
          prepend_args = [
            "-i"
            "4"
            "-ci"
          ];
        };
        hcl.command = "${pkgs.hclfmt}/bin/hclfmt";
      };
    };

    use.lint = {
      linters_by_ft = dsl.toTable {
        python = [ "ruff" ];
        sh = [ "shellcheck" ];
      };
    };

    vim.api.nvim_create_autocmd = dsl.callWith [
      (dsl.toTable [
        "BufEnter"
        "BufWritePost"
      ])
      (dsl.rawLua "{ callback = function() require('lint').try_lint() end }")
    ];

    lua = ''
      ${builtins.readFile ./lsp.lua}

      local ruff = require('lint').linters.ruff; ruff.cmd = "${pkgs.ruff}/bin/ruff"
      local shellcheck = require('lint').linters.shellcheck; shellcheck.cmd = "${pkgs.shellcheck}/bin/shellcheck"

      -- Prevent infinite log size (change this when debugging)
      vim.lsp.set_log_level("off")
    '';
  };
}

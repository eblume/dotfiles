{ pkgs, dsl, ... }: {

  plugins = [
    pkgs.vimPlugins.nvim-lspconfig
    pkgs.vimPlugins.lsp-colors-nvim
    pkgs.vimPlugins.null-ls-nvim
  ];

  use.lspconfig.sumneko_lua.setup = dsl.callWith {
    settings = { Lua = { diagnostics = { globals = [ "vim" "hs" ]; }; }; };
    capabilities = dsl.rawLua "require('cmp_nvim_lsp').default_capabilities()";
    cmd = [ "${pkgs.sumneko-lua-language-server}/bin/lua-language-server" ];
  };

  use.lspconfig.nil_ls.setup = dsl.callWith {
    cmd = [ "${pkgs.nil}/bin/nil" ];
    capabilities = dsl.rawLua "require('cmp_nvim_lsp').default_capabilities()";
  };

  use.lspconfig.pyright.setup = dsl.callWith {
    cmd = [ "${pkgs.pyright}/bin/pyright-langserver" "--stdio" ];
  };

  use.lspconfig.terraformls.setup =
    dsl.callWith { cmd = [ "${pkgs.terraform-ls}/bin/terraform-lsp" ]; };

  vim.api.nvim_create_augroup = dsl.callWith [ "LspFormatting" { } ];

  # setup."null-ls" = {
  #   sources = [
  #     (dsl.rawLua
  #       "require('null-ls').builtins.formatting.black.with({ command = ${pkgs.black}/bin/black })")
  #     (dsl.rawLua
  #       "require('null-ls').builtins.formatting.flake8.with({ command = ${pkgs.python310Packages.flake8}/bin/flake8 })")
  #     (dsl.rawLua
  #       "require('null-ls').builtins.formatting.fish_indent.with({ command = ${pkgs.fish}/bin/fish_indent })")
  #     (dsl.rawLua
  #       "require('null-ls').builtins.formatting.nixfmt.with({ command = ${pkgs.nixfmt}/bin/nixfmt })")
  #     (dsl.rawLua
  #       "require('null-ls').builtins.formatting.rustfmt.with({ command = ${pkgs.rustfmt}/bin/rustfmt })")
  #     (dsl.rawLua
  #       "require('null-ls').builtins.diagnostics.shellcheck.with({ command = ${pkgs.shellcheck}/bin/shellcheck })")
  #     (dsl.rawLua ''
  #       require('null-ls').builtins.formatting.shfmt.with(
  #           command = {${pkgs.shfmt}/bin/shfmt },
  #           extra_args = { '-i', '4', '-ci' },
  #       )'')
  #     (dsl.rawLua
  #       "require('null-ls').builtins.formatting.terraform_fmt.with({ command = ${pkgs.terraform}/bin/terraform })")
  #   ];
  # };

  lua = ''
    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
    vim.keymap.set("n", "gT", vim.lsp.buf.type_definition)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
    vim.keymap.set("n", "gh", vim.lsp.buf.hover)
    -- vim.keymap.set("n", "gr", telescope.lsp_references)
    vim.keymap.set("n", "<Leader>R", vim.lsp.buf.rename)
    vim.keymap.set("n", "]e", vim.diagnostic.goto_next)
    vim.keymap.set("n", "[e", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "<Leader>de", vim.diagnostic.open_float)
    vim.keymap.set("n", "<Leader>E", vim.lsp.buf.code_action)


    require("null-ls").setup({
        sources = {
            require('null-ls').builtins.formatting.stylua.with({ command = "${pkgs.stylua}/bin/stylua" }),
            require('null-ls').builtins.formatting.black.with({ command = "${pkgs.black}/bin/black" }),
            require('null-ls').builtins.diagnostics.flake8.with({ command = "${pkgs.python310Packages.flake8}/bin/flake8" }),
            require('null-ls').builtins.formatting.fish_indent.with({ command = "${pkgs.fish}/bin/fish_indent" }),
            require('null-ls').builtins.formatting.nixfmt.with({ command = "${pkgs.nixfmt}/bin/nixfmt" }),
            require('null-ls').builtins.formatting.rustfmt.with({ command = "${pkgs.rustfmt}/bin/rustfmt" }),
            require('null-ls').builtins.diagnostics.shellcheck.with({ command = "${pkgs.shellcheck}/bin/shellcheck" }),
            require('null-ls').builtins.formatting.shfmt.with({
                command = "${pkgs.shfmt}/bin/shfmt",
                extra_args = { '-i', '4', '-ci' },
            }),
            require('null-ls').builtins.formatting.terraform_fmt.with({ command = "${pkgs.terraform}/bin/terraform" }),
        },

        on_attach = function(client, bufnr)
              if client.supports_method("textDocument/formatting") then
                  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                  vim.api.nvim_create_autocmd("BufWritePre", {
                      group = augroup,
                      buffer = bufnr,
                      callback = function()
                          vim.lsp.buf.format({ bufnr = bufnr })
                      end,
                  })
              end
        end
    })
  '';

}

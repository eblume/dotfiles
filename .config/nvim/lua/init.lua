--------
-- Load Modules
-- These are my personal config modules for work, etc.
vim.cmd([[source ~/.config/nvim/kagi.vim]])

--------
-- Persistent Global Undo

-- Ensure the undodir exists
local undodir = vim.fn.expand('~/.config/nvim/undodir')
if vim.fn.isdirectory(undodir) == 0 then
    os.execute('mkdir -p ' .. undodir)
end

-- Enable persistent undo
vim.opt.undodir = undodir
vim.opt.undofile = true

--------
-- zellij run --floating -- ...
function Zrf(opts)
  local cmd = string.format("zellij run --name \"%s\" --floating -- zsh -ic \"%s\"", opts.args, opts.args)
  vim.fn.system(cmd)
end

-- Create the command
vim.api.nvim_create_user_command('Zrf', Zrf, { nargs = '*' })

--------
-- nvim-cmp suggested config for vsnip
vim.api.nvim_set_option('completeopt', 'menu,menuone,noselect,preview')
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
-----
-- END nvim-cmp suggested conf
-----

-- nvim-lspconfig suggested config
-- see: https://github.com/neovim/nvim-lspconfig#Suggested-configuration
--
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
-- Disabling space-e for float and trying out an auto-open float on hover
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>F', vim.lsp.buf.formatting, bufopts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig')['ruff'].setup{on_attach = on_attach, capabilities = capabilities}

require('lspconfig')['bashls'].setup{on_attach = on_attach, capabilities = capabilities}

require('lspconfig')['yamlls'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    yaml = {
      -- note that setting these schemas here overrides ALL default schemas... see also:
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#yamlls
      schemas = {
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        ["http://json.schemastore.org/kustomization"] = "kustomization.yaml",
      },
    },
  },
}

require('lspconfig')['solargraph'].setup{on_attach = on_attach, capabilities = capabilities}

require('lspconfig')['pyright'].setup{on_attach = on_attach, capabilities = capabilities}

-- Apparently crystalline can't handle large projects, so it's useless to me
-- require('lspconfig')['crystalline'].setup{on_attach = on_attach, capabilities = capabilities}

-- By default, filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp"}
require('lspconfig')['sourcekit'].setup{on_attach = on_attach, capabilities = capabilities}


-- Configure diagnostic floating window on hover
-- see: https://neovim.discourse.group/t/how-to-show-diagnostics-on-hover/3830/3
function OpenDiagnosticIfNoFloat()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(winid).zindex then
      return
    end
  end
  -- THIS IS FOR BUILTIN LSP
  vim.diagnostic.open_float(0, {
    scope = "cursor",
    focusable = false,
    close_events = {
      "CursorMoved",
      "CursorMovedI",
      "BufHidden",
      "InsertCharPre",
      "WinLeave",
    },
  })
end
-- Show diagnostics under the cursor when holding position
vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  command = "lua OpenDiagnosticIfNoFloat()",
  group = "lsp_diagnostics_hold",
})


-- Configure lualine
require('lualine').setup{
  options = {
    theme = 'tokyonight'
  }
}

-- Configure Copilot
vim.g.copilot_filetypes = {
  -- The docs claim 'most file types are enabled by default'
  zsh = true,
}

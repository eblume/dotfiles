-- =======================================================================
-- Completion System
-- =======================================================================

local M = {}

M.packer = function(use)
    -- Completion sources
    use("hrsh7th/cmp-nvim-lsp") --- Language server completion plugin
    use("hrsh7th/cmp-buffer") --- Generic text completion
    use("hrsh7th/cmp-path") --- Local file completion
    use("hrsh7th/cmp-cmdline") --- Command line completion
    use("hrsh7th/cmp-nvim-lua") --- Nvim lua api completion
    use("saadparwaiz1/cmp_luasnip") --- Luasnip completion
    use("lukas-reineke/cmp-rg") --- Ripgrep completion

    -- Completion engine
    use({
        "hrsh7th/nvim-cmp",
        requires = { "L3MON4D3/LuaSnip" },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<Esc>"] = function(fallback)
                        cmp.mapping({
                            i = cmp.mapping.abort(),
                            c = cmp.mapping.close(),
                        })
                        vim.cmd("stopinsert") --- Abort and leave insert mode
                    end,
                    -- ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
                    -- ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),
                    ["<C-r>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<C-l>"] = cmp.mapping(function(fallback)
                        if require("luasnip").expand_or_jumpable() then
                            require("luasnip").expand_or_jump()
                        end
                    end, { "i", "s" }),
                },
                sources = {
                    { name = "nvim_lua" },
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "luasnip" },
                    { name = "buffer", keyword_length = 3, max_item_count = 10 },
                    {
                        name = "rg",
                        keyword_length = 6,
                        max_item_count = 10,
                        option = { additional_arguments = "--ignore-case" },
                    },
                },
                experimental = {
                    native_menu = false, --- Use cmp menu instead of Vim menu
                    ghost_text = true, --- Show preview auto-completion
                },
            })

            -- Use buffer source for `/`
            cmp.setup.cmdline("/", {
                sources = {
                    { name = "buffer", keyword_length = 5 },
                },
            })

            -- Use cmdline & path source for ':'
            cmp.setup.cmdline(":", {
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
        end,
    })
end

return M

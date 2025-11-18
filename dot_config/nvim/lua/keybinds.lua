-- ===========================================================================
-- Key Mapping
-- ===========================================================================

-- Function to cut down config boilerplate
local key = function(mode, key_sequence, action, params)
  params = params or {}
  vim.keymap.set(mode, key_sequence, action, params)
end

-- Remap space as leader key
key("", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keep selection when changing indentation
key("v", "<", "<gv")
key("v", ">", ">gv")

-- Shuffle lines around
key("n", "<A-j>", ":m .+1<CR>==")
key("n", "<A-k>", ":m .-2<CR>==")
key("v", "<A-j>", ":m '>+1<CR>gv=gv")
key("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- File commands
key("n", "<Leader>q", ":quit<CR>")
key("n", "<Leader>Q", ":quitall<CR>")
key("n", "<Leader>fs", ":write<CR>")
key("n", "<Leader>fd", ":lcd %:p:h<CR>", { silent = true })
key("n", "<Leader>fu", ":lcd ..<CR>", { silent = true })
key("n", "<Leader><Tab>", ":b#<CR>", { silent = true })

-- Window commands
key("n", "<Leader>wv", ":vsplit<CR>")
key("n", "<Leader>wh", ":split<CR>")
key("n", "<Leader>wm", ":only<CR>")

-- Keep cursor in place
key("n", "n", "nzz")
key("n", "N", "Nzz")
key("n", "J", "mzJ`z") --- Mark and jump back to it

-- Add undo breakpoints
key("i", ",", ",<C-g>u")
key("i", ".", ".<C-g>u")
key("i", "!", "!<C-g>u")
key("i", "?", "?<C-g>u")

-- Resize with arrows
key("n", "<C-Up>", ":resize +2<CR>", { silent = true })
key("n", "<C-Down>", ":resize -2<CR>", { silent = true })
key("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })
key("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })

-- Quickfix
key("n", "]q", ":cnext<CR>")
key("n", "[q", ":cprevious<CR>")
key("n", "co", ":copen<CR>")
key("n", "cq", ":cclose<CR>")

-- Other
key("n", "<A-CR>", ":noh<CR>", { silent = true })           --- Clear search in VimWiki
key("n", "Y", "y$")                                         --- Copy to end of line
key("v", "<C-r>", "y<Esc>:%s/<C-r>+//gc<left><left><left>") --- Substitute selected
key("v", "D", "y'>gp")                                      --- Duplicate selected
key("x", "<Leader>p", '"_dP')                               --- Paste but keep register




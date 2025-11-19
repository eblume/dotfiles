vim.o.termguicolors = true -- Set to truecolor
vim.o.list = true -- Reveal whitespace with dashes
vim.o.expandtab = true -- Tabs into spaces
vim.o.shiftwidth = 4 -- Amount to shift with > key
vim.o.softtabstop = 4 -- Amount to shift with <TAB> key
vim.o.ignorecase = true -- Ignore case when searching
vim.o.smartcase = true -- Check case when using capitals in search
vim.o.infercase = true -- Don't match cases when completing suggestions
vim.o.incsearch = true -- Search while typing
vim.o.visualbell = true -- No sounds
vim.o.scrolljump = 1 -- Number of lines to scroll
vim.o.scrolloff = 3 -- Margin of lines to see while scrolling
vim.o.splitright = true -- Vertical splits on the right side
vim.o.splitbelow = true -- Horizontal splits on the bottom side
vim.o.clipboard = "unnamedplus" -- Uses system clipboard for yanking
vim.o.updatetime = 300 -- Faster diagnostics
vim.o.mouse = "nv" -- Mouse interaction / scrolling
vim.o.inccommand = "split" -- Live preview search and replace

vim.wo.number = true -- show line numbers
vim.wo.relativenumber = true -- use relative numbers

-- disable default swapfile, use backup
vim.o.backup = true
vim.bo.swapfile = false
vim.bo.undofile = true -- keep undos after quit
vim.o.backupdir = vim.fn.expand("~/.local/state/nvim/backup//")
vim.o.undodir = vim.fn.expand("~/.local/state/nvim/undo//")

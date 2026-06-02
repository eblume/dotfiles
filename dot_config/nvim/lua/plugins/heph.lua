-- heph.nvim — personal context manager (knowledge base + tasks), an
-- obsidian.nvim replacement. Installed from a forge checkout because lazy can't
-- load a subdir plugin from a bare git URL, so `dir` points at the clone.
--
-- Update the plugin + rebuild the daemon:
--   git -C ~/.local/share/heph/checkout pull
--   cargo install --locked \
--     --git ssh://forgejo@forge.ops.eblu.me:2222/eblume/hephaestus.git \
--     --branch feature/v1-prototype heph hephd
-- (see the repo's docs/how-to/install-heph.md)
--
-- Plug-and-play: setup() spawns and supervises its own hephd against the default
-- XDG paths (your real data), and self-heals if it dies. Lazy-loaded on :Heph
-- and the <leader>h maps, so it costs nothing until you use it.
return {
	{
		dir = vim.fn.expand("~/.local/share/heph/checkout/heph.nvim"),
		name = "heph.nvim",
		cmd = "Heph",
		keys = {
			{ "<leader>hi", "<cmd>Heph home<cr>", desc = "heph: home / index page" },
			{ "<leader>hj", "<cmd>Heph today<cr>", desc = "heph: today's journal" },
			{ "<leader>hn", "<cmd>Heph next<cr>", desc = "heph: what is next" },
			{ "<leader>hl", "<cmd>Heph list<cr>", desc = "heph: task list" },
			{ "<leader>hf", "<cmd>Heph search<cr>", desc = "heph: search" },
			{ "<leader>hd", "<cmd>Heph done<cr>", desc = "heph: mark task done" },
			{ "<leader>hp", "<cmd>Heph promote<cr>", desc = "heph: promote context item" },
		},
		config = function()
			-- keymaps handled by lazy `keys` above
			require("heph").setup({ keymaps = false })
		end,
	},
}

-- hephaestus.nvim — personal context manager (knowledge base + tasks), an
-- obsidian.nvim replacement. Installed straight from its forge repo (the plugin
-- is at the repo root, so lazy loads it from a bare git URL).
--
-- Update the plugin:   :Lazy update
-- Rebuild the daemon:
--   cargo install --locked \
--     --git ssh://forgejo@forge.ops.eblu.me:2222/eblume/hephaestus.git \
--     --branch feature/v1-prototype heph hephd
--   heph daemon restart
-- (see the hephaestus repo's docs/how-to/install-heph.md)
--
-- Connect-only: setup() talks to a hephd you run as a service (`heph daemon
-- start`); it never spawns one. Lazy-loaded on :Heph and the <leader>h maps, so
-- it costs nothing until you use it.
return {
	{
		url = "ssh://forgejo@forge.ops.eblu.me:2222/eblume/hephaestus.nvim.git",
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

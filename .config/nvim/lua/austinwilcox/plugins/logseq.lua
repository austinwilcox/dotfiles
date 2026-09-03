return {
	-- "Conor-McLeod/logseq-mode.nvim",
	dir = "/home/austin/Software/logseq-mode.nvim", -- If local
	dependencies = {
		"stevearc/conform.nvim", -- Optional, for formatting
		"folke/snacks.nvim", -- Optional, for grep picker
	},
	opts = {
		logseq_dir = "~/bujo", -- Path to your graph
	},
	config = function(_, opts)
		require("logseq_mode").setup(opts)
	end,
}

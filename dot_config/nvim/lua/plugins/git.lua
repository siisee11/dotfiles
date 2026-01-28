return {
	{
		"NeogitOrg/neogit",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",         -- required
			"sindrets/diffview.nvim",        -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen" },
		keys = {
			{ "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
		},
	},
}

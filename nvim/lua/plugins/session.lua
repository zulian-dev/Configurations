return {
	{
		"rmagatti/auto-session",
		enabled = false,
		lazy = false,
		config = function()
			require("auto-session").setup({
				suppressed_dirs = {
					"~/",
					"~/Projects",
					"~/Downloads",
					"~/Documents",
					"/",
				},
			})
		end,
	},
}

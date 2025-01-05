return {
	{
		"rmagatti/auto-session",
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

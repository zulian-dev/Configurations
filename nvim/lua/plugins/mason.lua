return {
	{
		--"williamboman/mason.nvim",/
		"mason-org/mason.nvim",
		lazy = false,
		config = function()
			local mason = require("mason")
			mason.setup({
				ensure_installed = require("language").mason.setup(),
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			-- require("config.utils").notify.info("MASON TOOLS", "Setup")
			require("mason-tool-installer").setup({
				ensure_installed = require("language").mason.setup(),
			})
		end,
	},
}

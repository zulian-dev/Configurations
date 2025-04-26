local security = {}

-- TODO: Add this config on each language
local enable_snyk_languages = {
	"go",
	"java",
	"javascript",
	"elixir",
	"php",
	"python",
}

local enable_solar_languages = {
	"php",
	"python",
	"html",
	"go",
	"javascript",
	"java",
	"json",
	"elixir",
}

--------------------------------------------------------------------------------
-- Plugins ---------------------------------------------------------------------
--------------------------------------------------------------------------------

security.plugins = {
	{
		"schrieveslaach/sonarlint.nvim",
		url = "https://gitlab.com/schrieveslaach/sonarlint.nvim",
		lazy = true,
		dependencies = {
			"mfussenegger/nvim-jdtls",
		},
		-- ft = enable_solar_languages,
	},
}

--------------------------------------------------------------------------------
-- Mason -----------------------------------------------------------------------
--------------------------------------------------------------------------------

security.mason = {
	"snyk_ls",
	"sonarlint-language-server",
}

--------------------------------------------------------------------------------
-- LSP -------------------------------------------------------------------------
--------------------------------------------------------------------------------

security.lsp = function(lspconfig, capabilities, on_attach)
	-- https://app.snyk.io/account/
	lspconfig.snyk_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = enable_snyk_languages,
		cmd = { vim.fn.stdpath("data") .. "/mason/bin/snyk-ls" },
		root_dir = function(name)
			return lspconfig.util.find_git_ancestor(name) or vim.loop.os_homedir()
		end,
		init_options = {
			activateSnykCode = "true",
		},
		init_options = {
			["token"] = snyk_token,
			["authenticationMethod"] = "token",
			["activateSnykIac"] = "false",
		},
	})
end

-- security.tools = {
-- 	enable_sonarlint_analyzer = function(analyzer)
-- 		require("sonarlint").setup({
-- 			server = {
-- 				cmd = {
-- 					"sonarlint-language-server",
-- 					"-stdio",
-- 					"-analyzers",
-- 					analyzer,
-- 				},
-- 			},
-- 		})
-- 	end,
-- }

return security

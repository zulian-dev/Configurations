local security = {}

-- TODO: Add this config on each language
local enable_snyk_languages = {
	"go",
	-- "java",
	"javascript",
	"typescript",
	-- "elixir",
	"php",
	"python",
}
--
-- local enable_solar_languages = {
--   "php",
--   "python",
--   "html",
--   "go",
--   "javascript",
--   "java",
--   "json",
--   "elixir",
-- }

--------------------------------------------------------------------------------
-- Plugins ---------------------------------------------------------------------
--------------------------------------------------------------------------------

security.plugins = {
	{
		"schrieveslaach/sonarlint.nvim",
		url = "https://gitlab.com/schrieveslaach/sonarlint.nvim",
		enabled = false,
		lazy = true,
		dependencies = {
			"mfussenegger/nvim-jdtls",
		},
		-- ft = enable_solar_languages,
	},
	{
		-- 1Password integration
		-- Example: require("op").get_secret("Snyk", "Token")
		"mrjones2014/op.nvim",
		build = "make install",
	},
}

--------------------------------------------------------------------------------
-- Mason -----------------------------------------------------------------------
--------------------------------------------------------------------------------

security.mason = {
	"snyk_ls",
	--  "sonarlint-language-server",
}

--------------------------------------------------------------------------------
-- LSP -------------------------------------------------------------------------
--------------------------------------------------------------------------------

security.lsp = function(lspconfig, capabilities, on_attach)
	-- https://app.snyk.io/account/
	local snyk_token = require("op").get_secret("Snyk", "Token")
	lspconfig.snyk_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = enable_snyk_languages,
		cmd = { vim.fn.stdpath("data") .. "/mason/bin/snyk-ls" },
		root_dir = function(name)
			return lspconfig.util.find_git_ancestor(name) or lspconfig.util.path.dirname(name)
		end,
		-- https://github.com/snyk/snyk-ls
		init_options = {
			-- The name of the IDE or editor the LS is running in
			integrationName = "nvim",
			-- Specifies the authentication method to use: "token" for Snyk API token or "oauth" for Snyk OAuth flow. Default is token.
			authenticationMethod = "token",
			--The Snyk token, e.g.: snyk config get api or a token from authentication flow
			token = snyk_token,
			-- Enables Infrastructure as Code - defaults to true
			activateSnykIac = "false",
			-- Enables Snyk Code, if enabled for your organization - defaults to false, deprecated in favor of specific Snyk Code analysis types
			activateSnykCode = "true",
			-- Enables Snyk Code Security reporting
			activateSnykCodeSecurity = "true",
			-- Enable Snyk Code Quality issue reporting (Beta, only in IDEs and LS)
			activateSnykCodeQuality = "true",
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

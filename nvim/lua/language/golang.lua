local golang = {}

--------------------------------------------------------------------------------
--- Filetypes -----------------------------------------------------------------
--------------------------------------------------------------------------------

golang.filetypes = {
	"go",
	"gomod",
	"gowork",
	"gosum",
}

--------------------------------------------------------------------------------
--- Plugins --------------------------------------------------------------------
--------------------------------------------------------------------------------

golang.plugins = {
	{ "leoluz/nvim-dap-go" }, -- debugging,
}

--------------------------------------------------------------------------------
-- Mason -----------------------------------------------------------------------
--------------------------------------------------------------------------------

golang.mason = {
	-- LSP
	"gopls",

	-- Formatters
	"goimports",
	"gofumpt",

	-- Lint
	"staticcheck",

	-- code_actions
	"gomodifytags",
	"impl",

	-- dap
	"delve",
}

--------------------------------------------------------------------------------
-- LSP -------------------------------------------------------------------------
--------------------------------------------------------------------------------

golang.lsp = function(lspconfig, capabilities, on_attach)
	lspconfig.gopls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "go" }, --golang.filetypes,
	})

  -- require("language.security").tools.enable_sonarlint_analyzer(
  --   vim.fn.expand("$MASON/share/sonarlint-analyzers/sonargo.jar")
  -- )
end

--------------------------------------------------------------------------------
--- Debugging ------------------------------------------------------------------
--------------------------------------------------------------------------------

golang.debugging = function(dap)
	require("dap-go").setup()
end

--------------------------------------------------------------------------------
-- Null LS ---------------------------------------------------------------------
--------------------------------------------------------------------------------

golang.null_ls = function(null_ls, formatting, diagnostics, completion, code_actions, hover)
	return {
		formatting.gofmt,
		formatting.goimports,
		formatting.gofumpt,

		diagnostics.staticcheck,

		code_actions.gomodifytags,
		code_actions.impl,
	}
end

return golang

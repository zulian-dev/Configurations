local golang = {}

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
    filetypes = { "go" },
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
    formatting.gofmt,        -- a
    formatting.goimports,    -- b
    formatting.gofumpt,      -- c

    diagnostics.staticcheck, -- d

    code_actions.gomodifytags, -- end
    code_actions.impl,
  }
end

return golang

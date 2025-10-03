local html = {}
-- Install script
-- https://github.com/hrsh7th/vscode-langservers-extracted
-- npm i -g vscode-langservers-extracted

--------------------------------------------------------------------------------
--- Filetypes -----------------------------------------------------------------
--------------------------------------------------------------------------------

html.filetypes = {
  "html",
  "heex",
  "php",
  "elixir", "eelixir", "heex"
}

--------------------------------------------------------------------------------
-- Mason -----------------------------------------------------------------------
--------------------------------------------------------------------------------

html.mason = {
  "html",
}

--------------------------------------------------------------------------------
-- LSP -------------------------------------------------------------------------
--------------------------------------------------------------------------------

html.lsp = function(lspconfig, capabilities, on_attach)
  lspconfig.emmet_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = html.filetypes,
  })

  lspconfig.html.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = html.filetypes,
  })
end

return html

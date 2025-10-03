local sql = {}

sql.filetypes = { "sql" }

sql.mason = {
  -- "sqls",
  "sqlfmt",
}

-- sql.lsp = function(lspconfig, capabilities, on_attach)
-- 	lspconfig.sqls.setup({
-- 		capabilities = capabilities,
-- 		on_attach = on_attach,
-- 		filetypes = sql.filetypes,
-- 	})
-- end

sql.null_ls = function(null_ls, formatting, diagnostics, completion, code_actions, hover)
  return {
    formatting.sqlfmt,
  }
end

return sql

local lualang = {}

--------------------------------------------------------------------------------
-- Mason -----------------------------------------------------------------------
--------------------------------------------------------------------------------

lualang.mason = {
  -- "stylua",
  "lua_ls",
}

--------------------------------------------------------------------------------
-- LSP -------------------------------------------------------------------------
--------------------------------------------------------------------------------

lualang.lsp = function(lspconfig, capabilities, on_attach)
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "lua" },
    settings = {
      Lua = {
        format = {
          enable = true,
          -- defaultConfig = {
          -- 	-- indent_style = "tab",
          -- 	indent_style = "space",
          -- 	indent_size = "4",
          -- },
        },
      },
    },
  })
end

--------------------------------------------------------------------------------
-- Null LS ---------------------------------------------------------------------
--------------------------------------------------------------------------------

-- lualang.null_ls = function(null_ls, formatting, diagnostics, completion, code_actions, hover)
-- 	return {
-- 		-- formatting.stylua,
-- 	}
-- end

return lualang

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

lualang.native_lsp = function(lsp)
	return lsp.enable({
		-- Command and arguments to start the server.
		cmd = { "$mason/bin/lua-language-server" },

		-- Filetypes to automatically attach to.
		filetypes = { "lua" },

		-- Sets the "root directory" to the parent directory of the file in the
		-- current buffer that contains either a ".luarc.json" or a
		-- ".luarc.jsonc" file. Files that share a root directory will reuse
		-- the connection to the same LSP server.
		-- Nested lists indicate equal priority, see |vim.lsp.Config|.
		root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },

		-- Specific settings to send to the server. The schema for this is
		-- defined by the server. For example the schema for lua-language-server
		-- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
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

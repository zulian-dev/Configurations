-- lsp
--------------------------------------------------------------------------------
-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.

-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.

-- vim.lsp.enable("lua_ls")
require("language.lua").native_lsp(vim.lsp)
require("language.elixir").native_lsp(vim.lsp)
-- require("language.markdown").native_lsp(vim.lsp)

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
			vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			vim.keymap.set("i", "<C-Space>", function()
				vim.lsp.completion.get()
			end)
		end
	end,
})

-- Diagnostics
vim.diagnostic.config({
	-- Use the default configuration
	virtual_lines = true,

	-- Alternatively, customize specific options
	virtual_lines = {
		-- Only show virtual line diagnostics for the current cursor line
		current_line = true,
	},
})
--
-- vim.diagnostic.config({
-- 	-- Show diagnostic message using virtual text.
-- 	virtual_text = false,
-- 	-- Show a sign next to the line with a diagnostic.
-- 	signs = true,
-- 	-- Update diagnostics while editing in insert mode.
-- 	update_in_insert = true,
-- 	-- Use an underline to show a diagnostic location.
-- 	underline = true,
-- 	-- Order diagnostics by severity.
-- 	severity_sort = false,
-- 	-- Show diagnostic messages in floating windows.
-- 	float = {
-- 		border = "rounded",
-- 		source = true,
-- 		-- source = "always",
-- 		-- header = '',
-- 		-- prefix = '',
-- 		-- Credit: https://github.com/jessarcher/dotfiles/blob/master/nvim/lua/user/plugins/lspconfig.lua
-- 		format = function(diagnostic)
-- 			if diagnostic.user_data ~= nil and diagnostic.user_data.lsp.code ~= nil then
-- 				return string.format("%s: %s", diagnostic.user_data.lsp.code, diagnostic.message)
-- 			end
-- 			return diagnostic.message
-- 		end,
-- 	},
-- })
--
-- -- to show full diagnostic message on hover line diagnostic
-- -- You will likely want to reduce updatetime which affects CursorHold
-- -- note: this setting is global and should be set only once
-- vim.o.updatetime = 250
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
-- 	group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
-- 	callback = function()
-- 		if vim.fn.mode() == "n" then
-- 			vim.diagnostic.open_float(nil, { focus = false })
-- 		end
-- 	end,
-- })

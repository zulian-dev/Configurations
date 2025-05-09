return {
	name = "Bash",
	filetypes = { "shell", "bash" },
	fileExts = { "sh" },

	mason = {
		"bashls",
		"shfmt",
		"shellcheck",
	},

	lsp = function(lspconfig, capabilities, on_attach)
		lspconfig.bashls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = { vim.fn.expand("$MASON/bin/bash-language-server"), "start" },
			filetypes = { "sh" },
		})
		lspconfig.shellcheck.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "sh" },
		})
	end,

	null_ls = function(null_ls, formatting, diagnostics, completion, code_actions, hover)
		return {
			formatting.shfmt,
		}
	end,
}


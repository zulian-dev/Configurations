return {
	"nvimtools/none-ls.nvim",
	opts = function(_, opts)
		local nls = require("null-ls")
		opts.root_dir = opts.root_dir
			or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")

		opts.sources = vim.list_extend(
			opts.sources or {},
			nls.builtins.formatting.prettier,
			table.unpack(
				require("language").null_ls.setup(
					nls,
					nls.builtins.formatting,
					nls.builtins.diagnostics,
					nls.builtins.completion,
					nls.builtins.code_actions,
					nls.builtins.hover
				)
			)
		)
	end,
}

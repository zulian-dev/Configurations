return {
	"nvimtools/none-ls.nvim",
	event = "LazyFile",
	dependencies = { "mason.nvim" },
	init = function()
		LazyVim.on_very_lazy(function()
			-- register the formatter with LazyVim
			LazyVim.format.register({
				name = "none-ls.nvim",
				priority = 200, -- set higher than conform, the builtin formatter
				primary = true,
				format = function(buf)
					return LazyVim.lsp.format({
						bufnr = buf,
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
				sources = function(buf)
					local ret = require("null-ls.sources").get_available(vim.bo[buf].filetype, "NULL_LS_FORMATTING")
						or {}
					return vim.tbl_map(function(source)
						return source.name
					end, ret)
				end,
			})
		end)
	end,
	opts = function(_, opts)
		local nls = require("null-ls")
		opts.root_dir = opts.root_dir
			or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
		opts.sources = vim.list_extend(opts.sources or {}, {
			nls.builtins.formatting.fish_indent,
			nls.builtins.diagnostics.fish,
			nls.builtins.formatting.stylua,
			nls.builtins.formatting.shfmt,
		})
	end,
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics
		local code_actions = null_ls.builtins.code_actions
		local completion = null_ls.builtins.completion
		local hover = null_ls.builtins.hover

		local lang_nulls =
			require("language").null_ls.setup(null_ls, formatting, diagnostics, completion, code_actions, hover)

		local sources = {
			-- Git
			code_actions.gitsigns,
		}

		for _, lang in ipairs(lang_nulls) do
			for _, source in ipairs(lang) do
				table.insert(sources, source)
			end
		end

		require("config.utils").notify.info("Null LS", sources)

		null_ls.setup({
			sources = sources,
		})

		vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
	end,
}


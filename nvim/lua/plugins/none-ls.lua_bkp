local banned_plugins = {
	"stylua",
}

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
		-- opts.sources = vim.list_extend(opts.sources or {}, {
		-- nls.builtins.formatting.fish_indent,
		-- nls.builtins.diagnostics.fish,
		-- nls.builtins.formatting.stylua,
		-- nls.builtins.formatting.shfmt,
		-- })
	end,
	config = function(config, opts)
		require("config.utils").notify.info("null-ls.nvim", opts.sources)

		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics
		local code_actions = null_ls.builtins.code_actions
		local completion = null_ls.builtins.completion
		local hover = null_ls.builtins.hover

		local lang_nulls =
			require("language").null_ls.setup(null_ls, formatting, diagnostics, completion, code_actions, hover)

		local lazy_sources = opts.sources
		local sources = {}

		local function add_source(acc_sources, new_source)
			if type(new_source) == "table" then
				for _, source in ipairs(new_source) do
					acc_sources = add_source(acc_sources, source)
				end
			elseif new_source.name then
				if not vim.tbl_contains(banned_plugins, new_source.name) then
					table.insert(acc_sources, new_source)
				end
			else
				require("config.utils").notify.warn("null-ls.nvim", "Invalid source: " .. vim.inspect(new_source))
			end

			return acc_sources
		end

		-- Git
		sources = add_source(sources, code_actions.gitsigns)

		-- lazy sources
		sources = add_source(sources, lazy_sources)

		-- Lang sources
		sources = add_source(sources, lang_nulls)

		null_ls.setup({ sources = sources })
	end,
}

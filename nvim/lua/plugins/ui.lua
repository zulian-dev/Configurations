vim.api.nvim_create_user_command("UIClean", function(opts)
	local codewindow = require("codewindow")
	-- local lualine = require('lualine')

	vim.cmd(":Neotree filesystem close left")
	codewindow.close_minimap()
	-- lualine.hide({
	--   place = {'statusline', 'tabline', 'winbar'}, -- The segment this change applies to.
	--   unhide = false,  -- whether to re-enable lualine again/
	-- })
end, { nargs = "?" })

return {
	-- Icon
	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
				[".rest"] = { glyph = "󱂛", hl = "MiniIconsPurple" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	-- Highlith //! //? ...
	{
		"jbgutierrez/vim-better-comments",
	},
	-- Indentation rainbow
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = false,
		main = "ibl",
		opts = function(_, opts)
			-- Other blankline configuration here
			return require("indent-rainbowline").make_opts(opts, {
				color_transparency = 0.15,
				colors = {
					0x9400D3, -- Violeta escuro
					0x4B0082, -- Índigo
					0x0000FF, -- Azul
					0x00FF00, -- Verde
					0xFFFF00, -- Amarelo
					0xFF7F00, -- Laranja
					0xFF0000, -- Vermelho
				},
			})
		end,
		dependencies = {
			"TheGLander/indent-rainbowline.nvim",
		},
	},
	-- {
	--   "lukas-reineke/indent-blankline.nvim",
	--   dependencies = {
	--     "TheGLander/indent-rainbowline.nvim",
	--   },
	--   event = "LazyFile",
	--   main = "ibl",
	--   opts = function(_, opts)
	--     Snacks.toggle({
	--       name = "Indention Guides",
	--       get = function()
	--         return require("ibl.config").get_config(0).enabled
	--       end,
	--       set = function(state)
	--         require("ibl").setup_buffer(0, { enabled = state })
	--       end,
	--     }):map("<leader>ug")

	--     local highlight = {
	--       "RainbowRed",
	--       "RainbowYellow",
	--       "RainbowBlue",
	--       "RainbowOrange",
	--       "RainbowGreen",
	--       "RainbowViolet",
	--       "RainbowCyan",
	--     }
	--     local hooks = require("ibl.hooks")
	--     -- create the highlight groups in the highlight setup hook, so they are reset
	--     -- every time the colorscheme changes
	--     hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	--       vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
	--       vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
	--       vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
	--       vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
	--       vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
	--       vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
	--       vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
	--     end)

	--     vim.g.rainbow_delimiters = { highlight = highlight }
	--     require("ibl").setup({ scope = { highlight = highlight } })

	--     hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

	--     require("indent-rainbowline").make_opts(opts, {
	--       -- How transparent should the rainbow colors be. 1 is completely opaque, 0 is invisible. 0.07 by default
	--       color_transparency = 0.15,
	--       -- The 24-bit colors to mix with the background. Specified in hex.
	--       -- { 0xffff40, 0x79ff79, 0xff79ff, 0x4fecec, } by default
	--       colors = {
	--         0xff0000, -- Vermelho
	--         0xff7f00, -- Laranja
	--         0xffff00, -- Amarelo
	--         0x00ff00, -- Verde
	--         0x0000ff, -- Azul
	--         0x4b0082, -- Índigo
	--         0x9400d3, -- Violeta
	--       },
	--     })

	--     return {
	--       indent = {
	--         char = "│",
	--         tab_char = "│",
	--       },
	--       scope = {
	--         show_start = true,
	--         show_end = true,
	--         highlight = highlight,
	--       },
	--       exclude = {
	--         filetypes = {
	--           "Trouble",
	--           "alpha",
	--           "dashboard",
	--           "help",
	--           "lazy",
	--           "mason",
	--           "neo-tree",
	--           "notify",
	--           "snacks_dashboard",
	--           "snacks_notif",
	--           "snacks_terminal",
	--           "snacks_win",
	--           "toggleterm",
	--           "trouble",
	--         },
	--       },
	--     }
	--   end,
	-- },
	{
		"tomasky/bookmarks.nvim",
		enabled = false,
		-- after = "telescope.nvim",
		event = "VimEnter",
		config = function()
			require("bookmarks").setup({
				-- sign_priority = 8,  --set bookmark sign priority to cover other sign
				save_file = vim.fn.expand("$HOME/.bookmarks"), -- bookmarks save file path
				keywords = {
					["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
					["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
					["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
					["@n"] = " ", -- mark annotation startswith @n ,signs this icon as `Note`
				},
				on_attach = function(bufnr)
					local bm = require("bookmarks")
					local map = vim.keymap.set
					-- map("n", "mm", bm.bookmark_toggle) -- add or remove bookmark at current line
					-- map("n", "mi", bm.bookmark_ann) -- add or edit mark annotation at current line
					-- map("n", "mc", bm.bookmark_clean) -- clean all marks in local buffer
					-- map("n", "mn", bm.bookmark_next) -- jump to next mark in local buffer
					-- map("n", "mp", bm.bookmark_prev) -- jump to previous mark in local buffer
					-- map("n", "ml", bm.bookmark_list) -- show marked file list in quickfix window
					-- map("n", "mx", bm.bookmark_clear_all) -- removes all bookmarks
					map("n", "mm", bm.bookmark_toggle, { desc = "add or remove bookmark at current line" })
					map("n", "mi", bm.bookmark_ann, { desc = "add or edit mark annotation at current line" })
					map("n", "mc", bm.bookmark_clean, { desc = "clean all marks in local buffer" })
					map("n", "mn", bm.bookmark_next, { desc = "jump to next mark in local buffer" })
					map("n", "mp", bm.bookmark_prev, { desc = "jump to previous mark in local buffer" })
					map("n", "ml", bm.bookmark_list, { desc = "show marked file list in quickfix window" })
					map("n", "mx", bm.bookmark_clear_all, { desc = "removes all bookmarks" })
				end,
			})
		end,
	},
	-- {
	--   "arakkkkk/switchpanel.nvim",
	-- config = function()
	-- 	require("switchpanel").setup({})
	-- end,
	-- }
	--

	-- Minimap
	{
		"gorbit99/codewindow.nvim",
		enabled = true,
		config = function()
			local codewindow = require("codewindow")
			codewindow.setup({
				auto_enable = true, -- Automatically open the minimap when entering a (non-excluded) buffer (accepts a table of filetypes)
				active_in_terminals = false, -- Should the minimap activate for terminal buffers
				max_minimap_height = nil, -- The maximum height the minimap can take (including borders)
				max_lines = nil, -- If auto_enable is true, don't open the minimap for buffers which have more than this many lines.
				minimap_width = 10, -- The width of the text part of the minimap
				use_lsp = true, -- Use the builtin LSP to show errors and warnings
				use_treesitter = true, -- Use nvim-treesitter to highlight the code
				use_git = true, -- Show small dots to indicate git additions and deletions
				z_index = 1, -- The z-index the floating window will be on
				width_multiplier = 1, -- How many characters one dot represents
				show_cursor = false, -- Show the cursor position in the minimap
				window_border = "none", -- The border style of the floating window (accepts all usual options)
				relative = "win", -- What will be the minimap be placed relative to, "win": the current window, "editor": the entire editor
				events = { -- Events that update the code window
					"TextChanged",
					"InsertLeave",
					"DiagnosticChanged",
					"FileWritePost",
				},
				exclude_filetypes = { -- Choose certain filetypes to not show minimap on
					"help",
					"oil",
					"octo",
				},
			})
			codewindow.apply_default_keybinds()
		end,
	},
}

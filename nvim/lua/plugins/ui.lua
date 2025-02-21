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
  -- Indentation rainbown
  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = {
      "TheGLander/indent-rainbowline.nvim",
    },
    event = "LazyFile",
    main = "ibl",
    opts = function(_, opts)
      Snacks.toggle({
        name = "Indention Guides",
        get = function()
          return require("ibl.config").get_config(0).enabled
        end,
        set = function(state)
          require("ibl").setup_buffer(0, { enabled = state })
        end,
      }):map("<leader>ug")

      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require("ibl.hooks")
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup({ scope = { highlight = highlight } })

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

      require("indent-rainbowline").make_opts(opts, {
        -- How transparent should the rainbow colors be. 1 is completely opaque, 0 is invisible. 0.07 by default
        color_transparency = 0.15,
        -- The 24-bit colors to mix with the background. Specified in hex.
        -- { 0xffff40, 0x79ff79, 0xff79ff, 0x4fecec, } by default
        colors = {
          0xff0000, -- Vermelho
          0xff7f00, -- Laranja
          0xffff00, -- Amarelo
          0x00ff00, -- Verde
          0x0000ff, -- Azul
          0x4b0082, -- Índigo
          0x9400d3, -- Violeta
        },
      })

      return {
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = {
          show_start = true,
          show_end = true,
          highlight = highlight,
        },
        exclude = {
          filetypes = {
            "Trouble",
            "alpha",
            "dashboard",
            "help",
            "lazy",
            "mason",
            "neo-tree",
            "notify",
            "snacks_dashboard",
            "snacks_notif",
            "snacks_terminal",
            "snacks_win",
            "toggleterm",
            "trouble",
          },
        },
      }
    end,
  },
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
}

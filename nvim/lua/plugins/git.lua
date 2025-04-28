vim.api.nvim_create_user_command("Guitar", function(opts)
  local job = require("plenary.async")

  print("🎸")
  vim.cmd(":Git add %")
  vim.cmd(':Git commit -m "' .. opts.args .. '"')

  job.run(function()
    vim.cmd(":Git push")
    print("🎼🎵🎶🎶")
  end, function() end)
end, { nargs = "?" })

return {
  --Git shortcuts :Git
  { "tpope/vim-fugitive" },

  --Git signs in editor
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local gitsigns = require("gitsigns")

      vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, {})

      -- For Dracula theme
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })

      gitsigns.setup({
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          -- delete = { text = "_" },
          delete = { text = "╳" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signs_staged = {
          add = { text = "┃" },
          change = { text = "┃" },
          -- delete = { text = "_" },
          delete = { text = "╳" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signs_staged_enable = true,
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = false,
        -- current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        -- current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
        current_line_blame_formatter = " -  <author>, <author_time:%R> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
      })
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
}

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

      gitsigns.setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          -- delete = { text = "󰍵" },
          delete = { text = "╳" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "│" },
        },

        current_line_blame = true,
      })
    end,
  },

  -- nvim v0.8.0
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
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  }
}

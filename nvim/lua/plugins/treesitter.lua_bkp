return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      ensure_installed = { "lua", "elixir", "heex", "eex", "javascript", "html" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      ignore_install = {},
    })
  end,
}

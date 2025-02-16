local catppuccin_setup = function()
  require("catppuccin").setup()
end

local tokyonight_setup = function()
  require("tokyonight").setup()
end

local after = [[
  require("catppuccin").setup()
]]

local afLightTheme = [[
  vim.cmd("set background=light")
]]

return {

  { "maxmx03/fluoromachine.nvim",   name = "fluoromachine", colorscheme = "fluoromachine" },
  { "glitchcandy/glitchcandy-nvim", name = "glitchcandy",   colorscheme = "glitchcandy" },
  -- {"liminalminds/icecream.nvim", name = "icecream",                               colorscheme = "icecream" },
  { "Gako358/borealis.nvim",        name = "borealis",      colorscheme = "borealis" },
  { "AmberLehmann/candyland.nvim",  name = "candyland",     colorscheme = "candyland" },
  { "hachy/eva01.vim",              name = "eva01",         colorscheme = "eva01" },
  { "hachy/eva01.vim",              name = "eva01-LCL",     colorscheme = "eva01-LCL" },

  -- Aurora
  { "ray-x/aurora",                 name = "Aurora",        colorscheme = "aurora" },

  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "Catppuccin - Frappe",
    colorscheme = "catppuccin-frappe",
    after = after,
  },
  {
    "catppuccin/nvim",
    name = "Catppuccin - Macchiato",
    colorscheme = "catppuccin-macchiato",
    after = after,
  },
  {
    "catppuccin/nvim",
    name = "Catppuccin - Mocha",
    colorscheme = "catppuccin-mocha",
    after = after,
  },

  -- Onedarkpro
  { "olimorris/onedarkpro.nvim",        name = "OnedarkPro",           colorscheme = "onedark" },
  { "olimorris/onedarkpro.nvim",        name = "OnedarkPro - Vivid",   colorscheme = "onedark_vivid" },
  { "olimorris/onedarkpro.nvim",        name = "OnedarkPro - Dark",    colorscheme = "onedark_dark" },

  -- Nightfox
  { "EdenEast/nightfox.nvim",           name = "Nightfox - Nightfox",  colorscheme = "nightfox" },
  { "EdenEast/nightfox.nvim",           name = "Nightfox - Carbonfox", colorscheme = "carbonfox" },
  { "EdenEast/nightfox.nvim",           name = "Nightfox - Duskfox",   colorscheme = "duskfox" },
  { "EdenEast/nightfox.nvim",           name = "Nightfox - Nordfox",   colorscheme = "nordfox" },
  { "EdenEast/nightfox.nvim",           name = "Nightfox - Terafox",   colorscheme = "terafox" },

  -- Rose Pine
  { "rose-pine/neovim",                 name = "Rose Pine - Main",     colorscheme = "rose-pine-main" },
  { "rose-pine/neovim",                 name = "Rose Pine - Moon",     colorscheme = "rose-pine-moon" },

  -- Night-owl
  { "oxfist/night-owl.nvim",            name = "Night owl",            colorscheme = "night-owl" },

  -- Midnight
  { "dasupradyumna/midnight.nvim",      name = "Midnight",             colorscheme = "midnight" },

  -- Palenightfall
  { "JoosepAlviste/palenightfall.nvim", name = "Palenightfall",        colorscheme = "palenightfall" },

  -- Nightfly
  { "bluz71/vim-nightfly-colors",       name = "Nightfly",             colorscheme = "nightfly" },

  -- Dracula
  { "dracula/vim",                      name = "Dracula vim",          colorscheme = "dracula" },

  -- Nordc
  { "AlexvZyl/nordic.nvim",             name = "Nordic",               colorscheme = "nordic" },

  -- Rigel
  { "Rigellute/rigel",                  name = "Rigel",                colorscheme = "rigel" },

  -- Snazzy
  { "connorholyday/vim-snazzy",         name = "Snazzy",               colorscheme = "snazzy" },

  -- hardhacker
  -- { "hardhackerlabs/theme-vim", name = "Hardhacker", colorscheme = "hardhacker" },

  -- TokyoDark
  { "tiagovla/tokyodark.nvim",          name = "Tokyo Dark",           colorscheme = "tokyodark" },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    name = "Tokyonight - Night",
    colorscheme = "tokyonight-night",
    config = tokyonight_setup,
  },
  {
    "folke/tokyonight.nvim",
    name = "Tokyonight - Storm",
    colorscheme = "tokyonight-storm",
    config = tokyonight_setup,
  },
  {
    "folke/tokyonight.nvim",
    name = "Tokyonight - Moon",
    colorscheme = "tokyonight-moon",
    config = tokyonight_setup,
  },

  -- Kanagawa
  { "rebelot/kanagawa.nvim",            name = "Kanagawa - Wave",     colorscheme = "kanagawa-wave" },
  { "rebelot/kanagawa.nvim",            name = "Kanagawa - Dragon",   colorscheme = "kanagawa-dragon" },

  -- monokai
  { "crusoexia/vim-monokai",            name = "Monokai",             colorscheme = "monokai" },

  -- vim-one
  { "rakr/vim-one",                     name = "One",                 colorscheme = "one" },

  -- monokai pro
  { "loctvl842/monokai-pro.nvim",       name = "Monokai - Pro",       colorscheme = "monokai-pro" },
  { "loctvl842/monokai-pro.nvim",       name = "Monokai - Classic",   colorscheme = "monokai-pro-classic" },
  { "loctvl842/monokai-pro.nvim",       name = "Monokai - Default",   colorscheme = "monokai-pro-default" },
  { "loctvl842/monokai-pro.nvim",       name = "Monokai - Machine",   colorscheme = "monokai-pro-machine" },
  { "loctvl842/monokai-pro.nvim",       name = "Monokai - Octagon",   colorscheme = "monokai-pro-octagon" },
  { "loctvl842/monokai-pro.nvim",       name = "Monokai - Ristretto", colorscheme = "monokai-pro-ristretto" },
  { "loctvl842/monokai-pro.nvim",       name = "Monokai - Spectrum",  colorscheme = "monokai-pro-spectrum" },

  -- space-vim-dark
  { "liuchengxu/space-vim-dark",        name = "Space Vim - Dark",    colorscheme = "space-vim-dark" },

  -- iceberg
  { "cocopon/iceberg.vim",              name = "Iceberg",             colorscheme = "iceberg" },

  -- gruvbox
  { "morhetz/gruvbox",                  name = "Gruvbox dark",        colorscheme = "gruvbox" },

  -- shades_of_purple
  { "Rigellute/shades-of-purple.vim",   name = "Shades of purple",    colorscheme = "shades_of_purple" },

  --Synthwave84
  { "artanikin/vim-synthwave84",        name = "Synthwave84",         colorscheme = "synthwave84" },

  -- my test
  { "zulian-dev/theme-sedona.vim",      name = "Sedona",              colorscheme = "sedona" },
  { "zulian-dev/theme-neon-vommit.vim", name = "Neon Vommit",         colorscheme = "neon-vommit" },

  -- Oxocarbon
  { "nyoom-engineering/oxocarbon.nvim", name = "Oxocarbon",           colorscheme = "oxocarbon" },

  -- SpaceDuck
  { "pineapplegiant/spaceduck",         name = "Spaceduck",           colorscheme = "spaceduck" },

  -- Github
  { "projekt0n/github-nvim-theme",      name = "Github - dark",       colorscheme = "github_dark" },
  {
    "projekt0n/github-nvim-theme",
    name = "Github - dark colorblind",
    colorscheme = "github_dark_colorblind",
  },
  { "projekt0n/github-nvim-theme", name = "Github - dark default", colorscheme = "github_dark_default" },
  { "projekt0n/github-nvim-theme", name = "Github - dark dimmed",  colorscheme = "github_dark_dimmed" },
  {
    "projekt0n/github-nvim-theme",
    name = "Github - dark high contrast",
    colorscheme = "github_dark_high_contrast",
  },
  {
    "projekt0n/github-nvim-theme",
    name = "Github - dark tritanopia",
    colorscheme = "github_dark_tritanopia",
  },
  { "projekt0n/github-nvim-theme",   name = "Github - dimmed", colorscheme = "github_dimmed" },

  -- Melange
  { "savq/melange-nvim",             name = "Melange",         colorscheme = "melange" },

  -- Cyberdream
  { "scottmckendry/cyberdream.nvim", name = "Cyberdream",      colorscheme = "cyberdream" },

  -- Bluloco
  {
    "uloco/bluloco.nvim",
    name = "Bluloco",
    colorscheme = "bluloco",
    dependencies = { "rktjmp/lush.nvim" },
  },
  {
    "uloco/bluloco.nvim",
    name = "Bluloco - Dark",
    colorscheme = "bluloco-dark",
    dependencies = { "rktjmp/lush.nvim" },
  },

  -- Biscuit
  { "Biscuit-Theme/nvim", name = "Biscuit", colorscheme = "biscuit" },

  ------------------------
  {
    "NLKNguyen/papercolor-theme",
    name = "(LIGHT) Paper Color",
    colorscheme = "PaperColor",
    after = afLightTheme,
  },
  {
    "catppuccin/nvim",
    name = "(LIGHT) Catppuccin - Latte",
    colorscheme = "catppuccin-latte",
    after = afLightTheme,
    config = catppuccin_setup,
  },
  {
    "olimorris/onedarkpro.nvim",
    name = "(LIGHT) OnedarkPro - Onelight",
    colorscheme = "onelight",
    after = afLightTheme,
  },
  {
    "EdenEast/nightfox.nvim",
    name = "(LIGHT) Nightfox Dawnfox",
    colorscheme = "dawnfox",
    after = afLightTheme,
  },
  {
    "EdenEast/nightfox.nvim",
    name = "(LIGHT) Nightfox Dayfox",
    colorscheme = "dayfox",
    after = afLightTheme,
  },
  {
    "rose-pine/neovim",
    name = "(LIGHT) Rose Pine",
    colorscheme = "rose-pine",
    after = afLightTheme,
  },
  {
    "rose-pine/neovim",
    name = "(LIGHT) Rose Pine Dawn",
    colorscheme = "rose-pine-dawn",
    after = afLightTheme,
  },
  {
    "folke/tokyonight.nvim",
    name = "(LIGHT) Tokyonight day",
    colorscheme = "tokyonight-day",
    after = afLightTheme,
    config = tokyonight_setup,
  },
  {
    "rebelot/kanagawa.nvim",
    name = "(LIGHT) Kanagawa Lotus",
    colorscheme = "kanagawa-lotus",
    after = afLightTheme,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "(LIGHT) Github - Light",
    colorscheme = "github_light",
    after = afLightTheme,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "(LIGHT) Github - Light Colorblind",
    colorscheme = "github_light_colorblind",
    after = afLightTheme,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "(LIGHT) Github - Light Default",
    colorscheme = "github_light_default",
    after = afLightTheme,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "(LIGHT) Github - Light High contrast",
    colorscheme = "github_light_high_contrast",
    after = afLightTheme,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "(LIGHT) Github - Light Tritanopia",
    colorscheme = "github_light_tritanopia",
    after = afLightTheme,
  },
  {
    "uloco/bluloco.nvim",
    name = "(LIGHT) Bluloco - Light",
    colorscheme = "bluloco-light",
    after = afLightTheme,
    dependencies = { "rktjmp/lush.nvim" },
  },
}

local markdown = require("language.markdown")
local golang = require("language.golang")
local rust = require("language.rust")
local java = require("language.java")
local elixir = require("language.elixir")
local security = require("language.security")

local languages = {
  markdown,
  golang,
  rust,
  java,
  elixir,
  security,
}

local all_plugins = {}
local all_lsp = {}
local all_null_ls = {}
local all_options = {}

for _, lang in ipairs(languages) do
  if lang.plugins then
    table.insert(all_plugins, lang.plugins)
  end
  
  if lang.lsp then
    table.insert(all_lsp, lang.lsp)
  end
  
  if lang.null_ls then
    table.insert(all_null_ls, lang.null_ls)
  end
  
  if lang.options then
    table.insert(all_options, lang.options)
  end
end

plugins = {
  setup = function()
    local return_plugins = {}
    for _, lang in ipairs(all_plugins) do
      for _, plugin_to_install in ipairs(lang) do
        table.insert(return_plugins, plugin_to_install)
      end
    end
    return return_plugins
  end
} 

lsp = {
  setup = function(lspconfig, capabilities, on_attach)
    for _, lang in ipairs(all_lsp) do
      lang(lspconfig, capabilities, on_attach)
    end
  end
}

null_ls = {
  setup = function(null_ls)
    local return_null_ls = {}
    for _, lang in ipairs(all_null_ls) do
      for _, null_ls_plugin in ipairs(lang(null_ls)) do
        table.insert(return_null_ls, null_ls_plugin)
      end
    end
    return return_null_ls
  end
}

options = {
  setup = function()
    for _, lang in ipairs(all_options) do
      lang()
    end
  end
}

local M = {  
  options = options,
  lsp = lsp,
  null_ls = null_ls,
  plugins = plugins,
}

return M
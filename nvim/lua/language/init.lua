local notify = require("config.utils").notify
local nvimlang = os.getenv("NVIMLANG")

local loaded_languages = {}
local disponible_languages = {
  "markdown",
  "golang",
  "rust",
  "java",
  "elixir",
  "lua",
  "javascript",
  "gdscript",
  "clojure",
  "security",
  "php",
  "bash",
  "python",
  "html",
  "css",
  "sql",
  "zig",
  "txt",
}

local function load_module(lang)
  if vim.tbl_contains(disponible_languages, lang) then
    local module_name = "language." .. lang
    local success, language_module = pcall(require, module_name)
    if success then
      notify.info("Language Loader", "Loading language: " .. lang)
      table.insert(loaded_languages, language_module)
    else
      notify.error("Language Loader", "Failed to load language: " .. lang)
    end
  else
    notify.error("Language Loader", "Invalid language: " .. lang)
  end
end

-- Read enviroment NVIMLANG, and load each one
if nvimlang then
  local langs = vim.split(nvimlang, ",")
  for _, lang in ipairs(langs) do
    load_module(lang)
  end
  -- Load all disponible languages
else
  notify.info("Language Loader", "Loading all languages")
  for _, lang in ipairs(disponible_languages) do
    load_module(lang)
  end
end

-- Função auxiliar para coletar dados de um campo específico em todas as linguagens
local function collect_field(field)
  local result = {}
  for _, lang in ipairs(loaded_languages) do
    if lang[field] then
      if type(lang[field]) == "table" then
        vim.list_extend(result, lang[field])
      else
        table.insert(result, lang[field])
      end
    end
  end
  return result
end

-- Função auxiliar para executar funções de configuração de linguagens
local function execute_setup(field, ...)
  for _, lang in ipairs(loaded_languages) do
    if lang[field] then
      lang[field](...)
    end
  end
end

return {
  plugins = {
    setup = function()
      return collect_field("plugins")
    end,
  },

  lsp = {
    setup = function(lspconfig, capabilities, on_attach)
      execute_setup("lsp", lspconfig, capabilities, on_attach)
    end,
  },

  null_ls = {
    setup = function(null_ls, formatting, diagnostics, completion, code_actions, hover)
      local return_null_ls = {}
      for _, plugin in ipairs(collect_field("null_ls")) do
        vim.list_extend(
          return_null_ls,
          plugin(null_ls, formatting, diagnostics, completion, code_actions, hover)
        )
      end
      return return_null_ls
    end,
  },

  debugging = {
    setup = function(dap)
      execute_setup("debugging", dap)
    end,
  },

  options = {
    setup = function()
      execute_setup("options")
    end,
  },

  mason = {
    setup = function()
      return collect_field("mason")
    end,
  },

  asciiart = {
    setup = function()
      if nvimlang then
        return collect_field("asciiart")
      else
        return false
      end
    end,
  },
}

-- alias mdvim="export NVIMLANG='markdown' && /opt/homebrew/bin/nvim && unset NVIMLANG"
-- alias govim="export NVIMLANG='golang' && /opt/homebrew/bin/nvim && unset NVIMLANG"
-- alias rsvim="export NVIMLANG='rust' && /opt/homebrew/bin/nvim && unset NVIMLANG"
-- alias javim="export NVIMLANG='java' && /opt/homebrew/bin/nvim && unset NVIMLANG"
-- alias elvim="export NVIMLANG='elixir' && /opt/homebrew/bin/nvim && unset NVIMLANG"
-- alias luavim="export NVIMLANG='lua' && /opt/homebrew/bin/nvim && unset NVIMLANG"
-- alias jsvim="export NVIMLANG='javascript' && /opt/homebrew/bin/nvim && unset NVIMLANG"
-- alias gdvim="export NVIMLANG='gdscript' && /opt/homebrew/bin/nvim && unset NVIMLANG"
-- alias cljvim="export NVIMLANG='clojure' && /opt/homebrew/bin/nvim && unset NVIMLANG"
-- alias nvim="unset NVIMLANG && /opt/homebrew/bin/nvim"
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

if nvimlang then
  local langs = vim.split(nvimlang, ",")
  for _, lang in ipairs(langs) do
    notify.info("Language Loader", "Loading language: " .. lang)
    table.insert(loaded_languages, require("language." .. lang))
  end
else
  notify.info("Language Loader", "Loading all languages")
  for _, lang in ipairs(disponible_languages) do
    table.insert(loaded_languages, require("language." .. lang))
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

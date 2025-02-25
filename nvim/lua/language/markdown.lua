local markdown = {}

--------------------------------------------------------------------------------
-- Search for local dictionary -------------------------------------------------
--------------------------------------------------------------------------------
local function search_dictionary()
  print("------------->>>>> Buscando Dicionarios em: ")

  -- if vim.fn.filereadable(path) == 1 then
  --   return path
  -- end
  -- return nil
end
-- search_dictionary()
--------------------------------------------------------------------------------
-- Create custom dictionary for ltex language server ---------------------------
--------------------------------------------------------------------------------
local create_dictionary = function()
  local words = {}

  local file_exists = function(path)
    local f = io.open(path, "r")
    return f ~= nil and io.close(f)
  end

  local create_json_data = function(dicio_path)
    if not file_exists(dicio_path) then
      os.execute("mkdir -p " .. dicio_path:match("(.*/)"))
      local fp = io.open(dicio_path, "w+")
      fp:close()
    end
  end

  local add_new_words = function(add_path)
    for word in io.open(add_path, "r"):lines() do
      table.insert(words, word)
    end
  end

  local function dump(o)
    if type(o) == "table" then
      local s = "{ "
      for k, v in pairs(o) do
        if type(k) ~= "number" then
          k = '"' .. k .. '"'
        end
        s = s .. "[" .. k .. "] = " .. dump(v) .. ","
      end
      return s .. "} "
    else
      return tostring(o)
    end
  end

  -- local path_en = vim.fn.stdpath 'data' .. '/ltex/dictionaries/en.utf-8.add'
  local path_pt = vim.fn.stdpath("config") .. "/spell/spellfile.utf-8.add"

  -- create_json_data(path_en)
  create_json_data(path_pt)

  -- add_new_words(path_en)
  add_new_words(path_pt)

  return {
    -- ['en-US'] = words,
    ["pt-BR"] = words,
  }
end

--------------------------------------------------------------------------------
-- Plugins ---------------------------------------------------------------------
--------------------------------------------------------------------------------

markdown.plugins = {
  -- Spell check pt-br  (For all languages)
  { "mateusbraga/vim-spell-pt-br" },

  -- ALE for markdown fix indentation
  {
    "dense-analysis/ale",
    event = "VeryLazy",
    ft = { "markdown" },
    config = function()
      -- vim.g.ale_fix_on_save = 1
      vim.g.ale_fixers = {
        -- brew install pandoc
        markdown = { "pandoc" },
      }
      vim.g.ale_linters_explicit = 1

      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      -- vim.keymap.set("n", "<Leader>p", ":ALEFix<CR>", bufopts)

      vim.keymap.set("n", "<Leader>p", function()
        vim.cmd("ALEFix") -- Executa ALEFix

        -- Aguarda o ALEFix terminar antes de rodar as substituições
        vim.api.nvim_create_autocmd("User", {
          pattern = "ALEFixPost",
          once = true,                     -- Garante que o comando execute apenas uma vez
          callback = function()
            vim.cmd([[silent! %s/``` \+/```/g]]) -- Remove espaços extras após ```
            vim.cmd([[silent! %s/&#10;/\r/g]]) -- Substitui &#10; por quebra de linha
          end,
        })
      end, bufopts)
      -- vim.keymap.set('n', '<Leader>pa', ':ALECodeAction<CR>', bufopts)
      -- vim.keymap.set('n', '<Leader>l', ':ALELint<CR>', bufopts)
    end,
  },

  -- Emoji support
  {
    "junegunn/vim-emoji",
    ft = { "markdown" },
    config = function()
      vim.cmd("set completefunc=emoji#complete")
    end,
  },

  -- Show hex color in markdown
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "markdown" },
    config = function()
      require("colorizer").setup({
        markdown = {
          RGB = true,     -- #RGB hex codes
          RRGGBB = true,  -- #RRGGBB hex codes
          names = false,  -- "Name" codes like Blue
          RRGGBBAA = false, -- #RRGGBBAA hex codes
          rgb_fn = false, -- CSS rgb() and rgba() functions
          hsl_fn = false, -- CSS hsl() and hsla() functions
          css = false,    -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes: foreground, background
          mode = "background", -- Set the display mode.
        },
      })
    end,
  },

  -- Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    -- enabled = false,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install && git restore .",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- {
  --     'MeanderingProgrammer/render-markdown.nvim',
  --     dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  --     -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  --     -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  --     ---@module 'render-markdown'
  --     ---@type render.md.UserConfig
  --     opts = {},
  -- },

  {
    "OXY2DEV/markview.nvim",
    lazy = false,  -- Recommended
    ft = "markdown", -- If you decide to lazy-load anyway
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("colorizer").setup({
        -- code_blocks = {
        --   style = "simple",
        -- },
      })
    end,
  },
}

--------------------------------------------------------------------------------
-- Mason -----------------------------------------------------------------------
--------------------------------------------------------------------------------

markdown.mason = {
  "marksman",
  "ltex",
  "markdownlint",
}

--------------------------------------------------------------------------------
-- LSP -------------------------------------------------------------------------
--------------------------------------------------------------------------------

markdown.lsp = function(lspconfig, capabilities, on_attach)
  -- Use to create TOC(table of contents)
  lspconfig.marksman.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "markdown" },
  })

  -- from:  `npm i -g vscode-langservers-extracted`
  -- vim.lsp.start({
  --   name = 'vscode-markdown-language-server',
  --   cmd = { 'vscode-markdown-language-server', '--stdio' },
  --   init_options = {
  --     provideFormatter = true,
  --   },
  --   settings = {
  --     markdown = {
  --       validate = {
  --         enabled = true,
  --       },
  --     },
  --   },
  -- })

  -- For spell checking
  -- https://valentjn.github.io/ltex/settings.html
  lspconfig.ltex.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "markdown" },
    settings = {
      ltex = {
        logLevel = "finest",
        checkFrequency = "save",
        language = "pt-BR",
        additionalRules = {
          enablePickyRules = true,
          motherTongue = "pt-BR",
        },
        disabledRules = {
          ["pt-BR"] = {
            "TOO_LONG_SENTENCE",
            "ELLIPSIS",
            "DASH_RULE",
            "SMART_QUOTES",
            "WHITESPACE_RULE",
          },
        },
        dictionary = create_dictionary(),
      },
    },
  })
end

--------------------------------------------------------------------------------
-- Null LS ---------------------------------------------------------------------
--------------------------------------------------------------------------------

markdown.null_ls = function(null_ls, formatting, diagnostics, completion, code_actions, hover)
  return {
    null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.diagnostics.markdownlint.with({
      filetypes = { "markdown" },
      extra_args = {
        -- "--disable", "MD030"
      },
    }),
  }
end

--------------------------------------------------------------------------------
-- Options ---------------------------------------------------------------------
--------------------------------------------------------------------------------

markdown.options = function()
  --  Enable spell check
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "md", "markdown", "txt", "text" },
    callback = function()
      vim.cmd([[ set nospell ]])
      vim.cmd([[ set spelllang=pt_br ]])
      -- local project_folder = vim.fn.expand("%:p:h") .. "/.pt.utf-8.add"
      print(vim.fn.stdpath("config") .. "/spell/spellfile.utf-8.add")
      vim.opt_local.spellfile = vim.fn.stdpath("config") .. "/spell/spellfile.utf-8.add"
    end,
  })
end

return markdown

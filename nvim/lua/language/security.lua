local security = {}

-- TODO: Add this config on each language
local enable_snyk_languages = {
  "go",
  "java",
  "javascript",
  "elixir",
  "php",
  "python",
}

local enable_solar_languages = {
  "php",
  "python",
  "html",
  "go",
  "javascript",
  "java",
  "json",
  "elixir",
}

--------------------------------------------------------------------------------
-- Plugins ---------------------------------------------------------------------
--------------------------------------------------------------------------------

security.plugins = {
  {
    "schrieveslaach/sonarlint.nvim",
    url = "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-jdtls",
    },
    -- ft = enable_solar_languages,
  }
}

--------------------------------------------------------------------------------
-- Mason -----------------------------------------------------------------------
--------------------------------------------------------------------------------

security.mason = {
  "snyk_ls",
  "sonarlint-language-server",
}

--------------------------------------------------------------------------------
-- LSP -------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- security.lsp = function(lspconfig, capabilities, on_attach)
--   lspconfig.snyk_ls.setup({
--     capabilities = capabilities,
--     on_attach = on_attach,
--     filetypes = enable_snyk_languages,
--     -- cmd = {"/Users/kovi/.local/share/nvim/mason/bin/snyk-ls", "-f", "/Users/kovi/Documents/git/Configurations/nvim/logs/snyk-ls-vim.log", },
--     root_dir = function(name)
--       return lspconfig.util.find_git_ancestor(name) or vim.loop.os_homedir()
--     end,
--
--     init_options = {
--       activateSnykCode = "true",
--     },
--   })
--
-- local sonarlintAnalisers = {}

-- if sonarlintAnalisers["java"] then
--   table.insert(
--     sonarlintAnalisers,
--     vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar")
--   )
-- -- end
--
--   require("sonarlint").setup({
--     server = {
--       cmd = {
--         "sonarlint-language-server",
--         -- Ensure that sonarlint-language-server uses stdio channel
--         "-stdio",
--         "-analyzers",
--         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
--         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonargo.jar"),
--         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
--         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarxml.jar"),
--         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
--         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarphp.jar"),
--         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
--         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonariac.jar"), -- docker, k8s, terraform
--         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonar-elixir-plugin-1.0-SNAPSHOT.jar"),
--
--         -- ls ~/.local/share/nvim/mason/share/sonarlint-analyzers/
--         -- sonarcfamily.jar@
--         -- sonarhtml.jar@
--         -- sonarjava.jar@
--         -- sonarjs.jar@
--         -- sonarphp.jar@
--         -- sonartext.jar@
--         -- sonargo.jar@
--         -- sonariac.jar@
--         -- sonarjavasymbolicexecution.jar@
--         -- sonarlintomnisharp.jar@
--         -- sonarpython.jar@
--         -- sonarxml.jar@
--       },
--     },
--     filetypes = enable_solar_languages,
--   })
-- end


security.tools = {
  enable_sonarlint_analyzer = function(analyzer)
    require("sonarlint").setup({
      server = {
        cmd = {
          "sonarlint-language-server",
          "-stdio",
          "-analyzers",
          analyzer,
        }
      }
    })
  end,
}

return security

local elixir = {}

elixir.name = "elixir"
elixir.filetypes = { "elixir" }
elixir.fileExts = { "ex", "exs" }

elixir.asciiart = {
  [[ 	                     ==                      ]],
  [[                      ====                     ]],
  [[                     %====                     ]],
  [[                   +%%=====                    ]],
  [[                  %%%%==+++                    ]],
  [[               :%%%%%%#+++++                   ]],
  [[             :%%%%%%%%##++++                   ]],
  [[            :=%%%%%%%%###+*+=                  ]],
  [[          ::%%%%%%%%%%#####====                ]],
  [[        :::%%%%%%%%%%%%#######=                ]],
  [[       +::=%%%%%%%%%%%#########=               ]],
  [[     +++:=%%%%###%%#############**..           ]],
  [[    ++++:=%%%%###%%#####*******#****..         ]],
  [[   +++++:%%%%%%%**####******************       ]],
  [[  +++++++%%%%%%%%*####**********+++++****.     ]],
  [[  ++++++**%%%%%%##%%#****++******+++++***###   ]],
  [[ +++++++***%%######%#***++++++++*++++***#####  ]],
  [[ ++**********%########+++++++++++#****######## ]],
  [[ *************########*++++++++**#*########### ]],
  [[  =***************##*************###########== ]],
  [[   ==============**************===----------   ]],
  [[     ===================+++++++*++++++---+     ]],
  [[        =======---------=====++++++=====       ]],
  [[          ======-------------==+=====:         ]],
  [[                ===    --===::::               ]],
  [[                       :::::                   ]],
}

--------------------------------------------------------------------------------
-- Plugins ---------------------------------------------------------------------
--------------------------------------------------------------------------------

elixir.plugins = {
  -- {"elixir-lsp/elixir-ls", build = "asdf install && mix deps.get && mix compile && mix elixir_ls.release2 -o dist",}
  -- { "arthepsy/sonar-elixir" },
  -- ,
  {
    "peterquicken/sonar-elixir",
    build =
    "cp ./sonar-elixir-plugin-1.0-SNAPSHOT.jar ../../mason/share/sonarlint-analyzers/sonar-elixir-plugin-1.0-SNAPSHOT.jar",
  },
}

--------------------------------------------------------------------------------
-- Mason -----------------------------------------------------------------------
--------------------------------------------------------------------------------

elixir.mason = {
  "elixir-ls",
  -- "credo",
  -- "nextls",
}

--------------------------------------------------------------------------------
-- LSP -------------------------------------------------------------------------
--------------------------------------------------------------------------------

elixir.lsp = function(lspconfig, capabilities, on_attach)
  lspconfig.elixirls.setup({
    cmd = { vim.fn.expand("$MASON/bin/elixir-ls") },
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = elixir.filetypes,
  })

  require("language.security").tools.enable_sonarlint_analyzer(
    vim.fn.expand("$MASON/share/sonarlint-analyzers/sonar-elixir-plugin-1.0-SNAPSHOT.jar")
  )

  -- 	lspconfig.nextls.setup({
  -- 		capabilities = capabilities,
  -- 		on_attach = on_attach,
  -- 		cmd = { "~/.cache/elixir-tools/nextls/bin/nextls" },
  -- 		filetypes = { "elixir" },
  -- 	})
end

--------------------------------------------------------------------------------
-- Null LS ---------------------------------------------------------------------
--------------------------------------------------------------------------------
elixir.null_ls = function(null_ls, formatting, diagnostics, completion, code_actions, hover)
  local h = require("null-ls.helpers")
  local methods = require("null-ls.methods")

  local DIAGNOSTICS_ON_SAVE = methods.internal.DIAGNOSTICS_ON_SAVE

  local sobelow_source = h.make_builtin({
    name = "sobelow",
    method = DIAGNOSTICS_ON_SAVE,
    filetypes = { "elixir", "ex" },
    generator_opts = {
      command = "mix",
      args = {
        "sobelow",
        "-f",
        "sarif",
        "--root",
        "./apps/caduceus/", -- FIXME: não precisar passar esse parametro

        -- " | sed 's/^WARNING.*$//'",
        -- " | sed 's/^please.*$//'",
        -- " | sed 's/^\\=\\=\\>.*/,/'",
        -- ' | awk \'BEGIN {print "[{}"} { print } END { print "}"}\'',
      },
      format = "raw",
      to_stdin = true,
      multiple_files = true,
      on_output = function(params, done)
        if params.err ~= "" then
          require("config.utils").notify.error("Sobelow", params.err)
        end

        local issues = {}

        local fixed_input = params.output
        fixed_input = string.gsub(fixed_input, "WARNING:[^\n]+", "")
        fixed_input = string.gsub(fixed_input, "please[^\n]+", "")
        fixed_input = string.gsub(fixed_input, "%=%=%>[^\n]+", "")

        local ok, decoded = pcall(vim.json.decode, fixed_input)

        if not ok then
          return done({ message = params.output, row = 1, source = "Sobelow" })
        end

        local rules = nil
        if decoded.runs ~= nil then
          for _, run in ipairs(decoded.runs) do
            -- Create rules table
            if rules == nil then
              rules = {}
              if run.tool ~= nil and run.tool.driver ~= nil and run.tool.driver.rules ~= nil then
                for _, rule in ipairs(run.tool.driver.rules) do
                  rules[rule.id] = rule
                end
              end
            end

            if run.results ~= nil then
              for _, issue in ipairs(run.results) do
                local message = ""

                if rules[issue.ruleId] ~= nil then
                  message = rules[issue.ruleId].fullDescription.text
                      .. "("
                      .. issue.ruleId
                      .. ")"
                      .. "\n"
                      .. rules[issue.ruleId].help.markdown
                else
                  message = issue.message.text
                end

                local details = issue.locations[1].physicalLocation

                local err = {
                  severity = 1, -- 1 (error), 2 (warning), 3 (information), 4 (hint)
                  message = message,
                  row = details.region.startLine,
                  col = details.region.startColumn,
                  filename = params.root .. "/" .. details.artifactLocation.uri,
                  source = "Sobelow",
                }

                table.insert(issues, err)
              end
            end
          end
        end

        done(issues)
      end,
    },
    factory = h.generator_factory,
  })

  null_ls.register({ sobelow_source })

  return {
    diagnostics.credo.with({
      filetypes = elixir.filetypes,
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      command = "mix",
      args = {
        "credo",
        "suggest",
        "--strict",
        "--format",
        "json",
        "--read-from-stdin",
        "$filename",
      },
      extra_args = { "--ignore", "todo" },
    }),
  }
end

--------------------------------------------------------------------------------
--- Debugging ------------------------------------------------------------------
--------------------------------------------------------------------------------

elixir.debugging = function(dap)
  dap.adapters.mix_task = {
    type = "executable",
    command = vim.fn.expand("$MASON/bin/elixir-ls/debug_adapter.sh"),
    args = {},
  }

  -- https://github.com/elixir-lsp/elixir-ls#debugger-support
  dap.configurations.elixir = {
    {
      type = "mix_task",
      name = "mix test",
      task = "test",
      taskArgs = { "--trace" },
      request = "launch",
      startApps = true, -- for Phoenix projects
      projectDir = "${workspaceFolder}",
      requireFiles = {
        "test/**/test_helper.exs",
        "test/**/*_test.exs",
      },
    },
  }
end

return elixir

local exampleLang = {}

--------------------------------------------------------------------------------
-- Language Presets ------------------------------------------------------------
--------------------------------------------------------------------------------

-- exampleLang.name = "exampleLang"
-- exampleLang.filetypes = { "example" }
-- exampleLang.fileExts = { "exa", "exp" }

-- -- Oprional ascii art language icon, will be used in the welcome screen
-- exampleLang.asciiart = {
--   [[      ==   ]],
--   [[    =====  ]],
--   [[  %%%====  ]],
-- }

--------------------------------------------------------------------------------
-- Plugins ---------------------------------------------------------------------
--------------------------------------------------------------------------------

-- exampleLang.plugins = {
--   {
--     "exampleGit/examplePlugin",
--     ft = { "exampleLang" },
--     config = function()
--       exampleSetup()
--     end,
--   },
-- }

--------------------------------------------------------------------------------
-- Mason -----------------------------------------------------------------------
--------------------------------------------------------------------------------

-- exampleLang.mason = {
--   "exampleLangLsp",
--   "exampleLangFormatter",
--   "exampleLangLint",
--   "exampleLangCodeActions",
-- }

--------------------------------------------------------------------------------
-- LSP -------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- exampleLang.lsp = function(lspconfig, capabilities, on_attach)
--   lspconfig.exampleLangLsp.setup({
--     capabilities = capabilities,
--     on_attach = on_attach,
--     filetypes = { "exampleLang" },
--   })
-- end

--------------------------------------------------------------------------------
-- Null LS ---------------------------------------------------------------------
--------------------------------------------------------------------------------

-- exampleLang.null_ls = function(null_ls, formatting, diagnostics, completion, code_actions, hover)
--   return {
--     null_ls.builtins.formatting.exampleLangFormatter,
--     null_ls.builtins.diagnostics.exampleLangLint,
--     null_ls.builtins.code_actions.exampleLangCodeActions,
--   }
-- end

--------------------------------------------------------------------------------
--- Debugging ------------------------------------------------------------------
--------------------------------------------------------------------------------
-- exampleLang.debugging = function(dap)
-- -- see whow config: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
-- end

--------------------------------------------------------------------------------
-- Options ---------------------------------------------------------------------
--------------------------------------------------------------------------------

-- markdown.options = function()
--   vim.api.nvim_create_autocmd("FileType", {
--     pattern = {"exampleLang"},
--     callback = function()
--       vim.cmd([[ set exampleLang=exampleLang ]])
--     end
--   })
-- end

return exampleLang

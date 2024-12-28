return {
  mason = { "intelephense", },

  lsp = function(lspconfig, capabilities, on_attach)
    lspconfig.intelephense.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = lspconfig.util.root_pattern("composer.json", ".git", "index.php"),
      filetypes = { "php" },
    })

    require("language.security").tools.enable_sonarlint_analyzer(
      vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarphp.jar")
    )
  end
}

return {
  mason = { "zls" },

  lsp = function(lspconfig, capabilities, on_attach)
    lspconfig.zls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "zig" },
    })
  end,
}

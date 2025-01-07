return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local trouble = require("trouble")
    local symbols = trouble.statusline({
      mode = "lsp_document_symbols",
      groups = {},
      title = false,
      filter = { range = true },
      format = "{kind_icon}{symbol.name:Normal}",
      -- The following line is needed to fix the background color
      -- Set it to the lualine section you want to use
      hl_group = "lualine_c_normal",
    })
    table.insert(opts.sections.lualine_c, {
      symbols.get,
      cond = symbols.has,
    })

    -- TabNine
    local pluginTabnine = require("config.utils").plugin_finder("ai", "codota/tabnine-nvim")

    if pluginTabnine ~= false then
      if pluginTabnine.enabled then
        opts = pluginTabnine.setup_lua_line(opts)
      end
    end
  end,
}

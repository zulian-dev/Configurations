return {
  {
    --"williamboman/mason.nvim",/
    "mason-org/mason.nvim",
    lazy = false,
    config = function()
      local mason = require("mason")
      mason.setup({
        ensure_installed = require("language").mason.setup(),
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    --"williamboman/mason-lspconfig.nvim",
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      -- require("config.utils").notify.info("MASON TOOLS", "Setup")
      require("mason-tool-installer").setup({
        ensure_installed = require("language").mason.setup(),
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    lazy = false,
    config = function()
      -- local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local buf_format = function()
        -- local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
        -- for _, client in ipairs(clients) do
        -- 	print("Cliente LSP " .. client.name)
        -- 	if client.supports_method("textDocument/formatting") then
        -- 		print("Cliente LSP com suporte à formatação: " .. client.name)
        -- 	end
        -- end
        --
        vim.lsp.buf.format({
          async = false,
        })
      end

      local function on_attach(client, bufnr)
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        -- if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = buf_format,
          -- callback = function()
          --   -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          --   -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
          --
          --   --vim.lsp.buf.formatting_sync()
          --   vim.lsp.buf.format({
          --     bufnr = bufnr,
          --     async = false,
          --   })
          -- end,
        })
        -- end -- if client.supports_method("textDocument/formatting")

        -- Enable completion triggered by <c-x><c-o>
        -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "gK", vim.lsp.buf.hover, bufopts)

        -- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        -- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
        -- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
        -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        -- vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, {})
        -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        -- vim.keymap.set("n", "gS", vim.lsp.buf.signature_help, bufopts)
        -- vim.keymap.set("n", "rn", vim.lsp.buf.rename, bufopts)
        -- vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        -- vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        -- vim.keymap.set("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
        -- vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, bufopts)
        -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "<RightMouse>", vim.lsp.buf.code_action, bufopts)
        -- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "<leader>lr", ":Telescope lsp_references", bufopts)
        vim.keymap.set("n", "<leader>fm", function()
          vim.api.nvim_exec_autocmds("BufWritePre", {})
        end, bufopts)
      end

      local lspconfig = require("lspconfig")

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      require("language").lsp.setup(lspconfig, capabilities, on_attach)

      -- Editor settings for LSP custom signs
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Dialog box for LSP visual setup
      -- vim.diagnostic.config({
      -- 	virtual_text = true,
      -- 	signs = true,
      -- 	underline = true,
      -- 	update_in_insert = false,
      -- 	severity_sort = false,
      -- })

      vim.diagnostic.config({
        -- Show diagnostic message using virtual text.
        virtual_text = false,
        -- Show a sign next to the line with a diagnostic.
        signs = true,
        -- Update diagnostics while editing in insert mode.
        update_in_insert = true,
        -- Use an underline to show a diagnostic location.
        underline = true,
        -- Order diagnostics by severity.
        severity_sort = false,
        -- Show diagnostic messages in floating windows.
        float = {
          border = "rounded",
          source = true,
          -- source = "always",
          -- header = '',
          -- prefix = '',
          -- Credit: https://github.com/jessarcher/dotfiles/blob/master/nvim/lua/user/plugins/lspconfig.lua
          format = function(diagnostic)
            if diagnostic.user_data ~= nil and diagnostic.user_data.lsp.code ~= nil then
              return string.format("%s: %s", diagnostic.user_data.lsp.code, diagnostic.message)
            end
            return diagnostic.message
          end,
        },
      })

      -- to show full diagnostic message on hover line diagnostic
      -- You will likely want to reduce updatetime which affects CursorHold
      -- note: this setting is global and should be set only once
      vim.o.updatetime = 250
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
        callback = function()
          if vim.fn.mode() == "n" then
            vim.diagnostic.open_float(nil, { focus = false })
          end
        end,
      })
    end,
  },
}

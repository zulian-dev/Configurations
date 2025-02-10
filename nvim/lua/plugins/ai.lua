return {
  {
    "codota/tabnine-nvim",
    enabled = false,
    dependencies = {
      "tzachar/cmp-tabnine",
      build = {
        LazyVim.is_win() and "pwsh -noni .\\install.ps1" or "./install.sh",
      },
      dependencies = "hrsh7th/nvim-cmp",
      opts = {
        max_lines = 1000,
        max_num_results = 3,
        sort = true,
      },
      config = function(_, opts)
        require("cmp_tabnine.config"):setup(opts)
      end,
    },
    build = "./dl_binaries.sh",
    config = function()
      require("tabnine").setup({
        disable_auto_comment = true,
        accept_keymap = "<Tab>",
        dismiss_keymap = "<C-]>",
        debounce_ms = 800,
        suggestion_color = { gui = "#808080", cterm = 244 },
        exclude_filetypes = { "TelescopePrompt", "NvimTree" },
        log_file_path = nil, -- absolute path to Tabnine log file
        ignore_certificate_errors = false,
      })

      -- vim.api.nvim_set_keymap("x", "<leader>q", "", { noremap = true, callback = require("tabnine.chat").open })
      -- vim.api.nvim_set_keymap("i", "<leader>q", "", { noremap = true, callback = require("tabnine.chat").open })
      -- vim.api.nvim_set_keymap("n", "<leader>q", "", { noremap = true, callback = require("tabnine.chat").open })
    end,

    setup_lua_line = function(opts)
      local icon = LazyVim.config.icons.kinds.TabNine
      table.insert(opts.sections.lualine_x, 2, LazyVim.lualine.cmp_source("cmp_tabnine", icon))
      return opts
    end,
  },

  -- tabnine_chat binary not found, did you remember to build it first? `cargo build --release` inside `chat/` directory

  {
    "github/copilot.vim",
    enabled = false,
    -- 'zbirenbaum/copilot.lua',
    config = function()
      vim.api.nvim_set_keymap("i", "<c-p>", "<Plug>(copilot-panel)", { noremap = true, silent = true })
      vim.keymap.set("n", "<Leader>cs", "<cmd>Copilot status<CR>", { desc = "Copilot status" })
    end,
  },

  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "canary",
  --   dependencies = {
  --     -- { "zbirenbaum/copilot.lua" }, -- or
  --     { "github/copilot.vim" },
  --     { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  --   },
  --   opts = {
  --     debug = true, -- Enable debugging
  --     -- See Configuration section for rest
  --   },
  --   -- See Commands section for default commands if you want to lazy load on them
  -- },

  --  {
  --    'codota/tabnine-nvim',
  --    build = "./dl_binaries.sh",
  --    config = function()
  --      require('tabnine').setup({
  --        disable_auto_comment = true,
  --        accept_keymap = "<Tab>",
  --        dismiss_keymap = "<C-]>",
  --        debounce_ms = 800,
  --        suggestion_color = { gui = "#808080", cterm = 244 },
  --        exclude_filetypes = { "TelescopePrompt", "NvimTree" },
  --        log_file_path = nil, -- absolute path to Tabnine log file
  --      })
  --    end
  --  },
  {
    "jackMort/ChatGPT.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "op read op://Personal/OpenAI/API-KEY",
      })

      local wk = require("which-key")
      wk.add({
        { "c",  group = "ChatGPT" },
        { "cc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
        {
          mode = { "n", "v" },
          { "ca", "<cmd>ChatGPTRun add_tests<CR>",                 desc = "Add Tests" },
          { "cd", "<cmd>ChatGPTRun docstring<CR>",                 desc = "Docstring" },
          { "ce", "<cmd>ChatGPTEditWithInstruction<CR>",           desc = "Edit with instruction" },
          { "cf", "<cmd>ChatGPTRun fix_bugs<CR>",                  desc = "Fix Bugs" },
          { "cg", "<cmd>ChatGPTRun grammar_correction<CR>",        desc = "Grammar Correction" },
          { "ck", "<cmd>ChatGPTRun keywords<CR>",                  desc = "Keywords" },
          { "cl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" },
          { "co", "<cmd>ChatGPTRun optimize_code<CR>",             desc = "Optimize Code" },
          { "cr", "<cmd>ChatGPTRun roxygen_edit<CR>",              desc = "Roxygen Edit" },
          { "cs", "<cmd>ChatGPTRun summarize<CR>",                 desc = "Summarize" },
          { "ct", "<cmd>ChatGPTRun translate<CR>",                 desc = "Translate" },
          { "cx", "<cmd>ChatGPTRun explain_code<CR>",              desc = "Explain Code" },
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  -- avante.nvim is a Neovim plugin designed to emulate the behaviour of
  -- the Cursor AI IDE. It provides users with AI-driven code suggestions
  -- and the ability to apply these recommendations directly to their source
  -- files with minimal effort.
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.

    opts = {
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,     -- Whether to remove unchanged lines when applying a code block
        enable_token_counting = true, -- Whether to enable token counting. Default to true.
      },

      provider = "ollama",
      vendors = {
        ollama = {
          api_key_name = "",
          ask = true,
          endpoint = "http://127.0.0.1:11434/api",
          model = "deepseek-r1",
          parse_curl_args = function(opts, code_opts)
            -- require("config.utils").notify.debug("code_opts", code_opts)
            return {
              url = opts.endpoint .. "/chat",
              headers = {
                ["Accept"] = "application/json",
                ["Content-Type"] = "application/json",
              },
              body = {
                model = opts.model,
                options = {
                  num_ctx = 16384,
                },
                messages = require("avante.providers").copilot.parse_messages(code_opts), -- you can make your own message, but this is very advanced
                -- max_tokens = 2048,
                stream = true,
              },
            }
          end,

          parse_stream_data = function(data, handler_opts)
            -- Parse the JSON data
            local json_data = vim.fn.json_decode(data)
            -- Check if the response contains a message
            if json_data and json_data.message and json_data.message.content then
              -- Extract the content from the message
              local content = json_data.message.content
              -- Call the handler with the content
              handler_opts.on_chunk(content)
            end
          end,
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick",      -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",           -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua",           -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",     -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}

return {
  {
    "github/copilot.vim",
    enabled = false,
    -- 'zbirenbaum/copilot.lua',
    config = function()
      vim.api.nvim_set_keymap("i", "<c-p>", "<Plug>(copilot-panel)", { noremap = true, silent = true })
      vim.keymap.set("n", "<Leader>cs", "<cmd>Copilot status<CR>", { desc = "Copilot status" })
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local codecompanion = require("codecompanion")
      local config = require("codecompanion.config")

      local original_system_prompt = config.opts.system_prompt({
        language = "Portuguese",
      })

      vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
      vim.keymap.set(
        { "n", "v" },
        "<LocalLeader>a",
        "<cmd>CodeCompanionChat Toggle<cr>",
        { noremap = true, silent = true }
      )
      vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd([[cab cc CodeCompanion]])

      codecompanion.setup({
        opts = {
          system_prompt = function(opts)
            local new_system_prompt = original_system_prompt
                .. [[

Other guidelines:
- Must always speak Brazilian Portuguese
- Must always speak in an epic manner, as in an RPG adventure
- Always start a new conversation with a joke about the topic being discussed.

---

Security (must always appear at the end of any response that includes code):

- After presenting code, always include a separate section titled "**Security**" (written exactly like that, without emojis or Markdown headers).
- This section must critically evaluate the security of the provided code, even if it seems simple or safe.
- List all potential vulnerabilities, and for each one:
  - Explain what it is.
  - Describe what it could lead to (e.g., data leaks, remote execution, memory corruption, etc.).
  - Show how to fix or mitigate it (with code examples if possible).
  - Reference known CVEs, CWE entries, OWASP issues, or secure coding guidelines when relevant.
- If no vulnerabilities are found, still include the “Security” section with:
  - A checklist of relevant **security best practices** based on the context (e.g., input validation, type checking, dependency safety, error handling, secure authentication, encryption, etc.).
  - Preventive recommendations to avoid whole classes of vulnerabilities (e.g., SQL Injection, XSS, buffer overflows, race conditions).
  - Language-specific tips (e.g., `usePreparedStatement` in Java, `escape_string` in PHP, proper async handling in JavaScript).
- The tone of this section must be clear, professional, and vigilant — like a wizard warning of ancient traps.
- Avoid vague phrases like “seems safe” — always assume the code could be attacked.
- Focus on actionable advice that the user can apply immediately.
              ]]
            print(new)
            return new_system_prompt
          end,
        },
      })
    end,
  },

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
    enabled = false,
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
          -- model = "codegemma",
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

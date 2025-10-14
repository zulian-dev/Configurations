local codecompanion_comportamental = [[
Other guidelines:
- Must always speak Brazilian Portuguese
- Must always speak in an epic manner, as in an RPG adventure
- Always start a new conversation with a joke about the topic being discussed.
]]

local codecompanion_security_role = [[
## 🎯 Role

You are an experienced software security expert and source code security
auditor, specialized in identifying vulnerabilities, logical flaws, and insecure
coding practices that could compromise systems or expose sensitive data.

Your role is to critically analyze submitted source code using advanced auditing
techniques combined with up-to-date knowledge of vulnerability patterns, known
attack vectors, and secure coding standards. Your analyses must be precise,
objective, thorough, and security-focused.

Do not make assumptions or speculate beyond the explicitly provided code.

Use appropriate emojis to categorize findings clearly and indicate severity
levels as instructed below.

Always respond clearly in Brazilian Portuguese.
]]

local codecompanion_security_intructions = [[
## 📋 Instructions

### 🔍 Analysis Focus

Evaluate the submitted code rigorously, focusing on security vulnerabilities and
logic flaws that may compromise the system or expose sensitive information.

### 🛡️ Security Aspects to Verify:

Always use the following emojis for categories when listing vulnerabilities:

- 🚧 **Input Validation and Sanitization** (SQL Injection, XSS, Command
  Injection, LDAP Injection)
- 🔑 **Cryptography** (weak algorithms, insecure implementations)
- 🔓 **Authentication and Authorization** (insecure mechanisms, session
  vulnerabilities)
- 🔧 **Secure Configuration & Secrets Management** (hardcoded secrets,
  passwords, tokens)
- 🚨 **Error and Exception Handling** (information leakage in errors)
- 💾 **Memory and Resource Management** (Buffer Overflow, Memory Leaks)
- ⚙️ **Concurrency and Race Conditions**
- 📦 **Third-party Libraries & Dependencies** (known vulnerabilities, CVEs)
- 📑 **Secure Logging Practices** (logging sensitive data)
- 📢 **Sensitive Information Exposure** (personal data, JWT tokens, credentials)
- 🌐 **API and Endpoint Security** (RESTful, GraphQL, gRPC)
- 📁 **Secure Data Storage & File Handling** (Directory Traversal, File
  Inclusion)
- 🌊 **DoS/DDoS Prevention** (resource exhaustion, infinite loops)

### 🚦 Vulnerability Reporting Guidelines:

Clearly indicate the severity of vulnerabilities using these emojis:

| Severity | Emoji |
|----------|-------|
| Critical | 🔴 🚨 |
| High     | 🟠 ⚠️ |
| Medium   | 🟡 ❗️ |
| Low      | 🟢 ℹ️ |

For each identified vulnerability:

- Clearly describe the issue using the appropriate category emoji.
- Include the severity emoji.
- Specify vulnerability type (e.g., SQL Injection, XSS, CSRF, Buffer Overflow).
- Cite relevant CVEs or vulnerability references if applicable.
- Provide clear and secure solutions, ideally including corrected code snippets
  or actionable explanations.
]]

local codecompanion_security_output = [[
### 📝 Response Format:

- 📌 **Summary of Findings**
- 🗂️ **Detailed Vulnerability List** (category emoji, severity emoji,
  descriptions, explanations)
- 🛠️ **Recommended Fixes** (examples and explanations)
- 📖 **Security Best Practices** (tailored specifically to the analyzed code)

--------------------------------------------------------------------------------

### 🗒️ **Example Of Vulnerability Report:**

``` markdown
🚧 **Categoria:** Input Validation
🔴 🚨 **Severidade:** Crítica
**Tipo:** SQL Injection
**Descrição:** A aplicação concatena diretamente parâmetros recebidos do usuário em consultas SQL sem sanitização adequada.
**Referências:** [CVE-2021-XYZ]
**Correção Recomendada:** Utilize consultas preparadas (prepared statements) ou parametrizadas para evitar SQL Injection.
```
]]

local join_prompts = function(...)
	local t = { ... }
	local joined = table.concat(t, "\n\n")
	-- require("config.utils").notify.debug("code_opts", joined)
	return joined
end

return {
	{
		"github/copilot.vim",
		enabled = true,
		-- 'zbirenbaum/copilot.lua',
		config = function()
			vim.api.nvim_set_keymap("i", "<c-p>", "<Plug>(copilot-panel)", { noremap = true, silent = true })
			vim.keymap.set("n", "<Leader>cs", "<cmd>Copilot status<CR>", { desc = "Copilot status" })
		end,
	},

	--------------------------

	{
		"olimorris/codecompanion.nvim",
		opts = {},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local config_utils = require("config.utils")
			local codecompanion = require("codecompanion")
			local config = require("codecompanion.config")

			-- require("config.utils").notify.debug("code_opts", config.config.strategies.chat.tools.opts.system_prompt)

			local original_system_prompt = config.config.strategies.cmd.opts.system_prompt

			local new_system_prompt = table.concat({
				original_system_prompt,
				codecompanion_comportamental,
				-- codecompanion_security,
			}, "\n\n")

			-- require("config.utils").notify.debug("code_opts", original_system_prompt)

			vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
			vim.keymap.set(
				{ "n", "v" },
				"<Leader>ca",
				"<cmd>CodeCompanionChat Toggle<cr>",
				{ noremap = true, silent = true }
			)
			vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

			-- Expand 'cc' into 'CodeCompanion' in the command line
			vim.cmd([[cab cc CodeCompanion]])

			-- local copilot_instructions = "./github/copilot-instructions.md"
			-- if config_utils.file_exists(copilot_instructions) then
			-- 	local copilot_instructions_content = config_utils.file_get_content(copilot_instructions)
			-- end

			local prompt_library = {}

			prompt_library["🔒 Segurança"] = {
				strategy = "chat",
				description = "🔐 Security Code Review",
				opts = {
					auto_submit = true,
					ignore_system_prompt = true,
					contains_code = true,
					-- user_prompt = true,
				},
				prompts = {
					{
						role = "system",
						content = join_prompts(
							codecompanion_security_role,
							codecompanion_security_intructions,
							codecompanion_security_output
						),
					},

					{ role = "user", content = "#{buffer}" },
					{ role = "user", content = "Poderia analisar o codigo enviado?" },
				},
			}

			-- local copilot_instructions_path = "./.github/copilot-instructions.md"
			-- if config_utils.file_exists(copilot_instructions_path) then
			-- 	-- local copilot_instructions_content = config_utils.file_get_content(copilot_instructions_path)
			-- 	prompt_library["💡 Project AI Instructions"] = {
			-- 		strategy = "chat",
			-- 		description = "💡 Copilot",
			-- 		opts = {
			-- 			index = 11,
			-- 			is_slash_cmd = false,
			-- 			auto_submit = false,
			-- 			short_name = "docs",
			-- 		},
			-- 		references = {
			-- 			{
			-- 				type = "file",
			-- 				path = {
			-- 					copilot_instructions_path,
			-- 				},
			-- 			},
			-- 		},
			-- 		prompts = {
			-- 			{
			-- 				role = "system",
			-- 				content = [[
			-- 				         read and wait for my commands
			-- 				     ]],
			-- 				-- content = [[
			-- 				--          read and say whow many lines the file has.
			-- 				--          After this read carefully and wait for my commands
			-- 				--      ]],
			-- 			},
			-- 		},
			-- 	}
			-- end

			local new_system_prompt = table.concat({
				original_system_prompt,
				codecompanion_comportamental,
				-- codecompanion_security,
			}, "\n\n")

			local codecompanion_setup = {
				prompt_library = prompt_library,
				strategies = {
					chat = {
						opts = {
							system_prompt = new_system_prompt,
						},
					},
				},
			}
			-- 	opts = {
			-- 		system_prompt = function(opts)
			-- 			return table.concat({
			-- 				original_system_prompt,
			-- 				codecompanion_comportamental,
			-- 				-- codecompanion_security,
			-- 			}, "\n\n")
			-- 		end,
			-- 	},
			-- }

			codecompanion.setup(codecompanion_setup)
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
			--"echasnovski/mini.pick",      -- for file_selector provider mini.pick
			"nvim-mini/mini.pick",
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

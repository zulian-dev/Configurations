local test = [=====[
#
# GLOBALS
#

# Host
http://localhost:3000

## curl options
--silent

# Headers
Accept: application/json;
Connection: keep-alive
Content-Type: application/json; charset=utf-8

--

#
# INDEX
#

--
## Get index
GET /



#
# DEVELOPERS
#

## Get all developers
--
GET /developers


## Get all developer by id 
--
GET /developers/dev_OgZz9ThCHOo-vbbMl5guD



## create new developer 
--
POST /developers
{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "dateOfBirth": "1992-03-23"
}



--
## update developer 
PATCH /developers/dev_s6UGBHNMGAK6vZ88RSp1i
{
  "email": "teste@2example.com"
}


--
# deletedeveloper 
DELETE /developers/dev_s6UGBHNMGAK6vZ88RSp1i

--]=====]

function mysplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

return {
	{
		"diepm/vim-rest-console",
		ft = { "http", "rest" },
		lazy = false,
		keys = {
			{ "<leader>j", group = "API", desc = " API", icon = "󱂛 " }, -- group
			{
				"<leader>jp",
				function()
					vim.cmd("vsplit | terminal posting")
				end,
				desc = "Open Posting",
			},
			{
				"<leader>jc",
				function()
					-- Cria um novo buffer com o nome "api.rest"
					vim.cmd(":new api.rest")

					-- Obtém o ID do buffer atual (o que foi criado pelo comando acima)
					local buf = vim.api.nvim_get_current_buf()

					-- Define o conteúdo do buffer como uma lista de linhas
					local lines = mysplit(test, "\n")
					-- Escreve as linhas no buffer
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
				end,
				desc = "Create a new api.rest file",
				mode = { "n" },
				buffer = true,
			},
			{
				"<leader>jj",
				function()
					vim.cmd("call VrcQuery()")
				end,
				desc = "Run API request under cursor",
				mode = { "n", "v" },
			},
		},

		config = function()
			-- <C-j>

			vim.g.vrc_curl_opts = {
				["-i"] = "", -- Show curl headers
			}
			vim.g.vrc_set_default_mappings = 0
			vim.g.vrc_response_default_content_type = "application/json"
			vim.g.vrc_output_buffer_name = "_OUTPUT.json"
			vim.g.vrc_auto_format_response_patterns = {
				json = "jq",
			}
		end,
	},
}

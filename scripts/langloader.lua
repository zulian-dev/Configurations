local langs = dofile("/Users/kovi/.config/nvim/lua/config/languages.lua")
local args = ""
for _, v in pairs(langs) do
	args = args .. " " .. (v .. " " .. v:upper() .. " off")
end

print(args)

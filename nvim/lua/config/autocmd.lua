-- autocmd
--------------------------------------------------------------------------------
-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local M = {}

local lsp_disabled = false

function M.minimal()
	-- desliga números de linha
	vim.opt.number = false
	vim.opt.relativenumber = false

	-- esconde a barra de status (se estiveres a usar lualine.nvim)
	if package.loaded["lualine"] then
		require("lualine").hide()
	end

	-- esconde a barra de abas/topo (tabline) e barra de janela (winbar)
	vim.opt.showtabline = 0
	vim.opt.winbar = ""

	-- esconde sinais à esquerda (gutter) como sinais de erro/lsp, etc
	vim.opt.signcolumn = "no"

	-- esconde a barra de comandos ou mensagem (cmdline) se te interessar
	vim.opt.cmdheight = 0

	-- esconde o foldcolumn
	vim.opt.foldcolumn = "0"

	vim.opt_local.spell = false -- ou vim.opt.spell = false para global

	-- Outros ajustes – ex: sem rótulos de arquivo no título
	vim.opt.title = false

	-- Desligar LSP se ainda não desligado
	if not lsp_disabled then
		for _, client in pairs(vim.lsp.get_clients()) do
			client:stop() -- para cada cliente ativo
		end
		vim.diagnostic.reset() -- opcional: limpar diagnósticos visíveis
		lsp_disabled = true
	end

	-- obter todos os clientes LSP ativos
	for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
		-- parar apenas os clientes que estão ligados ao buffer atual (bufnr = 0)
		client:stop()
	end
	-- opcional: limpar diagnósticos também
	vim.diagnostic.reset()

	vim.cmd("LspStop ltex")
end

return M

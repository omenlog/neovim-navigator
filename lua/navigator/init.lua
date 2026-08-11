local M = {}

function M.setup()
	vim.api.nvim_create_user_command("NavigatorHello", function()
		vim.notify("Hello from navigator!", vim.log.levels.INFO)
	end, {})
end

return M

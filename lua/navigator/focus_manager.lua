local M = {}
local utils = require('navigator.utils')

local active_session_id

local group = vim.api.nvim_create_augroup("NavigatorFocusManager", {
	clear = true,
})

local get_session_id = function()
	utils.run("macterm pane inspect --json", function(err, data)
		if err then
			vim.notify("Navigator: error getting active session ID: " .. err, vim.log.levels.ERROR)
			return
		end

		local ok, parsed_data = pcall(vim.json.decode, data)
		if not ok then
			vim.notify("Navigator: invalid JSON: " .. parsed_data, vim.log.levels.ERROR)
			return
		end

		active_session_id = parsed_data.inspect.session
	end)
end

M.init = function()
	vim.api.nvim_create_autocmd("FocusGained", {
		group = group,
		callback = get_session_id,
	})
	get_session_id()
end

M.get_active_session_id = function()
	return active_session_id
end

return M

local utils = require('navigator.utils')
local focus_manager = require('navigator.focus_manager')

local M = {}

M.create_navigation_handler = function(fallbackDirection)
	return function(err, data)
		if err then
			print("Navigator Error: " .. err)
			return
		end

		local ok, parsed_data = pcall(vim.json.decode, data)
		if not ok then
			print("Invalid JSON: " .. parsed_data)
			return
		end

		local active_session_id = focus_manager.get_active_session_id()
		if not active_session_id then
			return
		end

		local focused_pane = parsed_data.panes and parsed_data.panes[1]
		if focused_pane and focused_pane.session == active_session_id then
			utils.run("macterm pane focus --direction " .. fallbackDirection)
		end
	end
end

return M

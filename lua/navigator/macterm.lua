local utils = require('navigator.utils')
local focus_manager = require('navigator.focus_manager')

local M = {}

local function create_fallback_handler(fallbackDirection)
	return function(err, data)
		if err then
			vim.notify("Navigator: " .. err, vim.log.levels.ERROR)
			return
		end

		local ok, parsed_data = pcall(vim.json.decode, data)
		if not ok then
			vim.notify("Navigator: invalid JSON: " .. parsed_data, vim.log.levels.ERROR)
			return
		end

		local active_session_id = focus_manager.get_active_session_id()
		if not active_session_id then
			return
		end

		local focused_pane = parsed_data.panes and parsed_data.panes[1]
		if focused_pane and focused_pane.session == active_session_id then
			utils.run({ "macterm", "pane", "focus", "--direction", fallbackDirection })
		end
	end
end

--@param direction string
--@param fallbackDirection string
--@param directionKey string
--@return fun()
local function create_handler(direction, fallbackDirection, directionKey)
	return function()
		if vim.fn.winnr(directionKey) ~= vim.fn.winnr() then
			vim.cmd("wincmd " .. directionKey)
			return
		end

		local fallbackHandler = create_fallback_handler(fallbackDirection)
		utils.run({ "macterm", "pane", "focus", "--direction", direction, "--json" }, fallbackHandler)
	end
end

M.focus_up_pane = create_handler("up", "down", "k")
M.focus_down_pane = create_handler("down", "up", "j")
M.focus_left_pane = create_handler("left", "right", "h")
M.focus_right_pane = create_handler("right", "left", "r")

return M

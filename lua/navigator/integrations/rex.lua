local utils = require('navigator.utils')
local rex_config = require('navigator.integrations.rex_config')

local M = {}

M.get_session_id = function()
	return vim.env.REX_SESSION
end

---@param keys table<string, string>
---@return string|nil err
M.init = function(keys)
	local err = rex_config.sync(keys)
	if err then
		return "could not configure Rex: " .. err
	end
end

local function focus_pane(direction)
	utils.run({ "rex", "focus", direction, "--wrap" }, function(err)
		if err then
			vim.notify(err, vim.log.levels.ERROR)
		end
	end)
end

---@param direction string
---@param direction_key string
---@return fun()
local function create_handler(direction, direction_key)
	return function()
		if vim.fn.winnr(direction_key) ~= vim.fn.winnr() then
			vim.cmd("wincmd " .. direction_key)
			return
		end

		focus_pane(direction)
	end
end

M.focus_up_pane = create_handler("up", "k")
M.focus_down_pane = create_handler("down", "j")
M.focus_left_pane = create_handler("left", "h")
M.focus_right_pane = create_handler("right", "l")

return M

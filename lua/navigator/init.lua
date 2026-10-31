local focus_manager = require('navigator.focus_manager')
local macterm = require('navigator.integrations.macterm')
local rex = require('navigator.integrations.rex')
local utils = require('navigator.utils')
local navigator_config = require('navigator.config')

local M = {}

--- Configures Navigator integrations and key mappings.
---@param config? { keys?: table<string, string>, rex_path?: string }
function M.setup(config)
	config = navigator_config.setup(config)

	local terminal = utils.get_terminal_program()
	local navigator

	if terminal == "macterm" then
		navigator = macterm
	elseif terminal == "rex" then
		navigator = rex
	else
		return
	end

	local err = navigator.init(config.keys, config.rex_path)
	if err then
		vim.notify("Navigator: " .. err, vim.log.levels.ERROR)
		return
	end

	focus_manager.init(navigator)

	vim.keymap.set("n", config.keys.left, navigator.focus_left_pane, { desc = "Navigator: focus left pane" })
	vim.keymap.set("n", config.keys.right, navigator.focus_right_pane, { desc = "Navigator: focus right pane" })
	vim.keymap.set("n", config.keys.down, navigator.focus_down_pane, { desc = "Navigator: focus down pane" })
	vim.keymap.set("n", config.keys.up, navigator.focus_up_pane, { desc = "Navigator: focus up pane" })
end

return M

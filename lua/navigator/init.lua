local focus_manager = require('navigator.focus_manager')
local macterm = require('navigator.macterm')

local M = {}

local default_config = {
	keys = {
		left = "<C-h>",
		right = "<C-l>",
		down = "<C-j>",
		up = "<C-k>",
	},
}

function M.setup(config)
	config = vim.tbl_deep_extend("force", {}, default_config, config or {})

	focus_manager.init()
	vim.keymap.set("n", config.keys.left, macterm.focus_left_pane, { desc = "Navigator: focus left pane" })
	vim.keymap.set("n", config.keys.right, macterm.focus_right_pane, { desc = "Navigator: focus right pane" })
	vim.keymap.set("n", config.keys.down, macterm.focus_down_pane, { desc = "Navigator: focus down pane" })
	vim.keymap.set("n", config.keys.up, macterm.focus_up_pane, { desc = "Navigator: focus up pane" })
end

return M

local config = require('navigator.config')
local utils = require('navigator.utils')

local M = {}

local health_modules = {
	macterm = 'navigator.integrations.macterm.check',
	rex = 'navigator.integrations.rex.check',
}

function M.check()
	local terminal = utils.get_terminal_program()
	local health_module = health_modules[terminal]

	vim.health.start("neovim-navigator")

	if not health_module then
		vim.health.warn("No supported terminal integration detected")
		return
	end

	require(health_module).check(config.get())
end

return M

local M = {}

local empty = function() end

--- Returns the terminal program hosting Neovim.
---@return string|nil
M.get_terminal_program = function()
	if vim.env.REX_SESSION and vim.env.REX_BLOCK then
		return "rex"
	end

	if vim.env.MACTERM_SESSION then
		return "macterm"
	end

	return vim.env.TERM_PROGRAM
end

M.run = function(command_table, cb)
	assert(type(command_table) == "table", "run: command must be a table")

	local callback = cb or empty

	vim.system(command_table, { text = true }, function(result)
		if result.code ~= 0 then
			callback("Navigator: command failed: " .. result.stderr, nil)
			return
		end

		callback(nil, result.stdout)
	end)
end

print(M.get_terminal_program())

return M

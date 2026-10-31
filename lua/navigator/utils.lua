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

--- Runs a command asynchronously and passes its error or standard output to a callback.
---@param command_table string[]
---@param cb? fun(err: string|nil, output: string|nil)
M.run = function(command_table, cb)
	assert(type(command_table) == "table", "run: command must be a table")

	local callback = cb or empty

	local ok, err = pcall(vim.system, command_table, { text = true }, function(result)
		if result.code ~= 0 then
			callback("Navigator: command failed: " .. result.stderr, nil)
			return
		end

		callback(nil, result.stdout)
	end)

	if not ok then
		callback("Navigator: command failed: " .. tostring(err), nil)
	end
end

print(M.get_terminal_program())

return M

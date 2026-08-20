local M = {}

local empty = function() end

M.run = function(command_table, cb)
	assert(type(command_table) == "table", "run: command must be a table")

	local callback = cb or empty

	vim.system(command_table, { text = true }, function(result)
		if result.code ~= 0 then
			callback("Navigator: failed to focus MacTerm pane: " .. result.stderr, nil)
			return
		end

		callback(nil, result.stdout)
	end)
end


return M

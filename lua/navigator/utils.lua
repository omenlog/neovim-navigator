local M = {}

local empty = function() end

M.run = function(command, cb)
	local cmd = assert(command, "run: args.command is required")
	local command_table = {}

	local callback = cb or empty

	for word in cmd:gmatch("%S+") do
		table.insert(command_table, word)
	end

	vim.system(command_table, { text = true }, function(result)
		if result.code ~= 0 then
			callback("Navigator: failed to focus MacTerm pane: " .. result.stderr, nil)
			return
		end

		callback(nil, result.stdout)
	end)
end


return M

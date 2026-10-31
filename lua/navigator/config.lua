local M = {}

local defaults = {
	rex_path = "rex",
	keys = {
		left = "<C-h>",
		right = "<C-l>",
		down = "<C-j>",
		up = "<C-k>",
	},
}

local config = vim.tbl_deep_extend("force", {}, defaults)

---@param user_config? { keys?: table<string, string>, rex_path?: string }
---@return { keys: table<string, string>, rex_path: string }
function M.setup(user_config)
	config = vim.tbl_deep_extend("force", {}, defaults, user_config or {})
	return config
end

---@return { keys: table<string, string>, rex_path: string }
function M.get()
	return config
end

return M

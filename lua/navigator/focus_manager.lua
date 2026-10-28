local M = {}

local active_session_id

local group = vim.api.nvim_create_augroup("NavigatorFocusManager", {
	clear = true,
})

---@param navigator table
M.init = function(navigator)
	local function get_session_id()
		active_session_id = navigator.get_session_id()
	end

	vim.api.nvim_create_autocmd("FocusGained", {
		group = group,
		callback = get_session_id,
	})
	get_session_id()
end

M.get_active_session_id = function()
	return active_session_id
end

return M

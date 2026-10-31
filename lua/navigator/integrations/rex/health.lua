local M = {}

local function is_set(value)
	return value ~= nil and value ~= ""
end

local function rex_config_dir()
	local config_home = vim.env.XDG_CONFIG_HOME
	if not is_set(config_home) then
		config_home = vim.fn.expand("~/.config")
	end

	return vim.fs.joinpath(config_home, "rex")
end

---@param config { rex_path: string }
function M.check(config)
	local health = vim.health
	local executable = config.rex_path
	local config_dir = rex_config_dir()
	local navigator_path = vim.fs.joinpath(config_dir, "navigator.lua")
	local init_path = vim.fs.joinpath(config_dir, "init.lua")

	if vim.fn.executable(executable) == 1 then
		local resolved = vim.fn.exepath(executable)
		health.ok("Rex CLI: " .. (resolved ~= "" and resolved or executable))
	else
		health.error("Rex CLI not found: " .. executable, {
			"Make sure the configured Rex executable is available",
			"Set `rex_path` to the Rex executable's full path",
		})
	end

	if vim.fn.filereadable(navigator_path) == 1 then
		health.ok("Rex generated configuration exists")
	else
		health.error("Rex generated configuration is missing", {
			"Expected: " .. navigator_path,
		})
	end

	if vim.fn.filereadable(init_path) ~= 1 then
		health.error("Rex init.lua is missing", {
			"Expected: " .. init_path,
		})
		return
	end

	local init_content = table.concat(vim.fn.readfile(init_path), "\n")
	local loads_navigator = init_content:find('require("navigator")', 1, true)
		or init_content:find("require('navigator')", 1, true)

	if loads_navigator then
		health.ok("Rex init.lua loads navigator.lua")
	else
		health.error("Rex init.lua does not load navigator.lua", {
			'Add `require("navigator")` to ' .. init_path,
		})
	end
end

return M

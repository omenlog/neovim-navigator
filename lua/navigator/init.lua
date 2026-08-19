local utils = require('navigator.utils')
local focus_manager = require('navigator.focus_manager')
local navigation_handler = require('navigator.navigation_handler')

local M = {}

local function focus_up_pane()
	if vim.fn.winnr("k") ~= vim.fn.winnr() then
		vim.cmd("wincmd k")
		return
	end

	utils.run("macterm pane focus --direction up --json",
		navigation_handler.create_navigation_handler("down"))
end

local function focus_down_pane()
	if vim.fn.winnr("j") ~= vim.fn.winnr() then
		vim.cmd("wincmd j")
		return
	end

	utils.run("macterm pane focus --direction down --json",
		navigation_handler.create_navigation_handler("up"))
end


local function focus_left_pane()
	if vim.fn.winnr("h") ~= vim.fn.winnr() then
		vim.cmd("wincmd h")
		return
	end

	utils.run("macterm pane focus --direction left --json",
		navigation_handler.create_navigation_handler("right"))
end

local function focus_right_pane()
	if vim.fn.winnr("l") ~= vim.fn.winnr() then
		vim.cmd("wincmd l")
		return
	end

	utils.run("macterm pane focus --direction right --json",
		navigation_handler.create_navigation_handler("left")
	)
end

function M.setup()
	focus_manager.init()
	vim.keymap.set("n", "<C-h>", focus_left_pane, { desc = "Navigator: focus left pane" })
	vim.keymap.set("n", "<C-l>", focus_right_pane, { desc = "Navigator: focus right pane" })
	vim.keymap.set("n", "<C-j>", focus_down_pane, { desc = "Navigator: focus down pane" })
	vim.keymap.set("n", "<C-k>", focus_up_pane, { desc = "Navigator: focus up pane" })
end

return M

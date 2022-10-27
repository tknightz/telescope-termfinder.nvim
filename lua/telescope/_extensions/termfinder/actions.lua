local util = require('telescope._extensions.termfinder.util')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local toggleterm = require('toggleterm')
local terminal = require('toggleterm.terminal')
local transform_mod = require('telescope.actions.mt').transform_mod


local M = {}

local function open_term(prompt_bufnr, direction)
    local entry = action_state.get_selected_entry()
    if entry.id == nil then
        return
    end

    local term = terminal.get(entry.id)
    if vim.api.nvim_win_is_valid(term.window) then
        vim.api.nvim_win_hide(term.window)
    end
    term:change_direction(direction)
end

M.select_term = function(prompt_bufnr, start_to_insert)
    local entry = action_state.get_selected_entry()
    if entry.id == nil then
        return
    end
    actions.close(prompt_bufnr)

    local term = terminal.get(entry.id)
    if term == nil then
      return
    end

    if term:is_open() then
        vim.api.nvim_set_current_win(term.window)
    else
        -- toggleterm.toggle_all('close')
        term:open()
    end
    if start_to_insert then
      vim.api.nvim_input("i")
    end
end

M.rename_term = function(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    local new_name = vim.fn.input('Rename to: ')

    if new_name ~= "" then
      vim.api.nvim_buf_set_name(entry.bufnr, new_name)
      terminal.get(entry.id).name = new_name
    end
end

M.delete_term = function(prompt_bufnr)
    local term_id = action_state.get_selected_entry().id
    local term = terminal.get(term_id)
    term:shutdown()
end

M.open_term_vertical = function(prompt_bufnr)
    return open_term(prompt_bufnr, 'vertical')
end

M.open_term_horizontal = function(prompt_bufnr)
    return open_term(prompt_bufnr, 'horizontal')
end

M.open_term_float = function(prompt_bufnr)
    return open_term(prompt_bufnr, 'float')
end

return transform_mod(M)

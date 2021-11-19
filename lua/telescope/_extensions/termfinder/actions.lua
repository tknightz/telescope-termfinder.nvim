local util = require('telescope._extensions.termfinder.util')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local toggleterm = require('toggleterm')
local terminal = require('toggleterm.terminal')
local transform_mod = require('telescope.actions.mt').transform_mod


local M = {}

local function open_term(prompt_bufnr, direction)
    local entry = action_state.get_selected_entry()
    if not entry then
        return
    end

    local term = terminal.get(entry.id)
    --[[ if term:is_open() then
        term:close()
    end ]]
    if vim.api.nvim_win_is_valid(term.window) then
        vim.api.nvim_win_hide(term.window)
    end
    term:change_direction(direction)
end

M.select_term = function(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    if not entry then
        return
    end
    actions.close(prompt_bufnr)

    local term = terminal.get(entry.id)
    if term:is_open() then
        vim.api.nvim_set_current_win(term.window)
    else
        -- toggleterm.toggle_all('close')
        term:open()
    end
end

M.rename_term = function(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    local new_name = vim.fn.input('Rename to: ')
    
    vim.api.nvim_buf_set_name(entry.bufnr, new_name)
    terminal.get(entry.id).name = new_name
end

M.delete_term = function(prompt_bufnr)
    local term_id = action_state.get_selected_entry().id
    terminal.delete(term_id)
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

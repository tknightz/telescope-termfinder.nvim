local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require("telescope.actions.state")
local previewers = require('telescope.previewers')


local _util = require('telescope._extensions.termfinder.util')
local _finder = require('telescope._extensions.termfinder.finder')
local _actions = require('telescope._extensions.termfinder.actions')

local M = {}

local config = {
    start_to_insert = false,
    mappings = {
        rename_term = '<C-r>',
        delete_term = '<C-x>',
        vertical_term = '<C-v>',
        horizontal_term = '<C-h>',
        float_term = '<C-f>'
    }
}

M.setup = function(opts)
    if opts then
        config = vim.tbl_deep_extend("force", config, opts)
    end
end

M.termfinder = function(opts)
    local terms = _util.get_terms()
    local last_term = _util.get_last_term()

    pickers.new(opts, {
        prompt_title = "ToggleTerm",
        results_title = "Terms",
        sorter = conf.file_sorter(opts),
        finder = _finder.term_finder(opts, terms),
        previewer = conf.grep_previewer(opts),
        attach_mappings = function(prompt_bufnr, map)
            local on_term_selected = function()
                _actions.select_term(prompt_bufnr)
            end

            local refresh_terms = function()
                local picker = action_state.get_current_picker(prompt_bufnr)
                if not picker then
                  return
                end
                local finder = _finder.term_finder(opts, terms)
                picker:refresh(finder, { reset_prompt = true })
            end

            _actions.rename_term:enhance({ post = refresh_terms })
            _actions.delete_term:enhance({ post = refresh_terms })

            map('i', config.mappings.rename_term, _actions.rename_term)
            map('i', config.mappings.delete_term, _actions.delete_term)
            map('i', config.mappings.vertical_term, _actions.open_term_vertical)
            map('i', config.mappings.horizontal_term, _actions.open_term_horizontal)
            map('i', config.mappings.float_term, _actions.open_term_float)
            map('i', '<CR>', function(prompt_bufnr) _actions.select_term(prompt_bufnr, config.start_to_insert) end)

            -- actions.select_default:replace(on_term_selected)
            return true
        end,
        on_complete = {
            function(self)
                if #terms == 0 then return end

                local index = _util.get_selection_index(terms, last_term)
                -- set_selection expects a row index (1-based)
                self:set_selection(self:get_row(index))
            end,
        },
    }):find()
end

return M

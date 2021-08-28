local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require("telescope.actions.state")
local previewers = require('telescope.previewers')


local _util = require('telescope._extensions.termfinder.util')
local _finder = require('telescope._extensions.termfinder.finder')
local _actions = require('telescope._extensions.termfinder.actions')

local M = {}

M.setup = function(opts)
    if opts then
        config = vim.tbl_extend("force", conf, opts)
    end
end

M.termfinder = function(opts)
    pickers.new(opts, {
        prompt_title = "ToggleTerm",
        results_title = "Terms",
        sorter = conf.file_sorter(opts),
        finder = _finder.term_finder(opts, _util.get_terms()),
        previewer = previewers.display_content.new(opts),
        attach_mappings = function(prompt_bufnr, map)
            local on_term_selected = function()
                _actions.select_term(prompt_bufnr)
            end

            local refresh_terms = function()
                local picker = action_state.get_current_picker(prompt_bufnr)
                local finder = _finder.term_finder(opts, _util.get_terms())
                picker:refresh(finder, { reset_prompt = true })
            end

            _actions.rename_term:enhance({ post = refresh_terms })
            _actions.delete_term:enhance({ post = refresh_terms })

            map('i', '<c-n>', _actions.rename_term)
            map('i', '<c-x>', _actions.delete_term)
            map('i', '<c-v>', _actions.open_term_vertical)
            map('i', '<c-h>', _actions.open_term_horizontal)
            map('i', '<c-f>', _actions.open_term_float)

            actions.select_default:replace(on_term_selected)
            return true
        end,
    }):find()
end

return M

local finders = require('telescope.finders')
local entry_display = require('telescope.pickers.entry_display')
local previewer_utils = require('telescope.previewers.utils')


local M = {}

local function show_preview(entry, buf)
    local content = entry.content
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, content)
    previewer_utils.highlighter(buf, 'BufferCurrentTarget')

    vim.api.nvim_buf_call(buf, function()
        local win = vim.fn.win_findbuf(buf)[1]
        vim.wo[win].conceallevel = 2
        vim.wo[win].wrap = true
        vim.wo[win].linebreak = true
        vim.bo[buf].textwidth = 80
    end)
end

M.term_finder =  function(opts, terms)
    local displayer = entry_display.create({
        separator = " ",
        items = {
            { width = 40 },
            { width = 18 },
            { remaining = true },
        },
    })

    local make_display = function(entry)
        return displayer({
            entry.id .. "\t| " ..entry.name,
        })
    end

    return finders.new_table {
        results = terms,
        entry_maker = function(term)
            term.value = term.id
            term.ordinal = term.name
            term.display = make_display
            term.preview_command = show_preview
            return term
        end
    }
end


return M

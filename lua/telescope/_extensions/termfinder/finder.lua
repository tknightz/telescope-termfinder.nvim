local finders = require('telescope.finders')
local entry_display = require('telescope.pickers.entry_display')
local previewer_utils = require('telescope.previewers.utils')
local _util = require('telescope._extensions.termfinder.util')

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
            { width = 100 },
            { width = 17 },
            { remaining = true },
        },
    })

    local make_display = function(entry)
        return displayer({
            entry.id .. "\t| " ..entry.name .. "\t| " .. entry.term_cwd,
        })
    end

    return finders.new_table {
        results = terms,
        entry_maker = function(term)
            local term_title_parts = _util.str_split(vim.fn.getbufvar(term.bufnr, 'term_title'), ':')
            term.term_cwd = #term_title_parts > 1 and term_title_parts[2] or ''
            term.value = term.id
            term.ordinal = term.name .. term.term_cwd
            term.display = make_display
            term.preview_command = show_preview
            return term
        end
    }
end


return M

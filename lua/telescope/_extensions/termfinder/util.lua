local ok, toggleterm = pcall(require, 'toggleterm.terminal')

if not ok then
    vim.cmd [[PackerLoad nvim-toggleterm.lua]]
    toggleterm = require('toggleterm.terminal')
end

local M = {}

local function get_content_buf(bufnr)
    local content_table = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
    return content_table
end

M.get_terms = function()
    local terms_table = toggleterm.get_all()
    local terms = {}
    for _, term in pairs(terms_table) do
        table.insert(terms, {
            bufnr = term.bufnr,
            id = term.id,
            content = get_content_buf(term.bufnr),
            name = term.name,
        })
    end
    return terms
end

M.get_term_id_by_bufnr = function(bufnr)
    local terms = M.get_terms()
    for k, v in pairs(terms) do
        if v.bufnr == bufnr then
            return v.id
        end
    end
    return nil
end

M.str_split = function(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

return M

local has_telescope, telescope = pcall(require, 'telescope')
local main = require('telescope._extensions.termfinder.main')
local util = require('telescope._extensions.termfinder.util')


if not has_telescope then
    error('Require a Telescope plugin. Make sure you already installed it!')
end


return telescope.register_extension{
    setup = main.setup,
    exports = {
        termfinder = main.termfinder
    }
}

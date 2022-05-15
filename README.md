# telescope-termfinder.nvim

A telescope extension for searching your toggled terminals


# Get Started

Install [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) and [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) first.

Using packer

```lua
use {'nvim-telescope/telescope.nvim'}
use {'akinsho/toggleterm.nvim'}
use {'tknightz/telescope-termfinder.nvim'}
```

Load extension

```lua
require('telescope').load_extension("termfinder")
```

# Usage

```
:Telescope termfinder find
```


# Mappings

|Keys| Action|
|---|---|
|`<C-r>` | Rename terminal|
|`<C-x>` | Delete terminal|
|`<C-h>` | Change direction to horizontal|
|`<C-v>` | Change direction to vertical|
|`<C-f>` | Change direction to float|

# Custom mappings
```lua
-- in telescope's config file.
extensions = {
    termfinder = {
        mappings = {
            rename_term = '<C-n>',
            delete_term = '<C-x>',
            vertical_term = '<C-v>',
            horizontal_term = '<C-h>',
            float_term = '<C-f>'
        }
    }
}
```

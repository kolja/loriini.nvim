# loriini.nvim

This plugin lets you use the [loriini](github.com/kolja/loriini) color picker in Neovim.

## Installation

using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
    use {
        'kolja/loriini.nvim',
        cmd = 'Loriini',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require'loriini.nvim'.setup({
                bin = '/usr/local/loriini', -- path to loriini executable
            })
        end
    }
```

## Usage

```lua
    require'loriini.nvim'.pick()
```

## Configuration

set up keybindings:

```lua
    vim.keymap.set('n', 'L', function()
        require('loriini.nvim').pick()
      end,
      { desc = 'run loriini' })
```
## License 

MIT


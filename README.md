# loriini.nvim

This plugin lets you use the [loriini](https://github.com/kolja/loriini) color picker in Neovim.


https://github.com/kolja/loriini.nvim/assets/28293/0ef5bf83-e920-4320-a11a-df7e89041a78


## Installation

using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
    {
        'kolja/loriini.nvim',
        dependencies = { 
            'nvim-lua/plenary.nvim', 
            'NvChad/nvim-colorizer.lua'  -- optional
        },
        config = function()
            require'loriini'.setup({
                bin = '/usr/local/loriini', -- path to loriini executable
            })
        end
    }
```

## Usage

```lua
    require'loriini'.pick()
```

## Configuration

set up keybindings:

```lua
    vim.keymap.set('n', 'L', function()
        require('loriini').pick()
      end,
      { desc = 'run loriini' })
```

## License 

MIT


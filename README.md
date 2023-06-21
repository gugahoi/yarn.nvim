# yarn.nvim

An npm script runner for neovim.

## Installation

### Lazy.nvim

```lua
{
  "gugahoi/yarn.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("yarn").setup()
  end
}
```

## Features

- [x] list tasks
- [x] run task
- [ ] see output of tasks
- [ ] run task in neovim terminal

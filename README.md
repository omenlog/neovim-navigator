# navigator.nvim

Neovim plugin for moving focus between Neovim splits and
MacTerm panes with the same directional keybindings.

## Current behavior

The plugin maps these keys in normal mode:

| Key | Direction |
| --- | --- |
| `<C-h>` | Left |
| `<C-j>` | Down |
| `<C-k>` | Up |
| `<C-l>` | Right |

When a Neovim split exists in that direction, Navigator focuses that split.
Otherwise, it invokes the MacTerm CLI to focus the pane in that direction.

Navigator also tracks the MacTerm session containing Neovim when Neovim gains
focus. Focus commands return JSON, which the navigation handler uses to decide
whether a fallback focus command is needed.

## Requirements

- Neovim >= 0.10.0
- [MacTerm](https://github.com/o-lopez/macterm) installed and the `macterm`
  command available in `$PATH`

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "omenlog/neovim-navigator",
  config = function()
    require("navigator").setup()
  end,
}
```

With [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use({
  "omenlog/neovim-navigator",
  config = function()
    require("navigator").setup()
  end,
})
```

## Setup

After installing the plugin with your preferred plugin manager:

```lua
require("navigator").setup()
```

### Key mappings

The default mappings can be overridden per direction:

```lua
require("navigator").setup({
  keys = {
    left = "<A-h>",
    down = "<A-j>",
    up = "<A-k>",
    right = "<A-l>",
  },
})
```

Omitted keys keep their defaults.

## MacTerm configuration

Navigator mappings are handled by Neovim. Ensure MacTerm does not bind
`<C-h>`, `<C-j>`, `<C-k>`, or `<C-l>` to its own pane-navigation commands; the
keys must be passed through to the terminal process. Alternatively, configure
different Navigator mappings in `setup()`.

## Troubleshooting

If pane navigation does not work, verify that Neovim can find the MacTerm CLI:

```vim
:!macterm pane inspect --json
```

If this command fails, ensure `macterm` is installed and available in the
`$PATH` inherited by Neovim.

# navigator.nvim

A work-in-progress Neovim plugin for moving focus between Neovim splits and
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

- Neovim with `vim.system` and `vim.json.decode` support
- [MacTerm](https://github.com/o-lopez/macterm) installed and the `macterm`
  command available in `$PATH`

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

## Status

This plugin is a WIP. The focus behavior and public API may change, and it does
not yet have configuration options or automated tests.

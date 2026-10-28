# navigator.nvim

Neovim plugin for moving focus between Neovim splits and
MacTerm or Rex panes with the same directional keybindings.

## Current behavior

The plugin maps these keys in normal mode:

| Key | Direction |
| --- | --- |
| `<C-h>` | Left |
| `<C-j>` | Down |
| `<C-k>` | Up |
| `<C-l>` | Right |

When a Neovim split exists in that direction, Navigator focuses that split.
Otherwise, it invokes the CLI for the detected terminal host to focus the pane
in that direction. Rex navigation wraps at the edge of a layout.

Navigator tracks the MacTerm session containing Neovim when Neovim gains
focus. MacTerm focus commands return JSON, which the navigation handler uses
to decide whether a fallback focus command is needed.

## Requirements

- Neovim >= 0.10.0
- One supported terminal host:
  - [MacTerm](https://github.com/thdxg/macterm) installed and the `macterm`
    command available in `$PATH`
  - [Rex](https://www.superlogical.com/rex/) installed the `rex` command is
    added to `$PATH` automatically in Rex terminals)

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
    left = "<C-h>",
    down = "<C-j>",
    up = "<C-k>",
    right = "<C-l>",
  },
})
```

Omitted keys keep their defaults.

## Terminal integrations

Navigator selects an integration from the terminal environment: MacTerm when
`MACTERM_SESSION` is present, or Rex when both `REX_SESSION` and `REX_BLOCK`
are present.

### MacTerm

The MacTerm integration is handled entirely from Neovim. Each mapping first
checks for a Neovim split in the requested direction. At a split edge it runs
`macterm pane focus --direction DIRECTION --json`.

Navigator records the session containing Neovim with `macterm pane inspect
--json` whenever Neovim gains focus. If the directional command leaves focus
in that same session, Navigator issues the opposite directional command. This
provides wrap-like navigation at a MacTerm layout edge.

Ensure MacTerm does not bind Navigator's keys to its own pane-navigation
commands: the keys must reach Neovim. Alternatively, configure different
Navigator mappings in `setup()`.

### Rex

Rex navigation has two coordinated parts:

1. **Neovim integration.** As with MacTerm, a mapping first moves to an
   adjacent Neovim split. At a split edge it runs
   `rex focus DIRECTION --wrap`, which moves to a Rex block and wraps at the
   layout edge.
2. **Rex integration.** Rex must handle the same keys while the terminal is
   not running Neovim, and pass them to Neovim while it is. Navigator generates
   this Rex-side behavior automatically.

When setup runs inside Rex, Navigator creates
`~/.config/rex/navigator.lua` and adds this loader to
`~/.config/rex/init.lua` when needed:

```lua
-- Load navigator.nvim's generated conditional pane bindings.
require("navigator")
```

The generated file binds the configured keys. For each key, it checks whether
`nvim` is the foreground process. If so, it returns `false` so Neovim receives
the key. Otherwise, Rex calls `rex.session.focus_direction` with `wrap = true`.

Navigator owns `navigator.lua`. It stores a hash of `setup().keys` in that
file. A later setup with changed keys deletes and regenerates the file, then
reloads Rex configuration; an unchanged hash does nothing. Remove matching
shortcuts from the Rex app's **Change Shortcut...** menu, because app-level
shortcuts take precedence over generated configuration.

## Troubleshooting

### MacTerm

Verify that Neovim can find the MacTerm CLI:

```vim
:!macterm pane inspect --json
```

If this command fails, ensure `macterm` is installed and available in the
`$PATH` inherited by Neovim.

### Rex

Verify that Neovim was started inside Rex and can find the Rex CLI:

```vim
:echo $REX_SESSION
:echo $REX_BLOCK
:!rex config reload
```

Both environment variables must be non-empty. Also verify that the generated
`navigator.lua` and its `require("navigator")` loader are present under Rex's
configuration directory. If Rex shortcuts still take precedence, remove the
matching shortcuts from Rex's **Change Shortcut...** menu.

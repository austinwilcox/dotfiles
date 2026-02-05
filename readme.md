# Dotfiles
Here are my dotfiles containing the config for neovim, leftwm, tmux, bash, alacritty and a couple of other small configs

## Stow
I use stow to place all these files in the correct location with symlinks, the commands are:
```bash
stow .
```
and
```bash
stow -D .
```
to delete those symlinks

## Aerospace Commands
  Basic Navigation (Cmd + vim keys)
  ┌────────────┬────────────────────┐
  │ Keybinding │       Action       │
  ├────────────┼────────────────────┤
  │ Cmd + h    │ Focus window left  │
  ├────────────┼────────────────────┤
  │ Cmd + j    │ Focus window down  │
  ├────────────┼────────────────────┤
  │ Cmd + k    │ Focus window up    │
  ├────────────┼────────────────────┤
  │ Cmd + l    │ Focus window right │
  └────────────┴────────────────────┘
  Moving Windows
  ┌─────────────────┬───────────────────┐
  │   Keybinding    │      Action       │
  ├─────────────────┼───────────────────┤
  │ Cmd + Shift + h │ Move window left  │
  ├─────────────────┼───────────────────┤
  │ Cmd + Shift + j │ Move window down  │
  ├─────────────────┼───────────────────┤
  │ Cmd + Shift + k │ Move window up    │
  ├─────────────────┼───────────────────┤
  │ Cmd + Shift + l │ Move window right │
  └─────────────────┴───────────────────┘
  Workspaces
  ┌──────────────────────┬───────────────────────────────┐
  │      Keybinding      │            Action             │
  ├──────────────────────┼───────────────────────────────┤
  │ Cmd + 1-9, 0         │ Switch to workspace 1-10      │
  ├──────────────────────┼───────────────────────────────┤
  │ Cmd + Shift + 1-9, 0 │ Move window to workspace 1-10 │
  └──────────────────────┴───────────────────────────────┘
  Layout & Splits
  ┌─────────────────────┬──────────────────────────────────────┐
  │     Keybinding      │                Action                │
  ├─────────────────────┼──────────────────────────────────────┤
  │ Cmd + \             │ Split horizontal                     │
  ├─────────────────────┼──────────────────────────────────────┤
  │ Cmd + -             │ Split vertical                       │
  ├─────────────────────┼──────────────────────────────────────┤
  │ Cmd + f             │ Toggle fullscreen                    │
  ├─────────────────────┼──────────────────────────────────────┤
  │ Cmd + e             │ Toggle split orientation             │
  ├─────────────────────┼──────────────────────────────────────┤
  │ Cmd + s             │ Stacking layout (vertical accordion) │
  ├─────────────────────┼──────────────────────────────────────┤
  │ Cmd + w             │ Tabbed layout (horizontal accordion) │
  ├─────────────────────┼──────────────────────────────────────┤
  │ Cmd + Shift + Space │ Toggle floating                      │
  └─────────────────────┴──────────────────────────────────────┘
  Other
  ┌─────────────────┬────────────────────────────────────────────────┐
  │   Keybinding    │                     Action                     │
  ├─────────────────┼────────────────────────────────────────────────┤
  │ Cmd + Enter     │ Open new terminal                              │
  ├─────────────────┼────────────────────────────────────────────────┤
  │ Cmd + Shift + c │ Reload config                                  │
  ├─────────────────┼────────────────────────────────────────────────┤
  │ Cmd + r         │ Enter resize mode (then use hjkl, Esc to exit) │
  └─────────────────┴────────────────────────────────────────────────┘
  Run aerospace reload-config or press Cmd + Shift + c to apply the changes.


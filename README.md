# Dotfiles

## Tmux cheatsheet
tells me if tmux is running
```
pgrep tmux
```

tells me the number of sessions running
```
tmux ls
```

Creates a new session called code from within a session
```
tmux new-session -d -s "code" -A
```

Switch clients
```
tmux switch-client -t "code"
```

killall tmux instances
```
tmux kill-server
```

Create a new tmux window
```
tmux neww -n "helloworld"
```

gives a list of all windows
```
ctrl+a w
```

type this command 
```
ctrl+a x
```

create a new window, execute ls, and then close that window
```
tmux neww -n "hello world" "ls"
```

Create a new blank window with keybindings
```
ctrl+b c
```

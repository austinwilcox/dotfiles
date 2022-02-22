#!/bin/sh
tmux new-session -d -s GoKanban
tmux rename-window server
tmux send "cd ~/Software/go-kanban && go run ." C-m
tmux neww -n 'Code'
tmux send "cd ~/Software/go-kanban && air" C-m
tmux a

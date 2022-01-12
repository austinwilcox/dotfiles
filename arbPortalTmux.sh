#!/bin/sh
tmux new-session -d -s ArbPortal
tmux rename-window server
tmux send "cd ~/Software/arbinger/server/ArbingerAPI/ && dotnet watch run" C-m
tmux neww -n "client"
tmux send "cd ~/Software/arbinger/portal/ && npm run start" C-m
tmux neww -n "client:gulp"
tmux send "cd ~/Software/arbinger/portal/ && npm run watch:styles" C-m
tmux neww -n 'react'
tmux send "cd ~/Software/arbinger/portal/src/ && nvim ." C-m
tmux neww -n 'dotnet'
tmux send "cd ~/Software/arbinger/server/ArbingerAPI/ && nvim ." C-m
tmux a

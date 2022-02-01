#!/bin/sh
tmux new-session -d -s SWD
tmux rename-window server
tmux send "cd ~/Software/secondswebdev/server/ && npm run devstart" C-m
tmux neww -n "client"
tmux send "cd ~/Software/secondswebdev/client-nuxt/ && npm run dev" C-m
tmux neww -n "client:gulp"
tmux send "cd ~/Software/secondswebdev/client-nuxt/ && npm run watch:styles" C-m
tmux neww -n 'nuxt'
tmux send "cd ~/Software/secondswebdev/client-nuxt/ && nvim ." C-m
tmux neww -n 'express'
tmux send "cd ~/Software/secondswebdev/server/ && nvim ." C-m
tmux a

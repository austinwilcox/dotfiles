#!/bin/sh
tmux new-session -d -s UnitTests
tmux rename-window runner
tmux send "cd ~/Software/arbinger/server/UnitTests/" C-m
tmux neww -n "project"
tmux send "cd ~/Software/arbinger/server/UnitTests/ && nvim ." C-m
tmux a

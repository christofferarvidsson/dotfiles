#!/usr/bin/env bash

options=("doom\nnondoom\nnull")
selected=$(echo -e $options | rofi -dmenu -p "Emacs profile")

~/.config/scripts/emacs_server.sh -s $selected


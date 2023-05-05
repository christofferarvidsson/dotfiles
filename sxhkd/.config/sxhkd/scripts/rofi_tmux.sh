#!/usr/bin/env bash

:<<doc
This is a bash script that launches a Rofi prompt to allow the
user to select an existing or new tmux session to attach to in a new
terminal window. If the selected session is existing, the script
attaches to it; otherwise, it loads a tmuxp layout.

Usage:
./tmux-selector.sh

The script performs the following steps:

    Reads all open tmux sessions and generates a list of session names.
    Reads all tmuxp layouts to the session list under a (new) name.
    Launches a Rofi prompt to allow the user to select a tmux session.
    If the user selects an existing session, the script attaches to it in a new terminal window.
    If the user selects a new session, the script loads up a tmuxp layout with that name.

The script uses the following external tools:

    tmux (to list and handle sessions)
    tmuxp (to list and load layouts)
    rofi (to prompt the user for a session selection)
    kitty (to launch new terminal windows)
doc

# Read open tmux sessions and generate a list of session names
sessions=$(tmux list-sessions -F "#S" 2>/dev/null)
layouts=$(tmuxp ls)

while read layout; do
    if [[ ! "${sessions[*]}" =~ "$layout" ]]; then
        sessions+="\n$layout (new)"
    fi
done <<< "$layouts"

# Launch Rofi and prompt the user to select a session
selected_session=$(echo -e "$sessions" | rofi -dmenu -p "Select a tmux session")

# Check if the user selected a session
if [[ -n "$selected_session" ]]; then
    name=${selected_session% (new)}
    if [[ "$name" =~ "$selected_session" ]]; then
        # Attach to the selected tmux session in a new terminal window
        kitty -e tmux new-session -A -s "$selected_session" &
    else
        # Load up tmuxp layout
        kitty -e tmuxp load $name --yes &
    fi
fi

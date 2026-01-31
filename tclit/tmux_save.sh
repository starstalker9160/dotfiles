#!/usr/bin/env bash

# Directory to store tmux session states
STATE_DIR="$HOME/.starstalker9160/tmux_states"
mkdir -p "$STATE_DIR"

# Get current session name
SESSION_NAME=$(tmux display-message -p '#S')
STATE_FILE="$STATE_DIR/$SESSION_NAME"

# Start fresh state file
: > "$STATE_FILE"

# Save each window and pane
tmux list-windows -t "$SESSION_NAME" -F '#I:#W:#F' | while IFS=: read -r win_idx win_name flags; do
    echo "window_index:$win_idx" >> "$STATE_FILE"
    echo "window_name:$win_name" >> "$STATE_FILE"

    # List panes in this window
    tmux list-panes -t "$SESSION_NAME:$win_idx" -F '#P:#{pane_current_path}:#{pane_current_command}' | while IFS=: read -r pane_idx pane_path pane_cmd; do
        echo "pane_index:$pane_idx" >> "$STATE_FILE"
        echo "pane_cwd:$pane_path" >> "$STATE_FILE"
        echo "pane_cmd:$pane_cmd" >> "$STATE_FILE"
    done

    # Save layout for window
    layout=$(tmux list-windows -t "$SESSION_NAME" -F '#{window_index}:#{window_layout}' | grep "^$win_idx:" | cut -d: -f2)
    echo "layout:$layout" >> "$STATE_FILE"
done

# Save current active window
ACTIVE_WINDOW=$(tmux display-message -p '#I')
echo "active_window:$ACTIVE_WINDOW" >> "$STATE_FILE"

echo "Saved tmux session '$SESSION_NAME' to $STATE_FILE"


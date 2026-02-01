#!/usr/bin/env bash

# CAUTION
# this is from chatgpt, i dont trust it

STATE_DIR="$HOME/.starstalker9160/tmux_states"

# Iterate over each saved session file
for STATE_FILE in "$STATE_DIR"/*; do
    SESSION_NAME=$(basename "$STATE_FILE")

    # Skip if session already exists
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        echo "Session $SESSION_NAME already exists, skipping..."
        continue
    fi

    echo "Restoring session: $SESSION_NAME"

    # Create detached session (first window automatically created)
    tmux new-session -d -s "$SESSION_NAME"

    CURRENT_WIN=""
    FIRST_WINDOW_CREATED=false

    while read -r line; do
        case "$line" in
            window_index:*)
                WIN_IDX="${line#window_index:}"
                if [ "$FIRST_WINDOW_CREATED" = true ]; then
                    # Create new window at correct index
                    tmux new-window -t "$SESSION_NAME:$WIN_IDX" -d
                else
                    FIRST_WINDOW_CREATED=true
                fi
                CURRENT_WIN="$WIN_IDX"
                ;;
            window_name:*)
                WIN_NAME="${line#window_name:}"
                tmux rename-window -t "$SESSION_NAME:$CURRENT_WIN" "$WIN_NAME"
                ;;
            pane_index:*)
                PANE_IDX="${line#pane_index:}"
                # First pane exists by default in 1-based indexing
                if [ "$PANE_IDX" -ne 1 ]; then
                    tmux split-window -t "$SESSION_NAME:$CURRENT_WIN" -d
                fi
                ;;
            pane_cwd:*)
                PANE_CWD="${line#pane_cwd:}"
                tmux send-keys -t "$SESSION_NAME:$CURRENT_WIN.$PANE_IDX" "cd $PANE_CWD" C-m
                ;;
            pane_cmd:*)
                PANE_CMD="${line#pane_cmd:}"
                # Avoid sending shell if empty or default shell
                if [ -n "$PANE_CMD" ] && [ "$PANE_CMD" != "zsh" ] && [ "$PANE_CMD" != "bash" ]; then
                    tmux send-keys -t "$SESSION_NAME:$CURRENT_WIN.$PANE_IDX" "$PANE_CMD" C-m
                fi
                ;;
            layout:*)
                LAYOUT="${line#layout:}"
                tmux select-layout -t "$SESSION_NAME:$CURRENT_WIN" "$LAYOUT"
                ;;
            active_window:*)
                ACTIVE_WIN="${line#active_window:}"
                tmux select-window -t "$SESSION_NAME:$ACTIVE_WIN"
                ;;
        esac
    done < "$STATE_FILE"

    # Detach session to keep it in the background
    tmux detach -s "$SESSION_NAME"
done


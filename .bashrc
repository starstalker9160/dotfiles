#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

export HYPRSHOT_DIR="$HOME/Pictures/Screenshots/"
export PATH="$HOME/.local/bin:$PATH"
export NOTES_DIR="$HOME/notes/"

# ----- NOTE -----
alias oo='cd $NOTES_DIR/notes/ && nvim && cd - >/dev/null'

# ----- ALIAS -----
alias grep='grep --color=auto'
alias cat='bat --color=always'
alias v='nvim'

# ----- TMUX -----
alias t='tmux'
alias ta='tmux a'

# ----- LS -----
alias ls='ls --color=auto'
alias la='ls -la --color=auto'

# ----- GIT -----
alias gc='git clone'
alias gs='git status'

alias gd='batdiff'

# ----- FZF -----
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons=always {} | head -200'"

_fzf_compgen_path() {
	fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
	fd --type=d --hidden --exclude .git . "$1"
}

# ----- FUNCS -----
batdiff() {
    git diff --name-only --relative --diff-filter=d -z | xargs -0 bat --diff
}

ll() {
	eza --level "${1:-1}" --color=always --color-scale=all --icons=always --tree
}


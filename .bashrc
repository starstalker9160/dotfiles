#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias cat='bat --color=always'
alias v='nvim'

export HYPRSHOT_DIR=~/Pictures/Screenshots/

# ----- LS -----
alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias ll='eza --level 1 --color=always --color-scale=all --icons=always --tree'

# ----- GIT -----
alias gc='git clone'
alias gd='git diff'

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


set -g fish_greeting ""

alias v nvim
alias z zeditor
alias ls "eza --color always --git --icons always"

starship init fish | source
fzf --fish | source
zoxide init --cmd cd fish | source


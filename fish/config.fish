
set -g fish_greeting ""
set -gx EDITOR nvim
set -g fish_key_bindings fish_vi_key_bindings

alias v nvim
alias z zeditor
alias ls "eza --color always --git --icons always"

starship init fish | source
fzf --fish | source
zoxide init --cmd cd fish | source


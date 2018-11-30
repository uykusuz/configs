# vim: set syntax-fish
fish_vi_key_bindings

# -----------------------------------------------------------------------------
# --- paths ---

set -x PATH $PATH ~/bin
set -x JAVA_HOME (readlink -f /usr/bin/java | sed 's:/bin/java::')

# -----------------------------------------------------------------------------
# --- aliases ---

alias ll='ls -alhF'
alias la='ls -A'
alias ..='cd ..'

alias tl='tar --exclude="*/*/*" -tf'

alias v='vim -c "NERDTree | wincmd w"'
alias gv='gvim -c "NERDTree | wincmd w"'
alias vd='gvim +Gvdiff'

alias gs='git status'
alias gg='git gui&'
alias gk='gitk --all&'

alias pms='pacman -Ss'
alias pmi='sudo pacman -S'

# grep: case-insensitive, ignore binaries, print filename, recursive, print line numbers
alias gr='grep -iIsrn'

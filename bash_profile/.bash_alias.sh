# #!/bin/bash
# source /Users/luizzulian/Documents/git/Configurations/scripts/bash_loading_animations.sh

# Remove warning messag
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# Vim configs
alias vi='nvim'
alias fzfvim='nvim $(fzf -m --preview "bat --color=always {}")'
alias v="~/Documents/git/Configurations/scripts/launcher.sh"
EDITOR=nvim

# fzf configuration
source <(fzf --zsh)

# Zoxide configuration
eval "$(zoxide init zsh)"

# starship configuration
# eval "$(starship init bash)"

# Show some information about the system
nerdfetch

alias node_modules_locator='find . -name "node_modules" -type d -prune -print | xargs du -chs'
alias node_modules_remover='find . -name "node_modules" -type d -prune -print -exec rm -rf "{}" \;'

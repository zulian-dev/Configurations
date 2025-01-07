# #!/bin/bash

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

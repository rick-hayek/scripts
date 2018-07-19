# Navigating
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias home='cd ~'
alias video='cd ~/Videos'
alias desktop='cd ~/Desktop'
alias download='cd ~/Downloads'
alias document='cd ~/Documents'
alias music='cd ~/Music'

# git shortcut
alias gadd='git add'
alias gaddall='git add -A'
alias gcommit='git commit -am'
alias gpull='git pull'
alias gpush='git push'

# Commands
alias restart='sudo shutdown -r now'
alias s='sudo'
alias x='exit'
alias lock='sudo gnome-screensave-command --lock'

# Manage packages
alias agi='sudo apt-get install'
alias agr='sudo apt-get autoremove'
alias agu='sudo apt-get update'

# EOS command
alias eos='cd ~/eos'
alias eosny='cleos -u http://api.eosnewyork.io'
alias eosram='cleos -u http://api.eosnewyork.io get table eosio eosio rammarket'
alias eosconfig='cd ~/.local/share/eosio/nodeos/config'

# File management
# Remove directory, use with caution
alias rd='rm -r'

alias mv='mv -iv'
alias la='ls -alh'

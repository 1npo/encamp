# for managing ZSH config
alias zsrc="source $HOME/.zshrc"
# alias zedit="nvim $(ls -d ~/.zsh/config/* | fzf)"

alias ls="ls -F --color=auto --group-directories-first"
alias ll="ls -l"
alias la="ls -A"
alias lla="ll -A"

alias grep="grep --color=auto"
alias tmux="TERM=\"screen-256color\" tmux -2"
alias plantuml='java -Djava.awt.headless=true -jar ~/.local/bin/plantuml.jar'

alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias 256c='for code in {000..255}; do print -P -- "$code: %F{$code}Color%f"; done'

alias nordvpn-server='curl --silent "https://api.nordvpn.com/v1/servers/recommendations" | jq --raw-output ".[].hostname" | head -n1'
alias nordvpn-creds='pass nordvpn/user && pass nordvpn/pass'

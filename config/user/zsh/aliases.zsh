alias zsrc="source $HOME/.zshrc"
alias ze-alias="$EDITOR $HOME/.zsh/rc/aliases"
alias ze-env="$EDITOR $HOME/.zsh/rc/env"
alias ze-function="$EDITOR $HOME/.zsh/rc/functions"
alias ze-prompt="$EDITOR $HOME/.zsh/rc/prompt"

alias ls="ls -F --color=auto"
alias ll="ls -l"
alias la="ls -A"
alias lla="ll -A"

alias grep="grep --color=auto"
alias tmux="TERM="screen-256color" tmux -2"
alias note="$EDITOR $HOME/notes/\`date +%Y%b%d-%k%M\`"
alias nano="nano -$ -c"

alias ergaleio="wmctrl -i -r `xdotool getactivewindow` -e 0,62,117,1465,904 && ssh -CX -lnick ergaleio"

alias mssh="eval "$(ssh-agent -s)"; ssh-add ~/.ssh/id_ergaleio"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

alias mprint="lpr -P Canon-LBP151-UFRII-LT -o sides=two-sided-long-edge /mnt/net/ergaleio/w/cmg/work/model.pdf"

alias mnt-ergaleio="sudo mount -t cifs -o rw,credentials=/home/nick/.smbcredentials,uid=1000,gid=1000 //ergaleio/nick /mnt/ergaleio"
alias mnt-trapezi="sudo mount -t cifs -o rw,credentials=/home/nick/.smbcredentials,uid=1000,gid=1000 //192.168.1.5/Downloads /mnt/trapezi"
alias ssh-agent-ergaleio="eval \"$(ssh-agent -a ~/.ssh/sock_ergaleio.sock)\" && ssh-add ~/.ssh/id_ergaleio"


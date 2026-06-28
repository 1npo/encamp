echo "Welcome to...\n"
figlet -d $HOME/.local/share/figlet -f Nancyj $(hostname)
echo
uname -a
echo
uptime
echo
echo "Current user services:\n"
systemctl --user list-units --all --type=service,timer
echo
echo "Current user sessions:\n"
loginctl
echo
who
echo

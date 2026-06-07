touch $HOME/.dbusenv
chmod 600 $HOME/.dbusenv
env | grep DBUS_SESSION_BUS_ADDRESS > $HOME/.dbusenv
echo 'export DBUS_SESSION_BUS_ADDRESS' >> $HOME/.dbusenv

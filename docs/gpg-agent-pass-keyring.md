# Set up keyring with pass as a backend on a headless Linux server

## 1. Install pass

```
sudo apt install pass
```

## 1. Create a new GPG key (if you don't already have one)

```
gpg --full-generate-key
```

## 1. Initialize a new password store

```
pass init <your-gpg-key-id>
```

## 1. Install keyring and keyring_pass

```
pip install keyring keyring-pass
```

## 1. Find keyring config path

```
keyring diagnose
```

## 1. Configure keyring to use keyring_pass

In your keyring config file:
```
[backend]
default-keyring = keyring_pass.PasswordStoreBackend
```

## 1. Configure gpg-agent

~/.gnupg/gpg-agent.conf:
```
default-cache-ttl 86400 # 24 hrs
maximum-cache-ttl 86400 # 24 hrs
pinentry-timeout 0
pinentry-program /usr/bin/pinentry-tty
```

## 1. Create a systemd user service for starting gpg-agent

~/.config/systemd/user/gpg-agent.service:
```
[Unit]
Description=User GPG Agent
IgnoreOnIsolate=True

[Service]
Type=forking
ExecStart=/usr/bin/gpg-agent --pinentry-program=/usr/bin/pinentry-tty --daemon
Restart=on-abort

[Install]
WantedBy=default.target
```

## 1. Start the service

```
systemctl --user start gpg-agent
```

## 1. Do something that asks for your GPG key password

```
pass generate test
pass test
```

Enter password when prompted. GPG Agent will remember your key for 24 hours, regardless of which terminal you use.

# Setting up `socat` to forward `protonmail-bridge` SMTP to `diatom`

## Assumptions

- `protonmail-bridge` is already installed and running on `globule`, listening on `127.0.0.1:1025`
- Both machines are on the same LAN; `globule`'s LAN IP is referred to below as `GLOBULE_LAN_IP` — substitute your actual IP throughout
- You have `sudo` access on both machines

---

## On `globule`

### 1. Install socat

```bash
sudo apt update && sudo apt install -y socat
```

### 2. Install ufw and restrict access to the forwarded port

```bash
sudo apt install -y ufw

# Allow SSH first so you don't lock yourself out
sudo ufw allow ssh

# Allow SMTP forwarding port only from diatom
sudo ufw allow from DIATOM_LAN_IP to any port 1025 proto tcp

sudo ufw enable
```

### 3. Create a systemd service for socat

```bash
sudo tee /etc/systemd/system/socat-protonbridge.service > /dev/null <<EOF
[Unit]
Description=socat forward for protonmail-bridge SMTP
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/socat TCP-LISTEN:1025,bind=GLOBULE_LAN_IP,fork,reuseaddr TCP:127.0.0.1:1025
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

### 4. Enable and start the service

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now socat-protonbridge
```

### 5. Verify it's listening

```bash
sudo ss -tlnp | grep 1025
```

You should see socat listening on `GLOBULE_LAN_IP:1025`.

---

## On `diatom`

### 6. Verify connectivity

```bash
sudo apt update && sudo apt install -y telnet

telnet GLOBULE_LAN_IP 1025
```

You should get an SMTP banner from `protonmail-bridge` (something like `220 127.0.0.1 ESMTP`). Type `quit` to exit.

### 7. Install a mail sending utility for the cronjob

`msmtp` is a lightweight SMTP client well-suited for this:

```bash
sudo apt install -y msmtp msmtp-mta
```

### 8. Configure msmtp

Get your ProtonMail Bridge SMTP credentials from the bridge UI on `globule` first (the bridge generates its own password). Then create the config:

```bash
sudo tee /etc/msmtprc > /dev/null <<EOF
defaults
auth           on
tls            off
logfile        /var/log/msmtp.log

account        protonbridge
host           GLOBULE_LAN_IP
port           1025
from           you@proton.me
user           you@proton.me
password       YOUR_BRIDGE_PASSWORD

account default : protonbridge
EOF

sudo chmod 600 /etc/msmtprc
```

> **Note on TLS:** `protonmail-bridge` uses STARTTLS on port 1025 with a self-signed certificate. If `msmtp` rejects the connection due to certificate verification, add `tls on`, `tls_starttls on`, and `tls_trust_file /etc/ssl/certs/ca-certificates.crt` to the account block — but you may also need to export and trust the bridge's certificate. The simplest starting point on a trusted LAN is `tls off`; the traffic doesn't leave your local network.

### 9. Test sending an email

```bash
echo "Subject: Test from diatom" | msmtp recipient@example.com
```

Check `/var/log/msmtp.log` if anything goes wrong.

### 10. Set up the cronjob

```bash
sudo crontab -e
```

Add a line like:

```cron
0 7 * * * /path/to/your/script.sh 2>&1 | msmtp recipient@example.com
```

Or if your script sends mail internally using `sendmail` (which `msmtp-mta` provides as a drop-in), it will automatically use the `msmtp` config you set up.

---

## Troubleshooting

| Symptom | Check |
|---|---|
| `socat` not listening | `sudo systemctl status socat-protonbridge` |
| Connection refused from `diatom` | `sudo ufw status` on `globule`; verify `DIATOM_LAN_IP` is correct |
| SMTP auth failure | Double-check bridge password in bridge UI on `globule` |
| Logs | `journalctl -u socat-protonbridge -f` on `globule`; `/var/log/msmtp.log` on `diatom` |
#  Groups 
sudo groupadd -f admin
sudo groupadd -f auditor
sudo groupadd -f automation
sudo groupadd -f vaultwarden
sudo groupadd -f user

# Users 
sudo useradd -m -s /bin/bash admin1 || true
sudo useradd -m -s /bin/bash auditor1 || true
sudo useradd -m -s /bin/bash autobot || true
sudo useradd -m -s /bin/bash vw || true
sudo useradd -m -s /bin/bash user1 || true

#  Group membership
sudo usermod -aG admin admin1
sudo usermod -aG auditor auditor1
sudo usermod -aG automation autobot
sudo usermod -aG vaultwarden vw
sudo usermod -aG user user1

# Directories 
sudo mkdir -p /var/lib/vaultwarden /var/log/vaultwarden /var/backups
sudo chown -R vw:vaultwarden /var/lib/vaultwarden /var/log/vaultwarden
sudo chmod 750 /var/lib/vaultwarden /var/log/vaultwarden
sudo chown -R autobot:automation /var/backups
sudo chmod 750 /var/backups

# sudoers
echo 'admin1 ALL=(ALL) ALL' | sudo tee /etc/sudoers.d/99-admin1 >/dev/null
echo 'autobot ALL=(ALL) NOPASSWD: /usr/bin/rsync, /usr/bin/tar' | sudo tee /etc/sudoers.d/50-autobot >/dev/null
sudo visudo -cf /etc/sudoers.d/99-admin1 && sudo visudo -cf /etc/sudoers.d/50-autobot

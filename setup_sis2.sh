#!/bin/bash
# SIS2 Setup Script
sudo groupadd admin auditor automation vaultwarden user
for u in admin1 auditor1 autobot vw user1; do sudo useradd -m -s /bin/bash $u; done
sudo usermod -aG admin admin1
sudo usermod -aG auditor auditor1
sudo usermod -aG automation autobot
sudo usermod -aG vaultwarden vw
sudo usermod -aG user user1
sudo mkdir -p /var/lib/vaultwarden /var/log/vaultwarden /var/backups
sudo chown -R vw:vaultwarden /var/lib/vaultwarden /var/log/vaultwarden
sudo chmod 750 /var/lib/vaultwarden /var/log/vaultwarden
sudo chown -R autobot:automation /var/backups
sudo chmod 750 /var/backups
echo 'admin1 ALL=(ALL) ALL' | sudo tee /etc/sudoers.d/99-admin1
echo 'autobot ALL=(ALL) NOPASSWD: /usr/bin/rsync, /usr/bin/tar' | sudo tee /etc/sudoers.d/50-autobot

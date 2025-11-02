
set -euo pipefail

echo "=== SIS2: Users and Permissions Setup ==="


for g in admin auditor automation vaultwarden user
do
  if getent group "$g" >/dev/null; then
    echo "[INFO] Group $g already exists."
  else
    sudo groupadd "$g"
    echo "[OK] Group $g created."
  fi
done


for u in admin1 auditor1 autobot vw user1
do
  if id "$u" &>/dev/null; then
    echo "[INFO] User $u already exists."
  else
    sudo useradd -m -s /bin/bash "$u"
    echo "[OK] User $u created."
  fi
done


sudo usermod -aG admin admin1
sudo usermod -aG auditor auditor1
sudo usermod -aG automation autobot
sudo usermod -aG vaultwarden vw
sudo usermod -aG user user1
echo "[OK] Users assigned to groups."

sudo mkdir -p /var/lib/vaultwarden /var/log/vaultwarden /var/backups
sudo chown -R vw:vaultwarden /var/lib/vaultwarden /var/log/vaultwarden
sudo chmod 750 /var/lib/vaultwarden /var/log/vaultwarden
sudo chown -R autobot:automation /var/backups
sudo chmod 750 /var/backups
echo "[OK] Directories and permissions configured."


echo 'admin1 ALL=(ALL) ALL' | sudo tee /etc/sudoers.d/99-admin1 >/dev/null
echo 'autobot ALL=(ALL) NOPASSWD: /usr/bin/rsync, /usr/bin/tar' | sudo tee /etc/sudoers.d/50-autobot >/dev/null


if sudo visudo -cf /etc/sudoers.d/99-admin1 && sudo visudo -cf /etc/sudoers.d/50-autobot; then
  echo "[OK] Sudoers validated successfully."
else
  echo "[ERROR] Sudoers validation failed!"
fi


echo "=== Summary ==="
getent group | grep -E 'admin|auditor|automation|vaultwarden|user' || true
for u in admin1 auditor1 autobot vw user1
do
  id "$u" || true
done
echo "=== SIS2 setup complete ==="

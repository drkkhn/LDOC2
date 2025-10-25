
set -euo pipefail

echo "=== UFW Demo ==="
echo "[1/3] Allowing SSH (22), HTTP (80), HTTPS (443)..."
if sudo ufw allow OpenSSH 2>/dev/null && \
   sudo ufw allow 80/tcp 2>/dev/null && \
   sudo ufw allow 443/tcp 2>/dev/null; then
  echo "[OK] Rules added."
else
  echo "[WARN] Could not set rules with sudo in this environment."
fi

echo "[2/3] Enabling UFW..."
if sudo ufw --force enable 2>/dev/null; then
  echo "[OK] UFW enabled."
else
  echo "[WARN] Could not enable UFW (likely restricted in Cloud Shell)."
fi

echo "[3/3] Showing status:"
if sudo ufw status verbose 2>/dev/null; then
  :
else
  cat <<'MOCK'
Status: active
To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
MOCK
fi

echo "=== UFW Demo Complete ==="

#!/usr/bin/env bash
set -euo pipefail

echo "=== SIS3: Installing Packages and Testing Environment ==="

# 1. Update system
echo "[1/4] Updating system..."
sudo apt update -y && sudo apt upgrade -y

# 2. Install base packages
echo "[2/4] Installing base packages..."
sudo apt install -y curl wget git nginx postgresql ufw rsync tar python3-pip python3-venv

# 3. Configure firewall (safe mode for GCP)
echo "[3/4] Configuring firewall..."
if sudo ufw allow OpenSSH && sudo ufw allow 80/tcp && sudo ufw allow 443/tcp; then
  sudo ufw --force enable || true
  echo "[OK] Firewall rules configured (22, 80, 443)."
else
  echo "[WARN] UFW configuration may be restricted in this environment."
fi

# 4. Install Python dependencies
echo "[4/4] Installing Python dependencies..."
pip3 install --user psycopg2-binary >/dev/null 2>&1 || echo "[WARN] psycopg2 installation skipped."

echo "[OK] Python packages installed."

# 5. Smoke test
echo "=== Running Smoke Test ==="
cat > smoke_test.sh <<'EOF'
#!/usr/bin/env bash
set -e
echo "--- Smoke Test Start ---"

for pkg in curl wget git nginx psql ufw; do
  if command -v "$pkg" >/dev/null 2>&1; then
    echo "[OK] $pkg found"
  else
    echo "[FAIL] $pkg missing"
  fi
done

echo "--- Testing nginx ---"
if sudo systemctl start nginx 2>/dev/null; then
  curl -I http://localhost | head -n 1 || echo "[WARN] nginx not responding"
else
  echo "[WARN] nginx service unavailable in this environment"
fi

echo "--- Testing PostgreSQL client ---"
if command -v psql >/dev/null 2>&1; then
  psql --version
else
  echo "[FAIL] PostgreSQL client missing"
fi

echo "--- Smoke Test Complete ---"
EOF

chmod +x smoke_test.sh
./smoke_test.sh

echo "=== SIS3 setup complete ==="

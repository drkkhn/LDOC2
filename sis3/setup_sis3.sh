
set -euo pipefail

echo "=== SIS3 Setup (Installing Packages) ==="


if [[ -f packages.txt ]]; then
  mapfile -t PKG < packages.txt
else
  PKG=(curl wget git nginx postgresql ufw rsync tar python3-pip python3-venv)
fi

echo "[1/4] Updating system..."
sudo apt update -y
sudo apt upgrade -y || true

echo "[2/4] Installing packages: ${PKG[*]}"
sudo apt install -y "${PKG[@]}"


if command -v pip3 >/dev/null 2>&1; then
  echo "[2b] Ensuring psycopg2-binary (no build deps required)..."
  pip3 install --user psycopg2-binary >/dev/null 2>&1 || true
fi

echo "[3/4] Configuring firewall (UFW)..."
if sudo ufw allow OpenSSH 2>/dev/null && \
   sudo ufw allow 80/tcp 2>/dev/null && \
   sudo ufw allow 443/tcp 2>/dev/null; then
  sudo ufw --force enable 2>/dev/null || true
  echo "[OK] UFW rules configured."
else
  echo "[WARN] UFW configuration skipped (restricted environment)."
fi

echo "[4/4] Running smoke test..."
if [[ -f smoke_test.sh ]]; then
  chmod +x smoke_test.sh
  ./smoke_test.sh
else
  echo "[INFO] smoke_test.sh not found, creating a minimal one..."
  cat > smoke_test.sh <<'EOF'
#!/usr/bin/env bash
set -e
for bin in curl wget git nginx psql ufw; do
  command -v "$bin" >/dev/null && echo "[OK] $bin" || echo "[FAIL] $bin"
done
EOF
  chmod +x smoke_test.sh
  ./smoke_test.sh
fi

echo "=== SIS3 Setup Complete ==="

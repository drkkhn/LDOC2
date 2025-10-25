
set -euo pipefail

echo "=== Smoke Test: Package Validation ==="

MISSING=0
for bin in curl wget git nginx psql ufw; do
  if command -v "$bin" >/dev/null 2>&1; then
    echo "[OK] $bin found -> $(command -v "$bin")"
  else
    echo "[FAIL] $bin missing"
    MISSING=$((MISSING+1))
  fi
done

# 2) nginx test (start if possible, then curl)
echo "--- Nginx test ---"
if command -v nginx >/dev/null 2>&1; then
  sudo systemctl start nginx 2>/dev/null || true
  if curl -sI http://localhost | head -n1; then
    echo "[OK] nginx responded"
  else
    echo "[WARN] nginx not responding (service control may be restricted)"
  fi
else
  echo "[SKIP] nginx not installed"
fi

# Postgres test
echo "--- PostgreSQL client test ---"
if command -v psql >/dev/null 2>&1; then
  psql --version || true
  
  sudo -u postgres psql -c "SELECT 1;" 2>/dev/null || echo "[INFO] server not available, client OK"
else
  echo "[SKIP] psql not installed"
fi

echo "=== Smoke Test Complete (missing: $MISSING) ==="

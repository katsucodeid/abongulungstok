#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
pkg update -y
pkg install -y nodejs-lts git openssl
cd "$HOME"
if [ ! -d abongulungstok ]; then git clone https://github.com/katsucodeid/abongulungstok.git; fi
ROOT="$HOME/abongulungstok"
cd "$ROOT/backend"
npm install --no-audit --no-fund --package-lock=false
touch .env
OLD_CONFIG=0
if grep -q "^DATA_DIR=.*abongulunggembulstokinsan" .env || grep -q "^ADMIN_USERNAME=insanadmin$" .env; then
  OLD_CONFIG=1
  cp -p .env ".env.before-abongulung-separation-$(date +%Y%m%d-%H%M%S)"
fi
set_env() {
  key="$1"; value="$2"
  if grep -q "^${key}=" .env; then sed -i "s|^${key}=.*|${key}=${value}|" .env; else printf "%s=%s\n" "$key" "$value" >> .env; fi
}
set_env PORT "8788"
set_env DATA_DIR "$ROOT/backend/data"
set_env REPORT_DIR "$HOME/storage/downloads/Abon Gulung Stok Kertas"
if [ "$OLD_CONFIG" -eq 1 ] || ! grep -q "^JWT_SECRET=." .env; then set_env JWT_SECRET "$(openssl rand -hex 32)"; fi
NEW_ADMIN_PASS=""
if [ "$OLD_CONFIG" -eq 1 ] || ! grep -q "^ADMIN_USERNAME=." .env; then set_env ADMIN_USERNAME "adminabongulung"; fi
if [ "$OLD_CONFIG" -eq 1 ] || ! grep -q "^ADMIN_PASSWORD=." .env; then NEW_ADMIN_PASS="$(openssl rand -hex 16)"; set_env ADMIN_PASSWORD "$NEW_ADMIN_PASS"; fi
chmod 600 .env
mkdir -p "$ROOT/backend/data" "$HOME/storage/downloads/Abon Gulung Stok Kertas"
if command -v termux-setup-storage >/dev/null 2>&1; then termux-setup-storage; fi
echo
echo "Instalasi backend Abon Gulung Stok Kertas selesai."
echo "Database terpisah: $ROOT/backend/data"
echo "Laporan terpisah: $HOME/storage/downloads/Abon Gulung Stok Kertas"
if [ -n "$NEW_ADMIN_PASS" ]; then
  echo "SIMPAN AKUN ADMIN ABON GULUNG INI:"
  echo "Username: adminabongulung"
  echo "Password: $NEW_ADMIN_PASS"
  echo "Password hanya ditampilkan saat pertama kali dibuat."
else
  echo "Akun admin Abon Gulung yang sudah ada tetap dipertahankan."
fi
echo "Jalankan: bash $ROOT/scripts/start-termux.sh"

#!/data/data/com.termux/files/usr/bin/bash
set -e
pkg update -y
pkg install -y nodejs-lts git openssl
cd "$HOME"
if [ ! -d abongulungstok ]; then
  git clone https://github.com/katsucodeid/abongulungstok.git
fi
cd abongulungstok/backend
npm install --no-audit --no-fund --package-lock=false
touch .env
OLD_CONFIG=0
if grep -q '^DATA_DIR=.*abongulunggembulstokinsan' .env || grep -q '^ADMIN_USERNAME=insanadmin# Gunakan database dan arsip milik aplikasi lama agar kedua aplikasi membaca data yang sama.
if grep -q '^DATA_DIR=' .env; then sed -i "s|^DATA_DIR=.*|DATA_DIR=$HOME/abongulungstok/backend/data|" .env; else echo "DATA_DIR=$HOME/abongulungstok/backend/data" >> .env; fi
if grep -q '^REPORT_DIR=' .env; then sed -i "s|^REPORT_DIR=.*|REPORT_DIR=$HOME/storage/downloads/Abon Gulung Stok Kertas|" .env; else echo "REPORT_DIR=$HOME/storage/downloads/Abon Gulung Stok Kertas" >> .env; fi
if [ "$OLD_CONFIG" -eq 1 ] || ! grep -q '^JWT_SECRET=.' .env; then
  echo "JWT_SECRET=$(openssl rand -hex 32)" >> .env
fi
if [ "$OLD_CONFIG" -eq 1 ] || ! grep -q '^ADMIN_USERNAME=.' .env; then
  sed -i '/^ADMIN_USERNAME=/d' .env
  echo "ADMIN_USERNAME=adminabongulung" >> .env
fi
NEW_ADMIN_PASS=""
if [ "$OLD_CONFIG" -eq 1 ] || ! grep -q '^ADMIN_PASSWORD=.' .env; then
  sed -i '/^ADMIN_PASSWORD=/d' .env
  NEW_ADMIN_PASS="$(openssl rand -hex 10)"
  echo "ADMIN_PASSWORD=$NEW_ADMIN_PASS" >> .env
fi
chmod 600 .env
echo
echo "Menyiapkan akses penyimpanan internal untuk laporan TXT..."
if command -v termux-setup-storage >/dev/null 2>&1; then
  termux-setup-storage
fi
if [ -d "$HOME/storage/downloads" ]; then
  mkdir -p "$HOME/storage/downloads/Abon Gulung Gembul"
  echo "Folder laporan: $HOME/storage/downloads/Abon Gulung Stok Kertas"
else
  echo "PERHATIAN: izin Download belum tersedia. Jalankan termux-setup-storage lalu izinkan akses penyimpanan."
fi
if [ -n "$NEW_ADMIN_PASS" ]; then
  echo
  echo "SIMPAN KREDENSIAL ADMIN INI SEKARANG:"
  echo "Username: adminabongulung"
  echo "Password: $NEW_ADMIN_PASS"
  echo "Password hanya ditampilkan saat pertama kali dibuat."
else
  echo "Konfigurasi admin yang sudah ada tetap dipakai dari backend/.env."
fi
echo
echo "Database Abon Gulung terpisah: $HOME/abongulungstok/backend/data"
echo "Instalasi selesai. Jalankan: bash ~/abongulungstok/scripts/start-termux.sh"
 .env; then
  OLD_CONFIG=1
  cp -p .env ".env.before-abongulung-separation-$(date +%Y%m%d-%H%M%S)"
fi
# Gunakan database dan arsip milik aplikasi lama agar kedua aplikasi membaca data yang sama.
if ! grep -q '^DATA_DIR=' .env; then echo "DATA_DIR=$HOME/abongulunggembulstokinsan/backend/data" >> .env; fi
if ! grep -q '^REPORT_DIR=' .env; then echo "REPORT_DIR=$HOME/storage/downloads/Abon Gulung Gembul" >> .env; fi
if ! grep -q '^JWT_SECRET=.' .env; then
  echo "JWT_SECRET=$(openssl rand -hex 32)" >> .env
fi
if ! grep -q '^ADMIN_USERNAME=.' .env; then
  echo "ADMIN_USERNAME=insanadmin" >> .env
fi
NEW_ADMIN_PASS=""
if ! grep -q '^ADMIN_PASSWORD=.' .env; then
  NEW_ADMIN_PASS="$(openssl rand -hex 10)"
  echo "ADMIN_PASSWORD=$NEW_ADMIN_PASS" >> .env
fi
chmod 600 .env
echo
echo "Menyiapkan akses penyimpanan internal untuk laporan TXT..."
if command -v termux-setup-storage >/dev/null 2>&1; then
  termux-setup-storage
fi
if [ -d "$HOME/storage/downloads" ]; then
  mkdir -p "$HOME/storage/downloads/Abon Gulung Gembul"
  echo "Folder laporan: $HOME/storage/downloads/Abon Gulung Gembul"
else
  echo "PERHATIAN: izin Download belum tersedia. Jalankan termux-setup-storage lalu izinkan akses penyimpanan."
fi
if [ -n "$NEW_ADMIN_PASS" ]; then
  echo
  echo "SIMPAN KREDENSIAL ADMIN INI SEKARANG:"
  echo "Username: insanadmin"
  echo "Password: $NEW_ADMIN_PASS"
  echo "Password hanya ditampilkan saat pertama kali dibuat."
else
  echo "Konfigurasi admin yang sudah ada tetap dipakai dari backend/.env."
fi
echo
echo "Instalasi selesai. Jalankan: bash ~/abongulungstok/scripts/start-termux.sh"

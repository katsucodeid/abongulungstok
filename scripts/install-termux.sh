#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

pkg update -y
pkg install -y nodejs-lts git openssl

ROOT="$HOME/abongulungstok"
if [ ! -d "$ROOT/.git" ]; then
  git clone https://github.com/katsucodeid/abongulungstok.git "$ROOT"
fi
cd "$ROOT/backend"
npm install --no-audit --no-fund --package-lock=false

touch .env
OLD_CONFIG=0
if grep -q '^DATA_DIR=' .env && ! grep -q "^DATA_DIR=$ROOT/backend/data$" .env; then OLD_CONFIG=1; fi
if grep -q '^ADMIN_USERNAME=' .env && ! grep -q '^ADMIN_USERNAME=adminabongulung$' .env; then OLD_CONFIG=1; fi
if grep -q '^DATA_DIR=.*abongulunggembulstokinsan' .env || grep -q '^ADMIN_USERNAME=insanadmin$' .env; then OLD_CONFIG=1; fi
if [ "$OLD_CONFIG" -eq 1 ]; then
  cp -p .env ".env.before-abongulung-separation-$(date +%Y%m%d-%H%M%S)"
fi

set_env() {
  local key="$1" value="$2"
  if grep -q "^${key}=" .env; then
    KEY="$key" VALUE="$value" node -e 'const fs=require("fs");const p=".env",k=process.env.KEY,v=process.env.VALUE;const lines=fs.readFileSync(p,"utf8").split(/\\r?\\n/);let done=false;const out=lines.map(line=>{if(line.startsWith(k+"=")){if(done)return null;done=true;return k+"="+v;}return line;}).filter(x=>x!==null);if(!done)out.push(k+"="+v);fs.writeFileSync(p,out.filter((x,i)=>i===0||x!==""||i<out.length-1).join("\\n").replace(/\\n*$/,"")+"\\n",{mode:0o600});'
  else
    printf '%s=%s\\n' "$key" "$value" >> .env
  fi
}

set_env PORT "8788"
set_env HOST "127.0.0.1"
set_env DATA_DIR "$ROOT/backend/data"
set_env REPORT_DIR "$HOME/storage/downloads/Abon Gulung Stok Kertas"
if [ "$OLD_CONFIG" -eq 1 ] || ! grep -q '^JWT_SECRET=.' .env; then
  set_env JWT_SECRET "$(openssl rand -hex 32)"
fi

NEW_ADMIN_PASS=""
if [ "$OLD_CONFIG" -eq 1 ] || ! grep -q '^ADMIN_USERNAME=.' .env || ! grep -q '^ADMIN_PASSWORD=.' .env; then
  NEW_ADMIN_PASS="$(openssl rand -hex 20)"
  set_env ADMIN_USERNAME "adminabongulung"
  set_env ADMIN_PASSWORD "$NEW_ADMIN_PASS"
fi

mkdir -p "$ROOT/backend/data" "$HOME/storage/downloads/Abon Gulung Stok Kertas"
chmod 700 "$ROOT/backend/data"
chmod 600 .env

# If this installation previously used a legacy identity, rotate only the admin
# credential in its dedicated database. Stock, transactions, staff and audit data remain.
if [ "$OLD_CONFIG" -eq 1 ] && [ -s "$ROOT/backend/data/data.json" ] && [ -n "$NEW_ADMIN_PASS" ]; then
  ADMIN_USERNAME="adminabongulung" ADMIN_PASSWORD="$NEW_ADMIN_PASS" node <<'NODE'
const fs = require("fs");
const path = require("path");
const bcrypt = require("bcryptjs");
(async () => {
  const file = path.join(process.env.HOME, "abongulungstok/backend/data/data.json");
  const db = JSON.parse(fs.readFileSync(file, "utf8"));
  if (!db || typeof db !== "object" || Array.isArray(db)) throw new Error("Format database tidak valid; file tidak diubah.");
  db.users = Array.isArray(db.users) ? db.users : [];
  let admin = db.users.find(user => user.role === "admin");
  const passwordHash = await bcrypt.hash(process.env.ADMIN_PASSWORD, 12);
  if (admin) {
    admin.username = process.env.ADMIN_USERNAME;
    admin.passwordHash = passwordHash;
  } else {
    db.users.push({ id: require("crypto").randomUUID(), username: process.env.ADMIN_USERNAME, passwordHash, role: "admin" });
  }
  const temp = file + ".install-" + process.pid + ".tmp";
  fs.writeFileSync(temp, JSON.stringify(db, null, 2), { mode: 0o600, flag: "wx" });
  fs.renameSync(temp, file);
})().catch(error => { console.error("Gagal menyiapkan akun admin mandiri:", error.message); process.exit(1); });
NODE
fi

if command -v termux-setup-storage >/dev/null 2>&1; then termux-setup-storage; fi

echo
echo "Instalasi backend Abon Gulung Stok Kertas selesai."
echo "Database terpisah: $ROOT/backend/data"
echo "Laporan dan cadangan: $HOME/storage/downloads/Abon Gulung Stok Kertas"
echo "Server lokal: http://127.0.0.1:8788"
if [ -n "$NEW_ADMIN_PASS" ]; then
  echo
  echo "SIMPAN AKUN ADMIN ABON GULUNG INI:"
  echo "Username: adminabongulung"
  echo "Password: $NEW_ADMIN_PASS"
  echo "Password ini tidak ditampilkan kembali."
else
  echo "Akun admin Abon Gulung yang sudah ada tetap dipertahankan."
fi
echo "Jalankan: bash $ROOT/scripts/start-termux.sh"

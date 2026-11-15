#!/data/data/com.termux/files/usr/bin/bash
set -e
ROOT="$HOME/abongulungstok"
cd "$ROOT/backend"
if [ ! -f .env ]; then echo "File .env belum ada. Jalankan scripts/install-termux.sh"; exit 1; fi
PORT="$(sed -n 's/^PORT=//p' .env | tail -n 1)"
PORT="${PORT:-8788}"
termux-wake-lock 2>/dev/null || true

if [ ! -d "$HOME/storage/downloads" ] && command -v termux-setup-storage >/dev/null 2>&1; then
  echo "Meminta izin penyimpanan internal Android..."
  termux-setup-storage
fi
if [ -d "$HOME/storage/downloads" ]; then
  mkdir -p "$HOME/storage/downloads/Abon Gulung Stok Kertas"
  export REPORT_DIR="$HOME/storage/downloads/Abon Gulung Stok Kertas"
  echo "Laporan TXT: $REPORT_DIR"
else
  echo "PERINGATAN: izin Download belum aktif. Jalankan termux-setup-storage dan izinkan akses file."
fi

# Avoid launching a second Node server on an already occupied port.
if node - "$PORT" <<'NODE'
const net = require("net");
const port = Number(process.argv[2]);
const socket = net.createConnection({ host: "127.0.0.1", port });
socket.setTimeout(1200);
socket.once("connect", () => { socket.destroy(); process.exit(0); });
socket.once("timeout", () => { socket.destroy(); process.exit(1); });
socket.once("error", () => process.exit(1));
NODE
then
  if node - "$PORT" <<'NODE'
const http=require("http");
const req=http.get({host:"127.0.0.1",port:Number(process.argv[2]),path:"/api/health",timeout:1500},res=>{
 let body="";res.on("data",chunk=>body+=chunk);res.on("end",()=>{
  try { const d=JSON.parse(body); process.exit(d.ok && d.app==="Abon Gulung Stok Kertas"?0:1); }
  catch { process.exit(1); }
 });
});
req.on("error",()=>process.exit(1));req.on("timeout",()=>{req.destroy();process.exit(1);});
NODE
  then
    echo "Server Abon Gulung Stok Kertas sudah aktif pada port $PORT."
  else
    echo "Port $PORT sedang dipakai layanan lain. Server Abon Gulung tidak dijalankan."
    exit 1
  fi
  echo "Jangan jalankan server kedua. Untuk menerapkan pembaruan, gunakan menu Update Server di aplikasi."
  exit 0
fi

echo "Mode: OFFLINE LOKAL — server Abon Gulung Stok Kertas berjalan pada HP ini."
echo "Buka aplikasi Android Abon Gulung Stok Kertas pada perangkat yang sama."
npm start

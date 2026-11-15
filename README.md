# Abon Gulung Stok Kertas

**Aplikasi mandiri untuk mengelola stok bahan dan kemasan operasional Abon Gulung.**  
Versi aplikasi: **0.0.3** · Version code: **2** · Package: `id.katsucode.aggkrts`

Repository resmi: https://github.com/katsucodeid/abongulungstok

## Identitas dan pemisahan sistem

Repository ini merupakan aplikasi terpisah dari `abongulunggembulstokinsan`.

- Database sendiri: `~/abongulungstok/backend/data/data.json`.
- Konfigurasi dan kredensial sendiri: `~/abongulungstok/backend/.env`.
- JWT secret dan sesi login sendiri.
- Username admin awal sendiri: `adminabongulung`; password dibuat acak oleh installer dan ditampilkan di Termux saat pertama kali dibuat.
- Folder laporan dan cadangan sendiri: `Download/Abon Gulung Stok Kertas/`.
- Port backend khusus: `8788` (server lama dapat tetap memakai `8787`).
- Cache browser, IndexedDB, localStorage, dan service worker memakai namespace aplikasi Abon Gulung.
- APK memakai application ID `id.katsucode.aggkrts` dan sertifikat signing Abon Gulung.

Installer tidak mengimpor database, akun, atau password dari aplikasi lama. Installer tidak menghapus database lama. Jangan menyalin file database atau `.env` antar-repository jika ingin menjaga pemisahan.

## Fitur

- Dashboard stok Box isi 3, Box isi 5 luar/dalam, Kertas Minyak, dan Mika roti roll.
- Pencatatan barang masuk, pengurangan stok manual, dan target produksi per outlet.
- Riwayat transaksi, laporan TXT, pencadangan, dan pemulihan dengan validasi checksum.
- Akun admin dan staff dengan pembatasan akses.
- Alarm kerja Android dan pilihan nada lokal.
- Operasional offline pada HP server; perangkat lain dapat mengakses melalui jaringan Wi-Fi/hotspot yang sama.

## Versi aplikasi

| Komponen | Nilai |
|---|---|
| Nama | Abon Gulung Stok Kertas |
| Versi | **0.0.3** |
| Version code | `2` |
| Application ID | `id.katsucode.aggkrts` |
| Minimum Android | Android 6.0 (API 23) |
| Target SDK | 35 |
| Java | 17 |
| Gradle | 8.9 |
| Backend | Node.js + Express |
| Port default | `8788` |

### Catatan versi 0.0.3

- Memisahkan database, akun admin, token sesi, direktori laporan, dan port backend dari aplikasi stok sebelumnya.
- Memisahkan cache browser dan identitas penyimpanan lokal.
- Menghapus tampilan riwayat commit lintas aplikasi; versi hanya merujuk rilis bertag `aggkrts-v*` dari repository ini.
- Memisahkan pembaruan kode server dari pemasangan APK Android.
- Memperbaiki identitas file cadangan, laporan, dan jembatan native Android.

## Instalasi dan menjalankan backend di Termux

Pada HP server, jalankan:

```bash
pkg update && pkg upgrade -y
pkg install git nodejs-lts openssl -y
git clone https://github.com/katsucodeid/abongulungstok.git
cd ~/abongulungstok
bash scripts/install-termux.sh
bash scripts/start-termux.sh
```

Jika repository sudah ada:

```bash
cd ~/abongulungstok
git pull --ff-only origin main
bash scripts/install-termux.sh
bash scripts/start-termux.sh
```

Installer membuat atau memperbarui konfigurasi mandiri di `backend/.env`. Saat instalasi pertama atau saat mendeteksi konfigurasi lama yang menunjuk ke aplikasi sebelumnya, installer membuat username admin `adminabongulung` dan password acak baru. **Catat password yang ditampilkan Termux dan simpan di tempat aman.** Jika akun admin Abon Gulung sudah ada, installer mempertahankan akun yang sudah ada dan tidak mereset passwordnya.

Server berjalan pada `http://127.0.0.1:8788`. Aplikasi Android membuka alamat lokal tersebut secara otomatis. Jangan menjalankan server kedua pada port yang sama.

## Login dan pengelolaan akun

- Login menggunakan akun yang tersimpan pada database Abon Gulung.
- Username admin awal adalah `adminabongulung`.
- Password awal dibuat acak oleh installer dan ditampilkan hanya ketika akun baru dibuat.
- Admin dapat mengganti username/password akun sendiri dari menu **Manajemen Akun**.
- Admin dapat membuat akun staff/admin, mengatur ulang password akun lain, dan menghapus akun selain akun yang sedang dipakai atau admin terakhir.
- Jangan memakai kredensial `insanadmin` atau password dari aplikasi lama.

Jika password admin hilang, jangan menghapus database. Amankan salinan database dan konfigurasi terlebih dahulu, lalu lakukan prosedur pemulihan akun secara terkontrol.

## Membuat APK Android

Workflow **Build Abon Gulung Stok Kertas APK** berada di `.github/workflows/build-apk.yml`.

Repository Actions secrets yang diperlukan:
- `ANDROID_KEYSTORE_BASE64`: seluruh isi file Base64 dari keystore Abon Gulung.
- `ANDROID_KEYSTORE_PASSWORD`: password keystore.
- `ANDROID_KEY_ALIAS`: `abongulung`.
- `ANDROID_KEY_PASSWORD`: password private key.

Jangan pernah menaruh nilai secret, password, file JKS, database, atau `.env` di repository. Workflow memeriksa sertifikat SHA256 Abon Gulung sebelum menerbitkan APK.

Build berjalan otomatis ketika file aplikasi berubah di branch `main`, atau dapat dijalankan manual melalui tab **Actions**. Jika berhasil, rilis akan memakai tag `aggkrts-v0.0.3` dan file `Abon-Gulung-Stok-Kertas-V0.0.3.apk`. Status build dan artefak harus diperiksa di GitHub Actions; commit kode saja tidak berarti APK sudah berhasil dibuat.

## Pembaruan

Ada dua pembaruan yang berbeda:

1. **Update Server** di dalam aplikasi memperbarui kode backend dari branch `main` repository ini. Sebelum update, server membuat salinan database dan tidak menghapus `.env`.
2. **Update APK** memeriksa rilis dengan tag `aggkrts-v*` pada repository ini saja. APK diunduh dari asset rilis Abon Gulung dan pemasangannya tetap memerlukan persetujuan Android.

Jangan menganggap commit repository sebagai versi APK. Hanya rilis bertag `aggkrts-v*` yang dipakai sebagai pembaruan Android.

## Data dan keamanan

- Database utama: `~/abongulungstok/backend/data/data.json`.
- Konfigurasi rahasia: `~/abongulungstok/backend/.env`.
- Laporan: `Download/Abon Gulung Stok Kertas/Laporan/`.
- Cadangan: `Download/Abon Gulung Stok Kertas/Pencadangan/`.
- Database dan konfigurasi aplikasi lama tidak disentuh.
- Jangan mengedit database secara manual dan jangan menjalankan perintah reset database tanpa cadangan terverifikasi.
- Simpan keystore Abon Gulung beserta password secara permanen. APK Android berikutnya harus ditandatangani dengan sertifikat yang sama agar dapat memperbarui aplikasi yang sudah terpasang.

## Struktur repository

- `android/`: proyek aplikasi Android.
- `backend/`: API, autentikasi, database, laporan, dan manajemen.
- `frontend/`: antarmuka aplikasi.
- `scripts/`: instalasi, start, dan update backend Termux.
- `docs/`: dokumentasi.
- `.github/workflows/`: build dan publikasi APK.

Dikembangkan oleh **KatsuCode × Insan** untuk operasional Abon Gulung.

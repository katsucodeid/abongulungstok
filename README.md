# Abon Gulung Stok Kertas

**Aplikasi Android KatsuCode untuk mengelola stok bahan dan kemasan Abon Gulung Gembul.**  
Versi aplikasi saat ini: **0.0.1** · Package: `id.katsucode.aggkrts`

Repository resmi: https://github.com/katsucodeid/abongulungstok

## Tentang aplikasi

Abon Gulung Stok Kertas membantu admin dan staff mencatat persediaan, barang masuk, target produksi, riwayat transaksi, laporan, serta alarm kerja. Aplikasi Android ini menggunakan WebView sebagai antarmuka dan backend Node.js yang dijalankan secara lokal melalui Termux.

Fitur utama:
- Dashboard stok Box isi 3, Box isi 5 luar/dalam, Kertas Minyak, dan Mika roti roll.
- Pencatatan stok datang, stok manual, target produksi, dan riwayat transaksi.
- Laporan TXT, pencadangan, serta pemulihan database.
- Akun admin dan staff dengan hak akses berbeda.
- Alarm kerja Android dan pemberitahuan pembaruan aplikasi.
- Dukungan penggunaan lokal/offline pada HP server; perangkat lain dapat terhubung melalui Wi-Fi/hotspot yang sama.

## Informasi versi

| Komponen | Nilai |
|---|---|
| Nama aplikasi | Abon Gulung Stok Kertas |
| Versi | **0.0.1** |
| Version code | `1` |
| Android application ID | `id.katsucode.aggkrts` |
| Minimum Android | Android 6.0 (API 23) |
| Target SDK | 35 |
| Versi Java | 17 |
| Gradle | 8.9 |

### Riwayat versi

**Versi 0.0.1 — 15 November 2026 (rilis awal)**
- Membuat aplikasi Android khusus Abon Gulung Stok Kertas dengan application ID terpisah.
- Menyediakan fitur stok, stok datang, target produksi, riwayat, laporan, pencadangan, dan pemulihan.
- Menambahkan alarm kerja Android, pilihan nada, tes alarm, dan notifikasi pembaruan.
- Menyiapkan proses build APK melalui GitHub Actions.
- Mempertahankan sertifikat penandatanganan KatsuCode untuk rilis aplikasi.

## Membuat APK dari repository ini

Repository ini sudah memiliki workflow **Build Abon Gulung Stok Kertas APK** di `.github/workflows/build-apk.yml`.

### Build otomatis dengan GitHub Actions

1. Buka tab **Settings → Secrets and variables → Actions** pada repository.
2. Tambahkan empat Actions secrets berikut. Isi nilainya langsung di GitHub; jangan menaruh password atau file keystore di repository:
   - `ANDROID_KEYSTORE_BASE64`
   - `ANDROID_KEYSTORE_PASSWORD`
   - `ANDROID_KEY_ALIAS` — nilai alias: `katsucode`
   - `ANDROID_KEY_PASSWORD`
3. Buka tab **Actions**, pilih **Build Abon Gulung Stok Kertas APK**, lalu tekan **Run workflow** pada branch `main`.
4. Tunggu sampai semua langkah selesai dengan status hijau.
5. APK rilis dapat diambil dari **Releases** (tag `aggkrts-v0.0.1`) atau dari bagian **Artifacts** pada workflow run.

Workflow juga berjalan otomatis ketika perubahan pada folder `android/`, `frontend/`, atau file workflow didorong ke branch `main`. Pull request akan membuat APK debug untuk pemeriksaan; push ke `main` atau workflow manual membuat APK release bertanda tangan.

**Penting:** build release memerlukan empat secrets di atas. Jangan mengunggah `.jks`, password, token, atau file `.env` ke GitHub. APK belum dianggap berhasil dibuat sebelum workflow selesai dan artefak APK tersedia.

### Build lokal (opsional)

Siapkan JDK 17, Android SDK (platform 35 dan build-tools 35.0.0), serta Gradle 8.9. Dari folder repository:

```bash
gradle -p android :app-aggkrts:assembleDebug
```

APK debug berada di:

```
android/app-aggkrts/build/outputs/apk/debug/app-aggkrts-debug.apk
```

Untuk release bertanda tangan, siapkan environment signing yang sama seperti GitHub Actions sebelum menjalankan:

```bash
gradle -p android :app-aggkrts:assembleRelease
```

## Instalasi backend di Termux

Aplikasi Android terhubung ke backend lokal pada `http://127.0.0.1:8787`. Pada HP server, backend Node.js dijalankan melalui Termux.

Jika ini pemasangan backend baru, jalankan:

```bash
pkg update && pkg upgrade -y
pkg install git nodejs-lts openssl -y
git clone https://github.com/katsucodeid/abongulungstok.git
cd ~/abongulungstok
bash scripts/install-termux.sh
bash scripts/start-termux.sh
```

Jika folder repository sudah ada, perbarui dari branch utama dengan:

```bash
cd ~/abongulungstok
git pull origin main
```

Berikan izin penyimpanan ketika Termux memintanya. Jika belum muncul, jalankan `termux-setup-storage`.

**Catatan database:** skrip instalasi repo ini mengarahkan `DATA_DIR` ke database lama di `~/abongulunggembulstokinsan/backend/data` agar data stok yang sudah ada dapat digunakan bersama. Jangan menghapus folder database lama, file `.env`, atau cadangan. Jangan jalankan dua proses backend pada port 8787 secara bersamaan. Jika backend lama masih aktif dan sudah menggunakan database tersebut, gunakan backend yang sedang berjalan; jangan menyalakan server kedua.

## Menjalankan aplikasi

- Pastikan backend Termux aktif pada port 8787.
- Buka APK Abon Gulung Stok Kertas pada HP server.
- Perangkat lain dapat membuka alamat LAN HP server melalui browser selama terhubung ke Wi-Fi/hotspot yang sama. Gunakan alamat yang ditampilkan Termux saat server mulai.

Semua perangkat yang terhubung ke backend yang sama akan membaca dan memperbarui data pada database server. Jika HP server atau jaringan lokal mati, perangkat lain tidak dapat mengambil data terbaru.

## Tentang & Pembaruan di dalam aplikasi

Halaman **Tentang & Pembaruan** menampilkan identitas aplikasi, versi terpasang (**0.0.1**), ringkasan fitur, dan riwayat perubahan.

Bagian **Pembaruan aplikasi** menjelaskan dua jenis pembaruan:
1. **Pembaruan kode server** melalui Termux: admin memulai proses dari aplikasi; sistem membuat cadangan database, mengambil kode repository, memasang dependensi, lalu memulai ulang backend secara terkontrol.
2. **Pembaruan APK Android** melalui GitHub Releases: aplikasi memeriksa rilis dengan tag `aggkrts-v*`, mengunduh APK yang sesuai, lalu meminta konfirmasi pemasangan Android.

Koneksi internet diperlukan untuk memeriksa atau mengunduh pembaruan. Operasional stok lokal tetap menggunakan backend pada HP server. Jangan menutup Termux selama pembaruan server berlangsung. Pastikan rilis APK tersedia di GitHub sebelum menggunakan pembaruan APK otomatis.

## Data, keamanan, dan cadangan

- Database utama berada di direktori data backend yang ditentukan oleh `DATA_DIR`; untuk instalasi yang berbagi data, lokasi default diarahkan ke folder database aplikasi lama.
- Laporan dan salinan teks disimpan di folder Download/Abon Gulung Gembul.
- Jangan mengedit file database secara manual.
- Simpan cadangan berkala di lokasi lain.
- Jangan pernah commit `.env`, database, keystore, password, atau token ke repository.
- Pemulihan cadangan dapat mengganti data aktif; lakukan hanya setelah memastikan file cadangan yang benar.

## Struktur repository

- `android/` — proyek Android dan modul `app-aggkrts`.
- `backend/` — API Node.js dan pengelolaan data.
- `frontend/` — antarmuka aplikasi web/WebView.
- `scripts/` — instalasi, menjalankan, dan pembaruan backend Termux.
- `docs/` — dokumentasi operasional.
- `.github/workflows/` — workflow build APK otomatis.

## Lisensi dan pengembang

Dikembangkan oleh **KatsuCode × Insan** untuk operasional Abon Gulung Gembul.

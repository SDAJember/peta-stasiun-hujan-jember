# Peta Stasiun Hujan Kabupaten Jember — GitHub Pages + Supabase

## Isi paket
- `index.html`: peta interaktif, tabel, pencarian/filter, unduhan CSV/Excel/GeoJSON/KML, login admin dan operasi data online.
- `config.js`: tempat memasukkan Supabase Project URL dan publishable/anon key (bukan service_role key).
- `stasiun_hujan_jember.geojson` dan `.csv`: 79 titik awal hasil ekstraksi KMZ.
- `supabase/schema.sql`: tabel, grants dan Row Level Security.
- `supabase/seed_79_stations.sql`: seed 79 titik ke database.

## 1. Buat akun GitHub
1. Buka https://github.com/signup dan buat akun menggunakan email Anda. Verifikasi email dan aktifkan autentikasi dua faktor bila tersedia.
2. Buat repository publik bernama `peta-stasiun-hujan-jember`. GitHub Free dapat menerbitkan Pages dari repository publik. Ingat: semua file yang diunggah ke repository publik dapat dilihat publik.
3. Unggah seluruh isi ZIP ke root repository; pastikan `index.html` dan `config.js` langsung berada di root.
4. Buka Settings → Pages → Build and deployment → Deploy from a branch → `main` → `/(root)` → Save.
5. Tunggu proses selesai, lalu gunakan URL yang muncul di Settings → Pages.

## 2. Buat database Supabase
1. Buka https://supabase.com dan buat akun/project baru. Simpan akses akun dengan aman.
2. Di project, buka SQL Editor dan jalankan isi `supabase/schema.sql`.
3. Buka SQL Editor lagi dan jalankan `supabase/seed_79_stations.sql` untuk memasukkan 79 titik awal. Data berasal dari KMZ dan perlu diverifikasi.
4. Buka Project Settings → API (atau Connect/API Keys sesuai tampilan dashboard) dan salin Project URL serta publishable key (atau legacy anon key).
5. Edit `config.js`: ganti nilai `ISI_DENGAN...` dengan nilai dari project Anda. Key publishable/anon boleh ada di frontend hanya jika RLS benar; JANGAN gunakan `service_role`/secret key.
6. Commit perubahan `config.js` ke repository GitHub. Setelah beberapa saat website akan terbarui.

## 3. Siapkan akun admin dengan aman
1. Di Supabase Authentication, buat satu akun admin dengan email Anda dan password kuat. Matikan sign-up/pendaftaran publik setelah akun dibuat.
2. Di SQL Editor, jalankan perintah di bawah dengan mengganti email sesuai akun admin (jangan ubah peran lewat `user_metadata`):

```sql
update auth.users
set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb) || '{"role":"admin"}'::jsonb
where email = 'EMAIL_ADMIN_ANDA';
```

3. Logout lalu login kembali di website supaya token baru memuat peran admin. Panel tambah/edit/hapus akan terlihat jika klaim `app_metadata.role` bernilai `admin`.
4. Jika login berhasil tetapi bukan admin, pastikan email tepat dan peran telah diset di `raw_app_meta_data`.

## 4. Catatan integrasi
- Pengunjung publik hanya bisa membaca data dan mengunduhnya. Database membatasi insert/update/delete ke akun dengan klaim admin melalui RLS.
- Jika database kosong, login admin lalu tekan **Sinkronkan data ke database** untuk mengirim 79 titik dari file awal. Alternatifnya, jalankan seed SQL di atas.
- Perubahan data di database akan dimuat oleh pengunjung saat membuka/memuat ulang website.
- File KMZ sumber memiliki atribut `Curah_Huja`; satuan/periode belum dikonfirmasi, jadi jangan menafsirkannya sebagai data curah hujan resmi sebelum validasi.
- GitHub Pages menerbitkan website statis; konfigurasi database dan RLS dilakukan di Supabase. Saya tidak dapat membuat akun atau menerbitkan ke akun Anda tanpa akses akun/otorisasi. Jangan kirim kata sandi atau secret key di chat.

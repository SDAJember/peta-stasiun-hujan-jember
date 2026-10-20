-- Skema database Supabase untuk Peta Stasiun Hujan Kabupaten Jember.
-- Jalankan di Supabase Dashboard > SQL Editor.
create table if not exists public.rain_stations (
  id text primary key,
  name text not null,
  latitude double precision not null check (latitude between -90 and 90),
  longitude double precision not null check (longitude between -180 and 180),
  korsda text,
  no_pos text,
  elevation text,
  rainfall text,
  status text default 'Perlu verifikasi',
  notes text,
  source_properties jsonb default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.rain_stations enable row level security;
revoke all on table public.rain_stations from anon, authenticated;
grant select on table public.rain_stations to anon, authenticated;
grant insert, update, delete on table public.rain_stations to authenticated;

drop policy if exists "Public can read rain stations" on public.rain_stations;
create policy "Public can read rain stations" on public.rain_stations for select to anon, authenticated using (true);
drop policy if exists "Admins can insert rain stations" on public.rain_stations;
create policy "Admins can insert rain stations" on public.rain_stations for insert to authenticated with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
drop policy if exists "Admins can update rain stations" on public.rain_stations;
create policy "Admins can update rain stations" on public.rain_stations for update to authenticated using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin') with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
drop policy if exists "Admins can delete rain stations" on public.rain_stations;
create policy "Admins can delete rain stations" on public.rain_stations for delete to authenticated using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- Matikan pendaftaran publik di Supabase Auth setelah akun admin dibuat.
-- Buat akun admin melalui Dashboard > Authentication, lalu atur app_metadata.role='admin'
-- melalui proses tepercaya. Contoh SQL setelah mengganti email admin:
-- update auth.users set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb) || '{"role":"admin"}'::jsonb where email = 'EMAIL_ADMIN_ANDA';
-- Setelah perubahan metadata, logout/login ulang agar JWT memuat peran terbaru.
-- Jangan pernah menaruh service_role key di config.js atau browser.

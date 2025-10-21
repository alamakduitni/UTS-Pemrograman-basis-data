
CREATE TABLE Guru (
    nip VARCHAR(20) PRIMARY KEY,
    jenis_kelamin_guru VARCHAR(10),
    nama_guru VARCHAR(150) NOT NULL,
    ttl VARCHAR(100),
    username VARCHAR(100) UNIQUE,
    password VARCHAR(200)
);

CREATE TABLE Jurusan (
    kode_jurusan VARCHAR(10) PRIMARY KEY,
    nama_jurusan VARCHAR(100) NOT NULL
);

CREATE TABLE Mapel (
    kode_mapel VARCHAR(20) PRIMARY KEY,
    nama_mapel VARCHAR(150) NOT NULL,
    kkm INT,
    kode_jurusan VARCHAR(10) REFERENCES Jurusan(kode_jurusan)
);

CREATE TABLE Kelas (
    id_kelas SERIAL PRIMARY KEY,
    nama_kelas VARCHAR(50) NOT NULL
);

CREATE TABLE Ruang (
    kode_ruang VARCHAR(20) PRIMARY KEY,
    nama_ruang VARCHAR(100)
);

CREATE TABLE Ruang_Kelas (
    id_ruang_kelas SERIAL PRIMARY KEY,
    id_kelas INT REFERENCES Kelas(id_kelas),
    kode_ruang VARCHAR(20) REFERENCES Ruang(kode_ruang),
    kapasitas INT
);

CREATE TABLE Tahun_Ajaran (
    id_tahun_ajaran SERIAL PRIMARY KEY,
    tahun_ajaran VARCHAR(20) NOT NULL
);

CREATE TABLE Jadwal (
    id_jadwal SERIAL PRIMARY KEY,
    jam_mulai TIME,
    jam_selesai TIME,
    semester VARCHAR(10),
    hari VARCHAR(20),
    nip_guru VARCHAR(20) REFERENCES Guru(nip),
    kode_mapel VARCHAR(20) REFERENCES Mapel(kode_mapel),
    id_ruang_kelas INT REFERENCES Ruang_Kelas(id_ruang_kelas),
    id_tahun_ajaran INT REFERENCES Tahun_Ajaran(id_tahun_ajaran)
);

CREATE TABLE Siswa (
    nisn VARCHAR(20) PRIMARY KEY,
    alamat TEXT,
    usia INT,
    hobi VARCHAR(100),
    nama_siswa VARCHAR(150) NOT NULL,
    jenis_kelamin_siswa VARCHAR(10),
    agama_siswa VARCHAR(20),
    tanggal_lahir DATE,
    pekerjaan_ayah VARCHAR(100),
    pekerjaan_ibu VARCHAR(100),
    nama_ayah VARCHAR(150),
    nama_ibu VARCHAR(150),
    no_hp_ayah VARCHAR(30),
    no_hp_ibu VARCHAR(30)
);

CREATE TABLE Siswa_Kelas (
    id_siswa_kelas SERIAL PRIMARY KEY,
    nisn VARCHAR(20) REFERENCES Siswa(nisn),
    id_kelas INT REFERENCES Kelas(id_kelas),
    id_tahun_ajaran INT REFERENCES Tahun_Ajaran(id_tahun_ajaran),
    tanggal_masuk DATE
);

CREATE TABLE Jenis_Nilai (
    id_jenis_nilai SERIAL PRIMARY KEY,
    nama_jenis_nilai VARCHAR(50)
);

CREATE TABLE Nilai (
    id_nilai SERIAL PRIMARY KEY,
    id_siswa_kelas INT REFERENCES Siswa_Kelas(id_siswa_kelas),
    id_jenis_nilai INT REFERENCES Jenis_Nilai(id_jenis_nilai),
    kode_mapel VARCHAR(20) REFERENCES Mapel(kode_mapel),
    nilai NUMERIC(5,2)
);

CREATE TABLE Presensi (
    id_presensi SERIAL PRIMARY KEY,
    id_siswa_kelas INT REFERENCES Siswa_Kelas(id_siswa_kelas),
    tanggal_presensi DATE,
    status_kehadiran VARCHAR(20)
);

CREATE TABLE Staf_Tata_Usaha (
    id_karyawan SERIAL PRIMARY KEY,
    no_hp VARCHAR(30),
    alamat TEXT,
    nama_karyawan VARCHAR(150),
    username VARCHAR(100),
    password VARCHAR(200)
);

CREATE TABLE Pendaftaran (
    id_pendaftaran SERIAL PRIMARY KEY,
    nisn VARCHAR(20) REFERENCES Siswa(nisn),
    tanggal_pendaftaran DATE,
    id_karyawan INT REFERENCES Staf_Tata_Usaha(id_karyawan)
);

CREATE TABLE Tarif (
    id_tarif SERIAL PRIMARY KEY,
    nama_tarif VARCHAR(100),
    nominal_tarif NUMERIC(15,2)
);

CREATE TABLE Pembayaran (
    id_pembayaran SERIAL PRIMARY KEY,
    nisn VARCHAR(20) REFERENCES Siswa(nisn),
    tanggal_pembayaran DATE,
    id_karyawan INT REFERENCES Staf_Tata_Usaha(id_karyawan),
    id_tarif INT REFERENCES Tarif(id_tarif),
    id_tahun_ajaran INT REFERENCES Tahun_Ajaran(id_tahun_ajaran),
    jumlah_bayar NUMERIC(15,2)
);

-- Index dasar recommended
CREATE INDEX idx_siswakelas_nisn ON Siswa_Kelas(nisn);
CREATE INDEX idx_nilai_siswakelas ON Nilai(id_siswa_kelas);
CREATE INDEX idx_nilai_mapel ON Nilai(kode_mapel);
CREATE INDEX idx_presensi_siswakelas ON Presensi(id_siswa_kelas);
CREATE INDEX idx_pembayaran_nisn ON Pembayaran(nisn);
CREATE INDEX idx_pembayaran_tahun ON Pembayaran(id_tahun_ajaran);
CREATE INDEX idx_jadwal_mapel ON Jadwal(kode_mapel);
CREATE INDEX idx_jadwal_guru ON Jadwal(nip_guru);

-- =======================================================================
-- - Referensi kecil: 10 rows each
-- - Siswa: 10000 rows
-- - Siswa_Kelas: 10000 (1 per siswa)
-- - Nilai: 40000 (avg 4 per siswa)
-- - Presensi: 200000 (avg 20 per siswa)
-- - Pembayaran: 20000 (avg 2 per siswa)
-- - Jadwal: 100
-- =======================================================================

-- 1) Jurusan (10)
INSERT INTO Jurusan (kode_jurusan, nama_jurusan)
SELECT 'J' || LPAD(i::text,2,'0'),
       (ARRAY['RPL','TKJ','MM','AKL','BD','AP','OT','PR','AG','BB'])[((i-1) % 10) + 1] || ' Dept'
FROM generate_series(1,10) AS s(i);

-- 2) Mapel (10) - link ke jurusan
INSERT INTO Mapel (kode_mapel, nama_mapel, kkm, kode_jurusan)
SELECT
  'MP' || LPAD(i::text,3,'0'),
  (ARRAY['Matematika','Bahasa Indonesia','Bahasa Inggris','Fisika','Kimia','PKN','Pemrograman','Jaringan','Multimedia','Akuntansi'])[((i-1) % 10) + 1],
  60 + ((i * 3) % 25),
  'J' || LPAD(((i - 1) % 10 + 1)::text,2,'0')
FROM generate_series(1,10) AS s(i);

-- 3) Kelas (10)
INSERT INTO Kelas (nama_kelas)
SELECT (ARRAY['X-RPL-1','X-RPL-2','XI-RPL-1','XI-RPL-2','XII-RPL-1','X-TKJ-1','XI-MM-1','X-AKL-1','XII-MM-1','XII-AKL-1'])[((i-1) % 10) + 1]
FROM generate_series(1,10) AS s(i);

-- 4) Ruang (10)
INSERT INTO Ruang (kode_ruang, nama_ruang)
SELECT 'R' || LPAD(i::text,3,'0'),
       (ARRAY['Lab Komputer A','Lab Komputer B','Ruang Kelas 1','Ruang Kelas 2','Perpustakaan','Ruang Guru','Aula','Lab Fisika','Lab Kimia','Kantor TU'])[((i-1) % 10) + 1]
FROM generate_series(1,10) AS s(i);

-- 5) Ruang_Kelas (10) map kelas->ruang random tapi teratur
INSERT INTO Ruang_Kelas (id_kelas, kode_ruang, kapasitas)
SELECT ((i - 1) % (SELECT COUNT(*) FROM Kelas)) + 1,
       (SELECT kode_ruang FROM Ruang ORDER BY random() LIMIT 1),
       24 + ((i * 5) % 16)
FROM generate_series(1,10) AS s(i);

-- 6) Tahun_Ajaran (10)
INSERT INTO Tahun_Ajaran (tahun_ajaran)
SELECT (2016 + i)::text || '/' || (2017 + i)::text FROM generate_series(1,10) AS s(i);

-- 7) Guru (10)
INSERT INTO Guru (nip, jenis_kelamin_guru, nama_guru, ttl, username, password)
SELECT 'NIP' || LPAD(i::text,6,'0'),
       CASE WHEN (i % 2)=0 THEN 'L' ELSE 'P' END,
       (ARRAY['Ahmad Pratama','Siti Nurhayati','Budi Santoso','Dewi Lestari','Eko Prasetyo','Fitri Handayani','Gunawan Wijaya','Hendra Kusuma','Indah Permata','Joko Santoso'])[((i-1) % 10) + 1],
       'City '||i||', 19'||(70+i)::text||'-01-01',
       'guru' || i,
       'pass' || i
FROM generate_series(1,10) AS s(i);

-- 8) Staf_Tata_Usaha (10)
INSERT INTO Staf_Tata_Usaha (no_hp, alamat, nama_karyawan, username, password)
SELECT '08120' || LPAD(i::text,6,'0'),
       'Jl. Contoh No. '||i,
       (ARRAY['Rini Susanti','Agus Salim','Rizky Ramadhan','Lina Marlina','Dedi Saputra','Wulan Sari','Slamet Riyadi','Mega Febrianti','Rahmat Hidayat','Nia Kurniawati'])[((i-1) % 10) + 1],
       'admin' || i,
       'adm' || i || 'pwd'
FROM generate_series(1,10) AS s(i);

-- 9) Tarif (10)
INSERT INTO Tarif (nama_tarif, nominal_tarif)
SELECT (ARRAY['SPP Bulanan','DSP','Ujian','Prasarana','Extra Kurikuler','Praktik Labor','Seragam','Asuransi','Ekskul','Donasi'])[i],
       ((i * 250000)::NUMERIC(15,2))
FROM generate_series(1,10) AS s(i);

-- 10) Jenis_Nilai (10)
INSERT INTO Jenis_Nilai (nama_jenis_nilai)
SELECT (ARRAY['UTS','UAS','Tugas','Praktikum','Kuis','Proyek','Remedial','Portofolio','Ulangan Harian','Presentasi'])[i]
FROM generate_series(1,10) AS s(i);

-- 11) Jadwal (100) -- distributes mapel/guru/ruang/tahun
INSERT INTO Jadwal (jam_mulai, jam_selesai, semester, hari, nip_guru, kode_mapel, id_ruang_kelas, id_tahun_ajaran)
SELECT
  (TIME '06:30' + ((i % 8) * INTERVAL '1 hour'))::time,
  (TIME '08:00' + ((i % 8) * INTERVAL '1 hour'))::time,
  CASE WHEN (i % 2)=0 THEN 'Ganjil' ELSE 'Genap' END,
  (ARRAY['Senin','Selasa','Rabu','Kamis','Jumat'])[((i-1) % 5) + 1],
  (SELECT nip FROM Guru ORDER BY (i) % (SELECT COUNT(*) FROM Guru) ASC LIMIT 1 OFFSET ((i-1) % (SELECT COUNT(*) FROM Guru))),
  (SELECT kode_mapel FROM Mapel ORDER BY random() LIMIT 1),
  ((i - 1) % (SELECT COUNT(*) FROM Ruang_Kelas)) + 1,
  ((i - 1) % (SELECT COUNT(*) FROM Tahun_Ajaran)) + 1
FROM generate_series(1,100) AS s(i);

-- 12) SISWA (10.000) 
INSERT INTO Siswa (nisn, alamat, usia, hobi, nama_siswa, jenis_kelamin_siswa, agama_siswa, tanggal_lahir,
                   pekerjaan_ayah, pekerjaan_ibu, nama_ayah, nama_ibu, no_hp_ayah, no_hp_ibu)
SELECT
  'NISN' || LPAD(i::text,6,'0') AS nisn,
  'Jl. ' || (ARRAY['Merdeka','Sudirman','Thamrin','Gatot Subroto','Ahmad Yani','Diponegoro','Pahlawan','Veteran','Pemuda','Kartini'])[((i-1) % 10) + 1] || ' No. ' || ((i % 500) + 1) || ', ' || (ARRAY['Jakarta','Surabaya','Bandung','Medan','Semarang'])[((i-1) % 5) + 1],
  (12 + (i % 8))::INT AS usia,
  (ARRAY['Sepakbola','Membaca','Renang','Basket','Gambar','Musik','Fotografi','Menulis','Coding','Menari'])[((i-1) % 10) + 1] AS hobi,
  (
    (ARRAY['Ahmad','Budi','Teguh','Rizky','Fajar','Dewi','Siti','Lina','Indah','Fitri','Agus','Rina','Dian','Wulan','Rizal','Hendra','Eka','Yuni','Robby','Nina','Arif','Luthfi','Mega','Ratna','Sania','Farah','Ilham','Ria','Dewanto','Putri'])[((i-1) % 30) + 1]
    || ' '
    || (ARRAY['Pratama','Santoso','Wijaya','Setiawan','Ramadhan','Hidayat','Saputra','Putra','Nugroho','Wahyudi','Ardi','Fauzi','Aditya','Saputro','Mahendra','Kristanto','Anggraini','Sukma','Herlambang','Ramli','Susanto','Kusnadi','Sutanto','Handayani','Mulyadi','Santika','Rizki','Prasetyo','Fikri','Rahman'])[((i-1) % 30) + 1]
  ) AS nama_siswa,
  CASE WHEN (i % 2) = 0 THEN 'L' ELSE 'P' END AS jenis_kelamin_siswa,
  (ARRAY['Islam','Kristen','Katolik','Hindu','Budha'])[((i-1) % 5) + 1] AS agama_siswa,
  (CURRENT_DATE - ((12 + (i % 8)) * INTERVAL '1 year') - ((i % 365) * INTERVAL '1 day'))::DATE AS tanggal_lahir,
  (ARRAY['Petani','PNS','Pedagang','Wiraswasta','Guru','Supir','TNI/POLRI','Dokter','Perawat','Karyawan Swasta'])[((i-1) % 10) + 1] AS pekerjaan_ayah,
  (ARRAY['Ibu Rumah Tangga','Pegawai Swasta','Dokter','Dosen','Wiraswasta','Guru','Perawat','Karyawan Swasta','Penjual','Karyawan BUMN'])[((i-1) % 10) + 1] AS pekerjaan_ibu,
  'Bapak ' || (ARRAY['Pratama','Santoso','Wijaya','Setiawan','Ramadhan','Hidayat','Saputra','Putra','Nugroho','Wahyudi','Ardi','Fauzi','Aditya','Saputro','Mahendra','Kristanto','Anggraini','Sukma','Herlambang','Ramli','Susanto','Kusnadi','Sutanto','Handayani','Mulyadi','Santika','Rizki','Prasetyo','Fikri','Rahman'])[((i-1) % 30) + 1] AS nama_ayah,
  'Ibu ' || (ARRAY['Sari','Dewi','Fitri','Rina','Lina','Indah','Mega','Ratna','Putri','Sania','Farah','Ria','Wulan','Yuni','Nina','Siti','Rini','Maya','Dewanto','Kristin','Mawar','Melati','Kirana','Anggun','Sinta','Ayu','Tri','Vina','Lestari','Permata'])[((i-1) % 30) + 1] AS nama_ibu,
  '08' || LPAD(((i * 17) % 99999999)::text,10,'0') AS no_hp_ayah,
  '08' || LPAD(((i * 31) % 99999999)::text,10,'0') AS no_hp_ibu
FROM generate_series(1,10000) AS s(i);

-- 13) Siswa_Kelas (10.000) utk pastikan tiap siswa terdaftar ke kelas dan tahun ajaran
INSERT INTO Siswa_Kelas (nisn, id_kelas, id_tahun_ajaran, tanggal_masuk)
SELECT
  'NISN' || LPAD(i::text,6,'0'),
  ((i - 1) % (SELECT COUNT(*) FROM Kelas)) + 1,
  ((i - 1) % (SELECT COUNT(*) FROM Tahun_Ajaran)) + 1,
  CURRENT_DATE - ((i % 400) + ((i % 30)))
FROM generate_series(1,10000) AS s(i);

-- 14) Pembayaran (20.000) - distributed ke siswa/tarif/tahunAjaran/staf
INSERT INTO Pembayaran (nisn, tanggal_pembayaran, id_karyawan, id_tarif, id_tahun_ajaran, jumlah_bayar)
SELECT
  'NISN' || LPAD(((i % 10000) + 1)::text,6,'0'),
  CURRENT_DATE - ((i * 7) % 400),
  ((i - 1) % (SELECT COUNT(*) FROM Staf_Tata_Usaha)) + 1,
  ((i - 1) % (SELECT COUNT(*) FROM Tarif)) + 1,
  ((i - 1) % (SELECT COUNT(*) FROM Tahun_Ajaran)) + 1,
  (( (i - 1) % 10 + 1) * 150000 )::NUMERIC(15,2)
FROM generate_series(1,20000) AS s(i);

-- 15) Presensi (200.000) berdasarkan tanggal dan status (20 per siswa)
INSERT INTO Presensi (id_siswa_kelas, tanggal_presensi, status_kehadiran)
SELECT
  ((i - 1) % (SELECT COUNT(*) FROM Siswa_Kelas)) + 1,
  CURRENT_DATE - ((i % 365) + ((i % 7))),
  (ARRAY['Hadir','Izin','Sakit','Alfa'])[((i-1) % 4) + 1]
FROM generate_series(1,200000) AS s(i);

-- 16) Nilai (40.000) - setiap siswa_kelas ada banyak nilai untuk 1 mapel
INSERT INTO Nilai (id_siswa_kelas, id_jenis_nilai, kode_mapel, nilai)
SELECT
  ((i - 1) % (SELECT COUNT(*) FROM Siswa_Kelas)) + 1,
  ((i - 1) % (SELECT COUNT(*) FROM Jenis_Nilai)) + 1,
  (SELECT kode_mapel FROM Mapel ORDER BY random() LIMIT 1),
  (ROUND((50 + (random() * 50))::numeric,2))::NUMERIC(5,2)
FROM generate_series(1,40000) AS s(i);

-- 17) Pendaftaran (10.000) - satu persiswa, didata sama staf tata usaha (random)
INSERT INTO Pendaftaran (nisn, tanggal_pendaftaran, id_karyawan)
SELECT
  'NISN' || LPAD(i::text,6,'0'),
  CURRENT_DATE - ((i % 365) + (i % 7)),
  ((i - 1) % (SELECT COUNT(*) FROM Staf_Tata_Usaha)) + 1
FROM generate_series(1,10000) AS s(i);





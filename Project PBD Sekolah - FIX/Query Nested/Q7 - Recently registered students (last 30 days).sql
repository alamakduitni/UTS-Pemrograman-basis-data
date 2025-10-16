SELECT s.nisn, s.nama_siswa, p.tanggal_pendaftaran, st.nama_karyawan
FROM Siswa s
JOIN Pendaftaran p ON p.nisn = s.nisn
JOIN Staf_Tata_Usaha st ON st.id_karyawan = p.id_karyawan
WHERE p.tanggal_pendaftaran >= CURRENT_DATE - INTERVAL '30 days';

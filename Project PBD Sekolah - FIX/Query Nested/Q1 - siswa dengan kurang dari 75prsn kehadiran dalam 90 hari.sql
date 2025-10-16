SELECT s.nisn, s.nama_siswa
FROM Siswa s
WHERE (
  SELECT (SUM(CASE WHEN p.status_kehadiran='Hadir' THEN 1 ELSE 0 END)::float / NULLIF(COUNT(*),0)) * 100
  FROM Presensi p
  JOIN Siswa_Kelas sk ON sk.id_siswa_kelas = p.id_siswa_kelas
  WHERE sk.nisn = s.nisn
    AND p.tanggal_presensi >= CURRENT_DATE - INTERVAL '90 days'
) < 75;

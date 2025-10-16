-- Daftar kontak orangtua untuk siswa yang hadir < 75% dalam 30 hari terakhir
SELECT
  s.nisn,
  s.nama_siswa,
  s.nama_ayah,
  s.no_hp_ayah,
  s.nama_ibu,
  s.no_hp_ibu
FROM Siswa s
WHERE s.nisn IN (
  SELECT sk.nisn
  FROM Siswa_Kelas sk
  JOIN Presensi p ON p.id_siswa_kelas = sk.id_siswa_kelas
  WHERE p.tanggal_presensi >= CURRENT_DATE - INTERVAL '30 days'
  GROUP BY sk.nisn
  HAVING (SUM(CASE WHEN p.status_kehadiran = 'Hadir' THEN 1 ELSE 0 END)::numeric
          / NULLIF(COUNT(*),0) * 100) < 75
)
ORDER BY s.nama_siswa;

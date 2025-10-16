-- Students with 5 or more 'Alfa' (unexcused absence) in last 30 days
SELECT s.nisn, s.nama_siswa,
  (
    SELECT COUNT(*)
    FROM Presensi p
    JOIN Siswa_Kelas sk ON sk.id_siswa_kelas = p.id_siswa_kelas
    WHERE sk.nisn = s.nisn
      AND p.tanggal_presensi >= CURRENT_DATE - INTERVAL '30 days'
      AND p.status_kehadiran = 'Alfa'
  ) AS alfa_count_last_30d
FROM Siswa s
WHERE (
    SELECT COUNT(*)
    FROM Presensi p
    JOIN Siswa_Kelas sk ON sk.id_siswa_kelas = p.id_siswa_kelas
    WHERE sk.nisn = s.nisn
      AND p.tanggal_presensi >= CURRENT_DATE - INTERVAL '30 days'
      AND p.status_kehadiran = 'Alfa'
) >= 5
ORDER BY alfa_count_last_30d DESC;

SELECT s.nisn, s.nama_siswa
FROM Siswa s
WHERE (
  SELECT AVG(n.nilai)
  FROM Nilai n
  JOIN Mapel m ON m.kode_mapel = n.kode_mapel
  JOIN Siswa_Kelas sk ON sk.id_siswa_kelas = n.id_siswa_kelas
  WHERE sk.nisn = s.nisn
) < (
  SELECT AVG(kkm) FROM Mapel
);

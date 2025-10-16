SELECT s.nisn, s.nama_siswa
FROM Siswa s
WHERE NOT EXISTS (
  SELECT 1 FROM Pembayaran p
  JOIN Tarif t ON t.id_tarif = p.id_tarif
  WHERE p.nisn = s.nisn
    AND t.nama_tarif = 'SPP Bulanan'
    AND p.id_tahun_ajaran = (SELECT id_tahun_ajaran FROM Tahun_Ajaran ORDER BY id_tahun_ajaran DESC LIMIT 1)
);

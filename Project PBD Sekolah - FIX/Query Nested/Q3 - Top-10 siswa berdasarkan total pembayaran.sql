SELECT s.nisn, s.nama_siswa,
  (
    SELECT COALESCE(SUM(p.jumlah_bayar),0) FROM Pembayaran p WHERE p.nisn = s.nisn
  ) AS total_bayar
FROM Siswa s
ORDER BY (SELECT COALESCE(SUM(p.jumlah_bayar),0) FROM Pembayaran p WHERE p.nisn = s.nisn) DESC
LIMIT 10;

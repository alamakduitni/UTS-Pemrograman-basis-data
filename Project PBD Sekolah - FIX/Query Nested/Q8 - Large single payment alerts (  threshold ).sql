SELECT p.id_pembayaran, p.nisn, p.jumlah_bayar, p.tanggal_pembayaran
FROM Pembayaran p
WHERE p.jumlah_bayar > 1000000  -- contoh threshold
  AND p.tanggal_pembayaran >= CURRENT_DATE - INTERVAL '1 year'
ORDER BY p.jumlah_bayar DESC;

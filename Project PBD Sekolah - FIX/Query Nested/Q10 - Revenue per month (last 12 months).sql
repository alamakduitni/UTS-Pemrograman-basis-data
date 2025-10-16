-- Revenue per month for last 12 months (including months with zero revenue)
SELECT to_char(gs.month_start, 'YYYY-MM') AS ym,
       COALESCE(SUM(p.jumlah_bayar), 0)::numeric(18,2) AS total_per_bulan
FROM generate_series(
       date_trunc('month', CURRENT_DATE) - INTERVAL '11 months',
       date_trunc('month', CURRENT_DATE),
       INTERVAL '1 month'
     ) AS gs(month_start)
LEFT JOIN LATERAL (
    SELECT * FROM Pembayaran p
    WHERE p.tanggal_pembayaran >= gs.month_start
      AND p.tanggal_pembayaran < (gs.month_start + INTERVAL '1 month')
) p ON true
GROUP BY gs.month_start
ORDER BY gs.month_start DESC;

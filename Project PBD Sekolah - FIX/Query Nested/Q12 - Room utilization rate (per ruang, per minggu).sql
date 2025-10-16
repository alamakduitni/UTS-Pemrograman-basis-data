-- ROOM UTILIZATION (recurring weekly schedule)
-- Asumsi: each row in Jadwal represents one weekly slot (e.g. Senin 07:00-08:30)
-- Adjust "8" if your school uses different timeslots/day.
SELECT r.kode_ruang,
       ROUND(
         ( (
             SELECT COUNT(*)
             FROM Jadwal jd
             WHERE jd.id_ruang_kelas IN (
               SELECT rk.id_ruang_kelas FROM Ruang_Kelas rk WHERE rk.kode_ruang = r.kode_ruang
             )
               AND jd.id_tahun_ajaran = (
                 SELECT id_tahun_ajaran FROM Tahun_Ajaran ORDER BY id_tahun_ajaran DESC LIMIT 1
               )
           )::numeric
           / (7 * 8)  -- 7 days * 8 timeslots/day
         ) * 100, 2
       ) AS utilization_pct
FROM Ruang r
ORDER BY r.kode_ruang;

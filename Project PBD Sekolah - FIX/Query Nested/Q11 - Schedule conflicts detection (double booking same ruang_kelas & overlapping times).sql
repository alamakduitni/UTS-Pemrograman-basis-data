SELECT jd1.id_jadwal AS jadwal1,
       jd2.id_jadwal AS jadwal2,
       jd1.id_ruang_kelas,
       jd1.jam_mulai AS jam1_start, jd1.jam_selesai AS jam1_end,
       jd2.jam_mulai AS jam2_start, jd2.jam_selesai AS jam2_end
FROM Jadwal jd1
JOIN Jadwal jd2
  ON jd1.id_jadwal < jd2.id_jadwal
 AND jd1.id_ruang_kelas = jd2.id_ruang_kelas
 AND jd1.id_tahun_ajaran = jd2.id_tahun_ajaran
 -- cek overlap waktu
 AND jd1.jam_mulai < jd2.jam_selesai
 AND jd2.jam_mulai < jd1.jam_selesai
ORDER BY jd1.id_ruang_kelas, jd1.jam_mulai;

SELECT g.nip, g.nama_guru,
  (SELECT COUNT(*) FROM Jadwal jd WHERE jd.nip_guru = g.nip AND jd.id_tahun_ajaran = (SELECT id_tahun_ajaran FROM Tahun_Ajaran ORDER BY id_tahun_ajaran DESC LIMIT 1)) AS jumlah_jadwal
FROM Guru g
ORDER BY jumlah_jadwal DESC;

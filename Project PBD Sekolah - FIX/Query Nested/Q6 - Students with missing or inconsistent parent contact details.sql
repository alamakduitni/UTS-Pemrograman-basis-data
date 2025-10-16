SELECT s.nisn, s.nama_siswa
FROM Siswa s
WHERE s.no_hp_ayah IS NULL OR length(trim(s.no_hp_ayah)) < 8
   OR s.no_hp_ibu IS NULL OR length(trim(s.no_hp_ibu)) < 8;

-- Students whose overall average (across all mapel) is below the average grade of their jurusan's mapel
-- Step: determine student's avg; compare against jurusan avg (mapel-level avg for jurusan)
SELECT s.nisn, s.nama_siswa,
  COALESCE(
    (
      SELECT ROUND(AVG(n.nilai)::numeric,2)
      FROM Nilai n
      JOIN Siswa_Kelas sk ON sk.id_siswa_kelas = n.id_siswa_kelas
      WHERE sk.nisn = s.nisn
    ), 0
  ) AS avg_student
FROM Siswa s
WHERE COALESCE(
        (
          SELECT AVG(n.nilai)
          FROM Nilai n
          JOIN Siswa_Kelas sk ON sk.id_siswa_kelas = n.id_siswa_kelas
          WHERE sk.nisn = s.nisn
        ), 0
      )
    <
      COALESCE(
        (
          SELECT AVG(n2.nilai)
          FROM Nilai n2
          JOIN Mapel m ON m.kode_mapel = n2.kode_mapel
          WHERE m.kode_jurusan = (
            -- assume student has at least one Siswa_Kelas; take student's current jurusan via a mapel they took
            -- if you want to use student's class->jurusan mapping, adapt accordingly
            (SELECT kode_jurusan FROM Mapel WHERE kode_mapel = (
                 SELECT n3.kode_mapel FROM Nilai n3
                 JOIN Siswa_Kelas sk3 ON sk3.id_siswa_kelas = n3.id_siswa_kelas
                 WHERE sk3.nisn = s.nisn
                 LIMIT 1
            ) LIMIT 1)
          )
        ), 0
      );

UPDATE Artikly_Artikl SET
	RadaKod_ID = Rada.ID,
	RadaKatalog_ID = NULL
FROM Artikly_Artikl AS Artikl
INNER JOIN Ciselniky_CiselnaRada AS Rada ON Rada.Kod = 'KATALOG';
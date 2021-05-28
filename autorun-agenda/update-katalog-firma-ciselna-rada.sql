UPDATE Artikly_Artikl SET
	RadaKod_ID = Rada.ID
FROM Artikly_Artikl AS Artikl
INNER JOIN Ciselniky_CiselnaRada AS Rada ON Rada.Kod = 'KATALOG';

UPDATE Adresar_Firma SET
	CiselnaRada_ID = Rada.ID
FROM Adresar_Firma AS Firma
INNER JOIN Ciselniky_CiselnaRada AS Rada ON Rada.Kod = 'ADRES';
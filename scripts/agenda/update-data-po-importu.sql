-- do firem nastavi ciselnou radu po importu
-- aby pri kopirovani priradilo spravnou ciselnou radu
UPDATE Adresar_Firma SET
	CiselnaRada_ID = Rada.ID
FROM Adresar_Firma AS Firma
INNER JOIN Ciselniky_CiselnaRada AS Rada ON Rada.Kod = 'ADRES'
WHERE CiselnaRada_ID IS NULL;

-- vyprazdni nastaveni zpusobu platby u odberatelu
UPDATE Adresar_Firma SET
	ZpusobPlatby_ID = NULL
FROM Adresar_Firma AS Firma;

-- smaze ze zpravy prazdne radky na konci a na zacatku
UPDATE Adresar_Firma SET Zprava = SUBSTRING(Zprava, 1, LEN(Zprava)-2) FROM Adresar_Firma WHERE Zprava LIKE '%' + CHAR(13) + CHAR(10);
UPDATE Adresar_Firma SET Zprava = SUBSTRING(Zprava, 1, LEN(Zprava)-2) FROM Adresar_Firma WHERE Zprava LIKE '%' + CHAR(13) + CHAR(10);
UPDATE Adresar_Firma SET Zprava = SUBSTRING(Zprava, 3, LEN(Zprava)-2) FROM Adresar_Firma WHERE Zprava LIKE CHAR(13) + CHAR(10) + '%';
UPDATE Adresar_Firma SET Zprava = SUBSTRING(Zprava, 3, LEN(Zprava)-2) FROM Adresar_Firma WHERE Zprava LIKE CHAR(13) + CHAR(10) + '%';

-- do artiklu nastavi ciselnou radu pi improtu
-- aby pri kopirovani priradilo spravnou ciselnou radu
UPDATE Artikly_Artikl SET
	RadaKod_ID = Rada.ID
FROM Artikly_Artikl AS Artikl
INNER JOIN Ciselniky_CiselnaRada AS Rada ON Rada.Kod = 'KATALOG';

-- do artiklu nastavi u nuloveho druhu zbozi
UPDATE Artikly_Artikl SET
	DruhArtiklu_ID = (SELECT TOP 1 ID FROM Ciselniky_DruhArtiklu AS DruhArtiklu WHERE DruhArtiklu.Kod = 'ZBO')
FROM Artikly_Artikl AS Artikl
WHERE Artikl.DruhArtiklu_ID IS NULL;

-- resetuje vsechny stitky
UPDATE Artikly_Artikl SET
	StitekNazev_UserData = ArtStitek.Nazev,
	StitekBaleni_UserData = ArtStitek.BaleniMnozstvi, 
	StitekBaleniJed_UserData = ArtStitek.BaleniJednotky, 
	StitekCena_UserData = ArtStitek.ProdejniCena, 
	StitekMnozstvi_UserData = ArtStitek.Mnozstvi,
	StitekSazba_UserData = ArtDph.Sazba,
	StitekTisk_UserData = 0
FROM Artikly_Artikl AS Art
INNER JOIN USER_ArtiklyStitek AS ArtStitek ON Art.ID = ArtStitek.ID
INNER JOIN USER_ArtiklyDph AS ArtDph ON ArtDph.ID = Art.ID;

-- aktualizuje zakladni udaje na konceptu pro seky
UPDATE Ucetnictvi_InterniDoklad SET
	Nazev = 'NEMAZAT koncept šeku',
	DatumVystaveni = DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0),
	Create_Date = DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0),
	Modify_Date = DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)
FROM Ucetnictvi_InterniDoklad AS ID
WHERE ID.CisloDokladu = '_SK000000';
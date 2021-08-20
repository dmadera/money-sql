CREATE OR ALTER TRIGGER USER_Artikly_Artikl_AfterInsertUpdate
ON Artikly_Artikl
AFTER INSERT, UPDATE
AS
BEGIN

	IF SESSION_CONTEXT(N'USER_Artikly_Artikl_AfterInsertUpdate') = 'disable'
		RETURN; 

	UPDATE Artikly_Artikl SET 
		BaleniJednotky_UserData = ISNULL(ArtBal.Jednotky, ''),
		BaleniMnozstvi_UserData = ISNULL(ArtBal.Mnozstvi, ''),
		KategorieRetezec_UserData = ISNULL(ArtKat.KategorieRetezec, ''),
		Kategorie = ISNULL(ArtKat.Kategorie, ''),
		NepodlehatSleveDokladu = IIF(ArtDruh.Kod = 'OBA', 1, inserted.NepodlehatSleveDokladu)
	FROM Artikly_Artikl AS Art
	INNER JOIN inserted ON inserted.ID = Art.ID
	INNER JOIN Ciselniky_DruhArtiklu AS ArtDruh ON ArtDruh.ID = Art.DruhArtiklu_ID
	LEFT JOIN USER_ArtiklyBaleni AS ArtBal ON ArtBal.Artikl_ID = Art.ID
	LEFT JOIN USER_ArtiklyKategorie AS ArtKat ON ArtKat.Artikl_ID = Art.ID;

	UPDATE Artikly_Artikl SET
		StitekNazev_UserData = ArtStitek.Nazev,
		StitekBaleni_UserData = ArtStitek.BaleniMnozstvi, 
		StitekBaleniJed_UserData = ArtStitek.BaleniJednotky,
		StitekCena_UserData = ArtStitek.ProdejniCena, 
		StitekMnozstvi_UserData = ArtStitek.Mnozstvi,
		StitekSazba_UserData = ISNULL(Sazba.Sazba, 0),
		StitekTisk_UserData = 1
	FROM inserted
	INNER JOIN USER_ArtiklyStitek AS ArtStitek ON inserted.ID = ArtStitek.ID
	INNER JOIN Artikly_Artikl AS Art ON Art.ID = ArtStitek.ID
	LEFT JOIN USER_ARtiklyDph AS Sazba ON Sazba.ID = Art.ID
	WHERE 
		Art.StitekTisk_UserData = 0 AND (
			Art.StitekNazev_UserData != ArtStitek.Nazev
			OR Art.StitekBaleni_UserData != ArtStitek.BaleniMnozstvi
			OR Art.StitekBaleniJed_UserData != ArtStitek.BaleniJednotky
			OR Art.StitekSazba_UserData != Sazba.Sazba
			OR Art.StitekCena_UserData != ArtStitek.ProdejniCena
			OR (Art.StitekMnozstvi_UserData = 0 AND ArtStitek.Mnozstvi > 0)
		);

	UPDATE Ceniky_PolozkaCeniku SET
		Locked = 0
	FROM  Ceniky_PolozkaCeniku AS Cena
	WHERE Cena.Locked = 1;
END
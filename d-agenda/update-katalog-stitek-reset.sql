SET Context_Info 0x55554;

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
INNER JOIN USER_ArtiklyDph AS ArtDph ON ArtDph.ID = Art.ID
WHERE Art.StitekTisk_UserData != 1
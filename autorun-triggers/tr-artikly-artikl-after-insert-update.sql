CREATE OR ALTER TRIGGER TR_Artikly_Artikl_AfterInsertUpdate
ON Artikly_Artikl
AFTER INSERT, UPDATE
AS
BEGIN

	IF Context_Info() = 0x55554
		RETURN; 

	DECLARE @VychoziCenik_ID AS UNIQUEIDENTIFIER;
	SET @VychoziCenik_ID = (SELECT TOP 1 Agenda.VychoziCenik_ID FROM System_AgendaDetail AS Agenda);

	DECLARE @NakupniCenik_ID AS UNIQUEIDENTIFIER;
	SET @NakupniCenik_ID = (SELECT TOP 1 ID FROM Ceniky_Cenik AS Cenik WHERE Cenik.Kod = '_NAKUP');

	DECLARE @VychoziSklad_ID AS UNIQUEIDENTIFIER;
	SET @VychoziSklad_ID = (SELECT TOP 1 Agenda.VychoziSklad_ID FROM System_AgendaDetail AS Agenda);

	-- produktove klice - spoji jako retezec do UserData pole
	UPDATE Artikly_Artikl SET 
		Priznaky_UserData = ISNULL(ArtPriz.Priznaky, ''),
		BaleniJednotky_UserData = ISNULL(ArtBal.Jednotky, ''),
		BaleniMnozstvi_UserData = ISNULL(ArtBal.Mnozstvi, ''),
		KategorieRetezec_UserData = ISNULL(ArtKat.KategorieRetezec, ''),
		Kategorie = ISNULL(ArtKat.Kategorie, '')
	FROM Artikly_Artikl AS Art
	INNER JOIN inserted ON inserted.ID = Art.ID
	LEFT JOIN USER_ArtiklyBaleni AS ArtBal ON ArtBal.Artikl_ID = Art.ID
	LEFT JOIN USER_ArtiklyPriznaky AS ArtPriz ON ArtPriz.Artikl_ID = Art.ID
	LEFT JOIN USER_ArtiklyKategorie AS ArtKat ON ArtKat.Artikl_ID = Art.ID;

	SET Context_Info 0x55555;

	UPDATE Ceniky_PolozkaCeniku SET 
		SkladovaCena_UserData = PolCen.SkladovaCena,
		Marze_UserData = PolCen.Marze,
		Cena = PolCen.Cena,
		BudouciCena = IIF(PolCen.Marze <> Cena.Marze_UserData, PolCen.BudouciCena, 0),
		Cena25_UserData = PolCen.Cena25,
		CisloDokladu_UserData = ISNULL(PoslPrijem.CisloDokladu, ''),
		DatumZmenyZasoby_UserData = IIF(PoslPrijem.Datum IS NULL, '', FORMAT(PoslPrijem.Datum, 'yyyy.MM.dd HH:mm:ss')),
		PosledniNaskladneni_UserData = ISNULL(PoslPrijem.Datum, CAST('1753-01-01 00:00:00' AS DATETIME)),
		VypocetVyseZmeny = 0,
		NepodlehatSleveDokladu = PolCen.NepodlehaSleveDokladu,
		Priznaky_UserData = Artikl.Priznaky_UserData,
		DruhPolozkyKatalogu_UserData = Druh.Nazev
	FROM Ceniky_PolozkaCeniku AS Cena
	INNER JOIN inserted ON inserted.ID = Cena.Artikl_ID
	INNER JOIN Artikly_Artikl AS Artikl ON Artikl.ID = Cena.Artikl_ID
	INNER JOIN Ciselniky_DruhArtiklu AS Druh ON Druh.ID = Artikl.DruhArtiklu_ID
	INNER JOIN USER_PolozkyCeniku AS PolCen ON PolCen.ID = Cena.ID
	LEFT JOIN USER_PosledniPrijemZasoby AS PoslPrijem ON PoslPrijem.Zasoba_ID = PolCen.Zasoba_ID;


	UPDATE Artikly_Artikl SET	
		NakupniCena_UserData = Cena.SkladovaCena_UserData,
		Marze_UserData = Cena.Marze_UserData
	FROM Artikly_Artikl AS Artikl
	INNER JOIN inserted ON inserted.ID = Artikl.ID
	INNER JOIN Ceniky_PolozkaCeniku AS Cena ON Cena.Artikl_ID = Artikl.ID AND Cena.Cenik_ID = @VychoziCenik_ID;
	
	UPDATE Sklady_Zasoba SET
		BaleniMnozstvi_UserData = Artikl.BaleniMnozstvi_UserData,
		BaleniJednotky_UserData = Artikl.BaleniJednotky_UserData,
		Priznaky_UserData = Artikl.Priznaky_UserData,
		NakupniCena_UserData = Artikl.NakupniCena_UserData,
		Marze_UserData = Artikl.Marze_UserData,
		DruhArtiklu_ID = Artikl.DruhArtiklu_ID,
		DruhPolozkyKatalogu_UserData = Druh.Nazev
	FROM Sklady_Zasoba AS Zasoba
	INNER JOIN inserted ON inserted.ID = Zasoba.Artikl_ID
	INNER JOIN Artikly_Artikl AS Artikl ON Artikl.ID = Zasoba.Artikl_ID
	INNER JOIN Ciselniky_DruhArtiklu AS Druh ON Druh.ID = Artikl.DruhArtiklu_ID;
	
END
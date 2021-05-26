CREATE OR ALTER TRIGGER TR_Artikly_Artikl_AfterInsertUpdate
ON Artikly_Artikl
AFTER INSERT, UPDATE
AS
BEGIN

	DECLARE @VychoziCenik_ID AS UNIQUEIDENTIFIER;
	SET @VychoziCenik_ID = (SELECT TOP 1 Agenda.VychoziCenik_ID FROM System_AgendaDetail AS Agenda);

	DECLARE @NakupniCenik_ID AS UNIQUEIDENTIFIER;
	SET @NakupniCenik_ID = (SELECT TOP 1 ID FROM Ceniky_Cenik AS Cenik WHERE Cenik.Kod = '_NAKUP');

	DECLARE @VychoziSklad_ID AS UNIQUEIDENTIFIER;
	SET @VychoziSklad_ID = (SELECT TOP 1 Agenda.VychoziSklad_ID FROM System_AgendaDetail AS Agenda);

	DISABLE TRIGGER ALL ON Ceniky_PolozkaCeniku;
	
	UPDATE Ceniky_PolozkaCeniku SET 
		SkladovaCena_UserData = ROUND(StavCena.JednotkovaSkladovaCena, 2),
		Marze_UserData = ROUND(CASE
			WHEN Cena.Cenik_ID = @NakupniCenik_ID THEN 0
			WHEN StavCena.JednotkovaSkladovaCena = 0 THEN 0
			ELSE 100 / StavCena.JednotkovaSkladovaCena * (StavCena.JednotkovaCenikovaCena - StavCena.JednotkovaSkladovaCena) END, 2),
		Cena = ROUND(CASE
			WHEN Cena.Cenik_ID = @NakupniCenik_ID THEN StavCena.JednotkovaSkladovaCena
			WHEN StavCena.JednotkovaSkladovaCena = 0 THEN 0
			WHEN Cena.Cena = 0 THEN StavCena.JednotkovaSkladovaCena * 1.25
			ELSE Cena.Cena END, 2),
		CisloDokladu_UserData = ISNULL(Pohyb.CisloDokladu, ''),
		Sklad_ID = @VychoziSklad_ID,
		NepodlehatSleveDokladu = IIF(Cena.Cenik_ID = @VychoziCenik_ID OR Cena.Cenik_ID = @NakupniCenik_ID, 0, 1),
		DatumZmenyZasoby_UserData = IIF(Pohyb.Datum IS NULL, '', FORMAT(Pohyb.Datum, 'yyyy.MM.dd HH:mm:ss'))
	FROM Ceniky_PolozkaCeniku AS Cena
	INNER JOIN inserted AS Artikl ON Artikl.ID = Cena.Artikl_ID
	INNER JOIN Sklady_Zasoba AS Zasoba ON Zasoba.Artikl_ID = Artikl.ID
	INNER JOIN CSW_BI_StavSkladuVCenach AS StavCena ON StavCena.Artikl_ID = Cena.Artikl_ID AND StavCena.Sklad_ID = Cena.Sklad_ID 
	LEFT JOIN (
		SELECT 
			Pohyb.Konto_ID,
			ISNULL(MAX(Pohyb.Modify_Date), MAX(Pohyb.Create_Date)) AS Datum
		FROM S5_Sklady_PohybZasobyPrehled AS Pohyb
		WHERE Pohyb.DruhPohybu = 0
		GROUP BY Pohyb.Konto_ID
	) AS SubPohyb ON SubPohyb.Konto_ID = Zasoba.ID
	LEFT JOIN (
		SELECT Konto_ID, CisloDokladu, ISNULL(Modify_Date, Create_Date) AS Datum
		FROM S5_Sklady_PohybZasobyPrehled
	) AS Pohyb ON Pohyb.Konto_ID = SubPohyb.Konto_ID AND Pohyb.Datum = SubPohyb.Datum;

	ENABLE TRIGGER ALL ON Ceniky_PolozkaCeniku;

	UPDATE Artikly_Artikl SET	
		NakupniCena_UserData = Cena.SkladovaCena_UserData,
		Marze_UserData = Cena.Marze_UserData
	FROM Artikly_Artikl AS Artikl
	INNER JOIN inserted ON inserted.ID = Artikl.ID
	INNER JOIN Ceniky_PolozkaCeniku AS Cena ON Cena.Artikl_ID = Artikl.ID AND Cena.Cenik_ID = @VychoziCenik_ID;

	-- produktove klice - spoji jako retezec do UserData pole
	UPDATE Artikly_Artikl SET 
		Artikly_Artikl.Priznaky_UserData=SQ.Priznaky_UserData
	FROM (
		SELECT
			inserted.ID as ID,
			STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(Artikly_ProduktovyKlic.Kod, '')), ' ') WITHIN GROUP (ORDER BY Artikly_ProduktovyKlic.Kod ASC) AS Priznaky_UserData
		FROM inserted
		RIGHT JOIN Artikly_ArtiklProduktovyKlic ON Artikly_ArtiklProduktovyKlic.Parent_ID=inserted.ID
		INNER JOIN Artikly_ProduktovyKlic ON Artikly_ProduktovyKlic.ID = Artikly_ArtiklProduktovyKlic.ProduktovyKlic_ID
		WHERE LEN(Artikly_ProduktovyKlic.Kod) = 1
		GROUP BY inserted.ID
	) AS SQ
	WHERE Artikly_Artikl.ID = SQ.ID;

	-- jednotky - nastavi prodejni jednotku prvni pod hlavni, pocet prodejni jednotky nastavi do UserData pole
	UPDATE Artikly_Artikl SET
	Artikly_Artikl.ProdejniJednotka_ID = ISNULL(SQ.ProdejniJednotka_ID, Artikly_ArtiklJednotka.ID),
	Artikly_Artikl.NakupniJednotka_ID = ISNULL(SQ.ProdejniJednotka_ID, Artikly_ArtiklJednotka.ID)
	FROM (
		SELECT
			MinMnozstviT.Parent_ID AS ID, 
			MinMnozstviT.VychoziMnozstvi AS ProdJednotkaMnozstvi_UserData, 
			Artikly_ArtiklJednotka.ID AS ProdejniJednotka_ID
		FROM Artikly_Artikl
		INNER JOIN (
			SELECT 
				Artikly_ArtiklJednotka.Parent_ID as Parent_ID, MIN(VychoziMnozstvi) as VychoziMnozstvi
			FROM  Artikly_ArtiklJednotka
			WHERE Artikly_ArtiklJednotka.ParentJednotka_ID IS NOT NULL
			GROUP BY Artikly_ArtiklJednotka.Parent_ID
		) MinMnozstviT ON Artikly_Artikl.ID = MinMnozstviT.Parent_ID
		INNER JOIN Artikly_ArtiklJednotka ON 
			Artikly_ArtiklJednotka.Parent_ID = Artikly_Artikl.ID AND 
			MinMnozstviT.VychoziMnozstvi = Artikly_ArtiklJednotka.VychoziMnozstvi
	) AS SQ
	RIGHT JOIN Artikly_ArtiklJednotka ON Artikly_ArtiklJednotka.Parent_ID = SQ.ID
	INNER JOIN Artikly_Artikl ON Artikly_ArtiklJednotka.Parent_ID = Artikly_Artikl.ID
	WHERE 
		Artikly_ArtiklJednotka.ParentJednotka_ID IS NULL AND
		Artikly_ArtiklJednotka.Deleted = 0 AND
		Artikly_Artikl.ID IN (SELECT ID FROM inserted);

	UPDATE Artikly_Artikl SET
		BaleniMnozstvi_UserData = Bal.Mnozstvi,
		BaleniJednotky_UserData = Bal.Jednotky
	FROM Artikly_Artikl AS Art
	INNER JOIN (
		SELECT 
			ArtJed.Parent_ID as Parent_ID, 
			STRING_AGG(FORMAT(ArtJed.VychoziMnozstvi, '#' ), '/') WITHIN GROUP (ORDER BY VychoziMnozstvi DESC) AS Mnozstvi,
			STRING_AGG(ArtJed.Kod, '/') WITHIN GROUP (ORDER BY VychoziMnozstvi DESC)  AS Jednotky
		FROM (
			SELECT AJ.VychoziMnozstvi, AJ.Kod, AJ.Parent_ID, AJ.Jednotka_ID, ParentJednotka_ID
			FROM Artikly_ArtiklJednotka AS AJ
			INNER JOIN inserted ON inserted.ID = AJ.Parent_ID 
		) AS ArtJed
		INNER JOIN Ciselniky_Jednotka AS Jed ON Jed.ID = ArtJed.Jednotka_ID
		WHERE ArtJed.ParentJednotka_ID IS NOT NULL AND Jed.KartonovaJednotka_UserData = 1
		GROUP BY ArtJed.Parent_ID
	) Bal ON Art.ID = Bal.Parent_ID;
	
	-- jednotky - u dodavatele nastavi prodejni jednotku
	UPDATE Artikly_ArtiklDodavatel SET
		Jednotka_ID = ArtJed.Jednotka_ID,
		ArtiklJednotka_ID = ArtJed.ID
	FROM Artikly_ArtiklDodavatel AS ArtDod
	INNER JOIN inserted ON inserted.ID = ArtDod.Parent_ID
	INNER JOIN Artikly_Artikl AS Artikl ON Artikl.ID = ArtDod.Parent_ID
	INNER JOIN Artikly_ArtiklJednotka AS ArtJed ON ArtJed.ID = Artikl.NakupniJednotka_ID;

	-- jednotky - nastavi u vedlejsich jednotek aktualizovanych artiklu nedelitelne mnozstvi na 0
	-- nastavi sazbu DPH
	UPDATE Artikly_ArtiklJednotka SET
		Artikly_ArtiklJednotka.NedelitelneMnozstvi = 0.0
	FROM Artikly_ArtiklJednotka AS Jednotka
	INNER JOIN inserted ON inserted.ID = Jednotka.Parent_ID
	WHERE ParentJednotka_ID IS NOT NULL;

	
	UPDATE Artikly_Artikl SET
		SazbaDPH_UserData = CONCAT(STR(Sazba.Sazba, 2, 0), '%')
	FROM Artikly_Artikl AS Art
	INNER JOIN inserted ON inserted.ID = Art.ID
	INNER JOIN (
		SELECT ArtSazba.Parent_ID AS Parent_ID, MAX(ArtSazba.Zacatek) AS Zacatek
		FROM Artikly_ArtiklDPH AS ArtSazba
		INNER JOIN EconomicBase_SazbaDPH AS Sazba ON Sazba.DruhSazby = ArtSazba.SazbaVystup AND Sazba.PlatnostDo >= GETDATE()
		WHERE ArtSazba.Zacatek <= GETDATE()
		GROUP BY ArtSazba.Parent_ID
	) AS ArtSazbaSub ON ArtSazbaSub.Parent_ID = Art.ID
	INNER JOIN Artikly_ArtiklDPH AS ArtSazba ON ArtSazba.Parent_ID = ArtSazbaSub.Parent_ID AND ArtSazba.Zacatek = ArtSazbaSub.Zacatek
	INNER JOIN EconomicBase_SazbaDPH AS Sazba ON Sazba.DruhSazby = ArtSazba.SazbaVystup AND Sazba.PlatnostDo >= GETDATE();
	
	-- kategorie - naplnit uzivatelsky sloupec kategorii
	WITH Tree (ID, Nazev, ParentObject_ID, Level, KompletniCesta, ListID) AS (
		-- anchor:
		SELECT 
			ID, Nazev, ParentObject_ID, 0, CAST(Nazev AS varchar(max)), CAST(ID AS varchar(max))
		FROM Artikly_KategorieArtiklu WHERE ParentObject_ID IS NULL
		UNION ALL
		-- recursive:
		SELECT 
			t.ID, t.Nazev, t.ParentObject_ID, Tree.Level + 1, 
			CAST(CONCAT(Tree.KompletniCesta, ' > ', t.Nazev) AS VARCHAR(max)),
			CAST(CONCAT(Tree.ListID, '|', t.ID) AS VARCHAR(max))
		FROM Tree 
		INNER JOIN Artikly_KategorieArtiklu AS t ON t.ParentObject_ID = Tree.ID
	)
	UPDATE Artikly_Artikl SET
		KategorieRetezec_UserData = SQ.Kategorie_UserData,
		Kategorie = SQ.Kategorie
	FROM Artikly_Artikl AS Art
	INNER JOIN inserted ON inserted.ID = Art.ID
	RIGHT JOIN (
		SELECT 
			Art.ID AS ID,
			STRING_AGG(Kat.KompletniCesta, ' @ ') AS Kategorie_UserData,
			LOWER(STRING_AGG(Kat.ListID, '|')) AS Kategorie
		FROM Artikly_Artikl AS Art
		CROSS APPLY STRING_SPLIT(Art.Kategorie, '|') AS ArtKat
		INNER JOIN (
			SELECT 
				ID, KompletniCesta, ListID 
			FROM Tree
			WHERE ParentObject_ID IS NOT NULL
		) AS Kat ON CAST(Kat.ID AS varchar(100)) = ArtKat.value
		GROUP BY Art.ID
	) AS SQ ON SQ.ID = Art.ID
	OPTION (MAXRECURSION 3);
	
	UPDATE Sklady_Zasoba SET
		BaleniMnozstvi_UserData = Artikl.BaleniMnozstvi_UserData,
		BaleniJednotky_UserData = Artikl.BaleniJednotky_UserData,
		Priznaky_UserData = Artikl.Priznaky_UserData,
		NakupniCena_UserData = Artikl.NakupniCena_UserData,
		Marze_UserData = Artikl.Marze_UserData
	FROM Sklady_Zasoba AS Zasoba
	INNER JOIN inserted ON inserted.ID = Zasoba.Artikl_ID
	INNER JOIN Artikly_Artikl AS Artikl ON Artikl.ID = Zasoba.Artikl_ID;
	
END
CREATE OR ALTER TRIGGER TR_Artikly_Artikl_AfterInsertUpdate
ON Artikly_Artikl
AFTER INSERT, UPDATE
AS
BEGIN

	UPDATE Artikly_Artikl SET	
		NakupniCena_UserData = StavCena.JednotkovaSkladovaCena,
		Marze_UserData = IIF(StavCena.JednotkovaSkladovaCena = 0, 0, ROUND(100/StavCena.JednotkovaSkladovaCena*(StavCena.JednotkovaCenikovaCena-StavCena.JednotkovaSkladovaCena), 2))
	FROM Artikly_Artikl AS Artikl
	INNER JOIN inserted ON inserted.ID = Artikl.ID
	INNER JOIN CSW_BI_StavSkladuVCenach AS StavCena ON StavCena.Artikl_ID = Artikl.ID

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
	UPDATE Artikly_ArtiklJednotka SET
		Artikly_ArtiklJednotka.NedelitelneMnozstvi = 0.0
	FROM Artikly_ArtiklJednotka AS Jednotka
	INNER JOIN inserted ON inserted.ID = Jednotka.Parent_ID
	WHERE ParentJednotka_ID IS NOT NULL;

	-- nastavi sazbu DPH
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
	
	-- zapise k zasobe denni prodej AVG a MED

	DECLARE @PocetDniMinZasoby AS INT;
	SET @PocetDniMinZasoby = 20;

	UPDATE Sklady_Zasoba SET
		BaleniMnozstvi_UserData = Artikl.BaleniMnozstvi_UserData,
		BaleniJednotky_UserData = Artikl.BaleniJednotky_UserData,
		Priznaky_UserData = Artikl.Priznaky_UserData,
		NakupniCena_UserData = Artikl.NakupniCena_UserData,
		Marze_UserData = Artikl.Marze_UserData,
		ProdejMinAVG_UserData = CASE
			WHEN PocitatProdej = 0 THEN -1
			WHEN ZasobaAVG.Zasoba_ID IS NULL THEN 0
			ELSE ROUND(ZasobaAVG.SumMnozstvi / DATEDIFF(dd, ZasobaAVG.PrvniPohyb, GETDATE()) * @PocetDniMinZasoby, 0) END,
		ProdejMinMED_UserData = CASE
			WHEN PocitatProdej = 0 THEN -1
			WHEN ZasobaMED.Zasoba_ID IS NULL THEN 0
			ELSE ROUND(ZasobaMED.SumMedian / DATEDIFF(dd, ZasobaMED.PrvniPohyb, GETDATE()) * @PocetDniMinZasoby, 0) END
	FROM Sklady_Zasoba AS Zasoba
	INNER JOIN inserted ON inserted.ID = Zasoba.Artikl_ID
	INNER JOIN Artikly_Artikl AS Artikl ON Artikl.ID = Zasoba.Artikl_ID
	LEFT JOIN (
		SELECT 
			Artikl.ID AS ID,
			ISNULL(MIN(CAST(PocitatProdejZasob_UserData AS INT)), 0) AS PocitatProdej,
			MIN(Artikl.NakupniCena_UserData) AS NakupniCena_UserData,
			MIN(Marze_UserData) AS Marze_UserData
		FROM Artikly_Artikl AS Artikl
		LEFT JOIN Artikly_ArtiklProduktovyKlic AS ArtProdKlic ON ArtProdKlic.Parent_ID = Artikl.ID
		LEFT JOIN Artikly_ProduktovyKlic AS ProdKlic ON ProdKlic.ID = ArtProdKlic.ProduktovyKlic_ID
		GROUP BY Artikl.ID
	) AS Artikl1 ON Artikl1.ID = Zasoba.Artikl_ID
	LEFT JOIN (
		SELECT 
			Pohyb.Konto_ID AS Zasoba_ID, 
			SUM(Pohyb.Mnozstvi) AS SumMnozstvi,
			MIN(Pohyb.Datum) AS PrvniPohyb
		FROM Sklady_PohybZasoby AS Pohyb
		WHERE Pohyb.DruhPohybu = 1
		GROUP BY Pohyb.Konto_ID
	) AS ZasobaAVG ON ZasobaAVG.Zasoba_ID = Zasoba.ID
	LEFT JOIN (
		SELECT 
			Zas.ID AS Zasoba_ID, 
			MAX(Median.Median) * COUNT(Zas.ID) AS SumMedian, 
			Min(Median.DatumPohybu) AS PrvniPohyb
		FROM Sklady_Zasoba AS Zas
		INNER JOIN (
			SELECT 
				Pohyb.Konto_ID AS Zasoba_ID, 
				Datum AS DatumPohybu, 
				PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Mnozstvi) OVER (PARTITION BY Pohyb.Konto_ID) AS Median 
			FROM Sklady_PohybZasoby AS Pohyb
			WHERE Pohyb.DruhPohybu = 1
		) AS Median ON Median.Zasoba_ID = Zas.ID
		GROUP BY Zas.ID
	) AS ZasobaMED ON ZasobaMED.Zasoba_ID = Zasoba.ID;

END
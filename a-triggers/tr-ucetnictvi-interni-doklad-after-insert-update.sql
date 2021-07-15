CREATE OR ALTER TRIGGER USER_Ucetnictvi_InterniDoklad_AfterInsert
ON Ucetnictvi_InterniDoklad
AFTER UPDATE
AS
BEGIN
	UPDATE Ucetnictvi_InterniDoklad SET 
		Nazev = CASE
			WHEN ID.CisloDokladu =  '_SK000000'
				THEN 'NEMAZAT koncept šeku'
			WHEN D.CisloDokladu IS NULL OR D.Deleted = 1 
				THEN 'Neplatný šek - doklad zrušen'
			WHEN D.Deleted = 0 AND (D.SumaCelkem < 5000 OR (Fir.VlastniSleva = 1 AND Fir.HodnotaSlevy <> 0) OR Fir.Sek_UserData = '-SEK') 
				THEN 'Neplatný šek - doklad nesplňuje požadavky'
			WHEN D.Deleted = 0 AND D.SumaSek <> ID.SumaCelkem
				THEN CONCAT(IIF(ID.Faze = 0, 'Šek vydaný na částku ', 'Neplatný šek - opravte na částku '), CONVERT(NUMERIC(10,2), D.SumaSek), ' Kč')
			WHEN D.Deleted = 0 AND D.Firma_ID <> ID.Firma_ID 
				THEN CONCAT('Neplatný šek - opravte na odběratele ', Fir.Kod)
			ELSE 'Šek vydaný'
		END
	FROM Ucetnictvi_InterniDoklad AS ID
	INNER JOIN inserted ON inserted.ID = ID.ID
	INNER JOIN System_Groups AS Grp ON Grp.ID = ID.Group_ID
	LEFT JOIN (
		SELECT 
			CisloDokladu, SumaCelkem, Firma_ID, PR.Deleted,
			ROUND(CASE 
				WHEN PR.SumaCelkem >= 10000 THEN PR.SumaCelkem / 100 * 1.5
				WHEN PR.SumaCelkem >= 5000 THEN PR.SumaCelkem / 100 * 1
			ELSE 0 END, 0) AS SumaSek
		FROM SkladovyDoklad_ProdejkaVydana AS PR
		WHERE PR.Deleted = 0
		UNION
		SELECT 
			CisloDokladu, DL.SumaCelkem - ISNULL(ODD.SumaCelkem, 0), Firma_ID, DL.Deleted,
			ROUND(CASE 
				WHEN DL.SumaCelkem - ISNULL(ODD.SumaCelkem, 0) >= 10000 THEN (DL.SumaCelkem - ISNULL(ODD.SumaCelkem, 0)) / 100 * 1.5
				WHEN DL.SumaCelkem - ISNULL(ODD.SumaCelkem, 0) >= 5000 THEN (DL.SumaCelkem - ISNULL(ODD.SumaCelkem, 0)) / 100 * 1
			ELSE 0 END, 0) AS SumaSek
		FROM SkladovyDoklad_DodaciListVydany AS DL
		LEFT JOIN (
			SELECT
				Dl.ParovaciSymbol, SUM(DL.CelkovaCastka) AS SumaCelkem
			FROM SkladovyDoklad_DodaciListVydany AS Dl
			WHERE Dl.Deleted = 0 AND Dl.ZapornyPohyb = 1
			GROUP BY Dl.ParovaciSymbol
		) AS ODD ON ODD.ParovaciSymbol = DL.CisloDokladu
		WHERE DL.Deleted = 0
	) AS D ON D.CisloDokladu = ID.ParovaciSymbol
	LEFT JOIN Adresar_Firma AS Fir ON Fir.ID = D.Firma_ID
	WHERE Grp.Kod = 'SEKY'
END
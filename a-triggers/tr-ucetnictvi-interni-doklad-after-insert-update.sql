CREATE OR ALTER TRIGGER USER_Ucetnictvi_InterniDoklad
ON Ucetnictvi_InterniDoklad
AFTER UPDATE
AS
BEGIN
	UPDATE Ucetnictvi_InterniDoklad SET 
		Nazev = CASE
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
			CisloDokladu, FA.SumaCelkem - ISNULL(ODD.SumaCelkem, 0), Firma_ID, FA.Deleted,
			ROUND(CASE 
				WHEN FA.SumaCelkem - ISNULL(ODD.SumaCelkem, 0) >= 10000 THEN (FA.SumaCelkem - ISNULL(ODD.SumaCelkem, 0)) / 100 * 1.5
				WHEN FA.SumaCelkem - ISNULL(ODD.SumaCelkem, 0) >= 5000 THEN (FA.SumaCelkem - ISNULL(ODD.SumaCelkem, 0)) / 100 * 1
			ELSE 0 END, 0) AS SumaSek
		FROM Fakturace_FakturaVydana AS FA
		LEFT JOIN (
			SELECT
				Vazba.Zdroj_ID, SUM(FV.CelkovaCastka) AS SumaCelkem
			FROM Fakturace_FakturaVydana AS FV
			INNER JOIN EconomicBase_VazbaObjektu AS Vazba ON Vazba.Cil_ID = FV.ID AND Vazba.CilTableName = 'Fakturace_FakturaVydana'
			WHERE FV.Deleted = 0 AND FV.ZapornyPohyb = 1
			GROUP BY Vazba.Zdroj_ID
		) AS ODD ON ODD.Zdroj_ID = FA.ID
		WHERE FA.Deleted = 0
	) AS D ON D.CisloDokladu = ID.ParovaciSymbol
	LEFT JOIN Adresar_Firma AS Fir ON Fir.ID = D.Firma_ID
	WHERE Grp.Kod = 'SEKY'
END
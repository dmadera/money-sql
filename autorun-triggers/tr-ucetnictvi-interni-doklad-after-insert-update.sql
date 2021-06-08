CREATE OR ALTER TRIGGER TR_Ucetnictvi_InterniDoklad
ON Ucetnictvi_InterniDoklad
AFTER UPDATE
AS
BEGIN
	UPDATE Ucetnictvi_InterniDoklad SET 
		Nazev = CASE
			WHEN D.CisloDokladu IS NULL OR D.Deleted = 1 
				THEN 'Neplatný šek - doklad zrušen'
			WHEN D.Deleted = 0 AND (D.SumaCelkem < 5000 OR (Fir.VlastniSleva = 1 AND Fir.HodnotaSlevy <> 0) OR (
					SELECT COUNT(FirAdrKl.ID) FROM Adresar_FirmaAdresniKlic AS FirAdrKl 
					INNER JOIN  Adresar_AdresniKlic AS AdrKlic ON AdrKlic.ID = FirAdrKl.AdresniKlic_ID
					WHERE FirAdrKl.Parent_ID = D.Firma_ID AND AdrKlic.Kod = '-SEK') <> 0) 
				THEN 'Neplatný šek - doklad nesplňuje požadavky'
			WHEN D.Deleted = 0 AND ROUND(CASE 
					WHEN D.SumaCelkem >= 10000 THEN D.SumaCelkem / 100 * 1.5
					WHEN D.SumaCelkem >= 5000 THEN D.SumaCelkem / 100 * 1
					ELSE PD.SumaCelkem END, 0) <> PD.SumaCelkem
				THEN CONCAT('Neplatný šek - opravte na částku ', CONVERT(NUMERIC(10,2), ROUND(CASE 
					WHEN D.SumaCelkem >= 10000 THEN D.SumaCelkem / 100 * 1.5
					WHEN D.SumaCelkem >= 5000 THEN D.SumaCelkem / 100 * 1
					ELSE PD.SumaCelkem END, 0)), ' Kč')
			WHEN D.Deleted = 0 AND D.Firma_ID <> PD.Firma_ID 
				THEN CONCAT('Neplatný šek - opravte na odběratele ', Fir.Kod)
			ELSE 'Šek vydaný'
		END
	FROM Ucetnictvi_InterniDoklad AS PD
	INNER JOIN inserted ON inserted.ID = PD.ID
	INNER JOIN System_Groups AS Grp ON Grp.ID = PD.Group_ID
	LEFT JOIN (
		SELECT 
			CisloDokladu, SumaZaklad, SumaDan, SumaCelkem, Firma_ID, Deleted, 'PV' AS Typ
		FROM SkladovyDoklad_ProdejkaVydana AS PR
		UNION
		SELECT 
			CisloDokladu , SumaZaklad, SumaDan, SumaCelkem, Firma_ID, Deleted, 'FV' AS Typ
		FROM Fakturace_FakturaVydana AS FA
	) AS D ON D.CisloDokladu = PD.ParovaciSymbol
	LEFT JOIN Adresar_Firma AS Fir ON Fir.ID = D.Firma_ID
	WHERE Grp.Kod = 'SEKY'
END
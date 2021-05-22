Use S4_Agenda_PEMA;
GO

CREATE OR ALTER TRIGGER TR_Ucetnictvi_InterniDoklad
ON Ucetnictvi_InterniDoklad
AFTER UPDATE
AS
BEGIN
	UPDATE Ucetnictvi_InterniDoklad SET 
		Nazev = CASE
			WHEN PR.Deleted = 1 
				THEN 'Neplatn� �ek - doklad zru�en'
			WHEN PR.Deleted = 0 AND (PR.SumaCelkem < 5000 OR (Fir.VlastniSleva = 1 AND Fir.HodnotaSlevy <> 0) OR (
					SELECT COUNT(FirAdrKl.ID) FROM Adresar_FirmaAdresniKlic AS FirAdrKl 
					INNER JOIN  Adresar_AdresniKlic AS AdrKlic ON AdrKlic.ID = FirAdrKl.AdresniKlic_ID
					WHERE FirAdrKl.Parent_ID = PR.Firma_ID AND AdrKlic.Kod = '-SEK') <> 0) 
				THEN 'Neplatn� �ek - doklad nespl�uje po�adavky'
			WHEN PR.Deleted = 0 AND ROUND(CASE 
					WHEN PR.SumaCelkem >= 10000 THEN PR.SumaCelkem / 100 * 1.5
					WHEN PR.SumaCelkem >= 5000 THEN PR.SumaCelkem / 100 * 1
					ELSE PD.SumaCelkem END, 0) <> PD.SumaCelkem
				THEN CONCAT('Neplatn� �ek - opravte na ��stku ', CONVERT(NUMERIC(10,2), ROUND(CASE 
					WHEN PR.SumaCelkem >= 10000 THEN PR.SumaCelkem / 100 * 1.5
					WHEN PR.SumaCelkem >= 5000 THEN PR.SumaCelkem / 100 * 1
					ELSE PD.SumaCelkem END, 0)), ' K�')
			WHEN PR.Deleted = 0 AND PR.Firma_ID <> PD.Firma_ID 
				THEN CONCAT('Neplatn� �ek - opravte na odb�ratele ', Fir.Kod)
			ELSE 'Vydan� �ek'
		END
	FROM Ucetnictvi_InterniDoklad AS PD
	INNER JOIN inserted ON inserted.ID = PD.ID
	INNER JOIN System_Groups AS Grp ON Grp.ID = PD.Group_ID
	INNER JOIN SkladovyDoklad_ProdejkaVydana AS PR ON PR.CisloDokladu = PD.ParovaciSymbol
	INNER JOIN Adresar_Firma AS Fir ON Fir.ID = PR.Firma_ID
	WHERE Grp.Kod = 'SEKY'
END
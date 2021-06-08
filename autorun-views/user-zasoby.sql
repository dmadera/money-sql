IF OBJECT_ID('dbo.USER_ZasobyProdej', 'V') IS NOT NULL DROP VIEW dbo.USER_ZasobyProdej;
GO

CREATE VIEW dbo.USER_ZasobyProdej AS
SELECT
	Zasoba.ID AS ID,
	Zasoba.Artikl_ID AS Artikl_ID,
	CASE
		WHEN PocitatProdej = 0 THEN -1
		WHEN ZasobaAVG.Zasoba_ID IS NULL THEN 0
		ELSE ROUND(ZasobaAVG.SumMnozstvi / DATEDIFF(dd, ZasobaAVG.PrvniPohyb, GETDATE()) * 20, 0) 
	END AS ProdejAvg,
	CASE
		WHEN PocitatProdej = 0 THEN -1
		WHEN ZasobaMED.Zasoba_ID IS NULL THEN 0
		ELSE ROUND(ZasobaMED.SumMedian / DATEDIFF(dd, ZasobaMED.PrvniPohyb, GETDATE()) * 20, 0) 
	END AS ProdejMed
FROM Sklady_Zasoba AS Zasoba WITH(NOLOCK) 
LEFT JOIN (
	SELECT 
		Artikl.ID AS ID,
		ISNULL(MIN(CAST(PocitatProdejZasob_UserData AS INT)), 1) AS PocitatProdej,
		MIN(Artikl.NakupniCena_UserData) AS NakupniCena_UserData,
		MIN(Marze_UserData) AS Marze_UserData
	FROM Artikly_Artikl AS Artikl WITH(NOLOCK) 
	LEFT JOIN Artikly_ArtiklProduktovyKlic AS ArtProdKlic WITH(NOLOCK) ON ArtProdKlic.Parent_ID = Artikl.ID
	LEFT JOIN Artikly_ProduktovyKlic AS ProdKlic WITH(NOLOCK) ON ProdKlic.ID = ArtProdKlic.ProduktovyKlic_ID
	GROUP BY Artikl.ID
) AS Artikl1 ON Artikl1.ID = Zasoba.Artikl_ID
LEFT JOIN (
	SELECT 
		Pohyb.Konto_ID AS Zasoba_ID, 
		SUM(Pohyb.Mnozstvi) AS SumMnozstvi,
		MIN(Pohyb.Datum) AS PrvniPohyb
	FROM Sklady_PohybZasoby AS Pohyb WITH(NOLOCK)
	WHERE Pohyb.DruhPohybu = 1
	GROUP BY Pohyb.Konto_ID
) AS ZasobaAVG ON ZasobaAVG.Zasoba_ID = Zasoba.ID
LEFT JOIN (
	SELECT 
		Zas.ID AS Zasoba_ID, 
		MAX(Median.Median) * COUNT(Zas.ID) AS SumMedian, 
		Min(Median.DatumPohybu) AS PrvniPohyb
	FROM Sklady_Zasoba AS Zas WITH(NOLOCK) 
	INNER JOIN (
		SELECT 
			Pohyb.Konto_ID AS Zasoba_ID, 
			Datum AS DatumPohybu, 
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Mnozstvi) OVER (PARTITION BY Pohyb.Konto_ID) AS Median 
		FROM Sklady_PohybZasoby AS Pohyb WITH(NOLOCK)
		WHERE Pohyb.DruhPohybu = 1
	) AS Median ON Median.Zasoba_ID = Zas.ID
	GROUP BY Zas.ID
) AS ZasobaMED ON ZasobaMED.Zasoba_ID = Zasoba.ID;
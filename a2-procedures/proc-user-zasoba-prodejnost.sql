CREATE OR ALTER PROCEDURE USER_ZasobyProdejnost AS BEGIN

	UPDATE Sklady_Zasoba SET
		ProdejMinMED_UserData = ISNULL(Zas.ProdejMed, 0),
		ProdejMinAVG_UserData = ISNULL(Zas.ProdejAvg, 0),
		PodMinProdejem_UserData = CASE
			WHEN Zas.ProdejAvg > ISNULL(Stav.ZustatekMnozstvi, 0) + Zasoba.Objednano THEN 1
			ELSE 0
		END
	FROM Sklady_Zasoba AS Zasoba 
	LEFT JOIN Sklady_StavZasoby AS Stav WITH(NOLOCK) ON Stav.ID = Zasoba.AktualniStav_ID
	LEFT JOIN USER_ZasobyProdej AS Zas WITH(NOLOCK) ON Zas.ID = Zasoba.ID
	WHERE Zasoba.Deleted = 0;

	RETURN 0;

END
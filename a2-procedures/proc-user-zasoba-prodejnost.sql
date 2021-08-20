CREATE OR ALTER PROCEDURE USER_ZasobyProdejnost AS BEGIN

	UPDATE Sklady_Zasoba SET
		ProdejMinMED_UserData = Zas.ProdejMed,
		ProdejMinAVG_UserData = Zas.ProdejAvg,
		PodMinProdejem_UserData = CASE
			WHEN Zas.ProdejAvg > Stav.ZustatekMnozstvi + Zasoba.Objednano THEN 1
			ELSE 0
		END
	FROM Sklady_Zasoba AS Zasoba 
	INNER JOIN Sklady_StavZasoby AS Stav WITH(NOLOCK) ON Stav.Konto_ID = Zasoba.ID
	INNER JOIN USER_ZasobyProdej AS Zas WITH(NOLOCK) ON Zas.ID = Zasoba.ID
	WHERE Zasoba.Deleted = 0;

	RETURN 0;

END
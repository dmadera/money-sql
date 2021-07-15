CREATE OR ALTER PROCEDURE USER_ProdejnostZasob AS BEGIN
	UPDATE Sklady_Zasoba SET
		ProdejMinAVG_UserData = Zas.ProdejAvg,
		ProdejMinMED_UserData = Zas.ProdejMed,
		StavZobrazeniRadku_UserData = CASE
			WHEN Zas.ProdejMed > Stav.ZustatekMnozstvi + Zasoba.Objednano THEN 1
			WHEN Zasoba.Objednano > 0 THEN 2
			ELSE 0
		END
	FROM Sklady_Zasoba AS Zasoba 
	INNER JOIN Sklady_StavZasoby AS Stav WITH(NOLOCK) ON Stav.Konto_ID = Zasoba.ID
	INNER JOIN USER_ZasobyProdej AS Zas WITH(NOLOCK) ON Zas.ID = Zasoba.ID;
SET NOCOUNT OFF

RETURN 0

END
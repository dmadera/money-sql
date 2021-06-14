CREATE OR ALTER TRIGGER USER_Sklady_StavZasoby_AfterInsert
ON Sklady_StavZasoby
AFTER INSERT, UPDATE
AS
BEGIN
	UPDATE Sklady_Zasoba SET
		ProdejMinAVG_UserData = Zas.ProdejAvg,
		ProdejMinMED_UserData = Zas.ProdejMed,
		StavZobrazeniRadku_UserData = CASE
			WHEN Zas.ProdejMed > Stav.ZustatekMnozstvi + Zasoba.Objednano THEN 1
			WHEN Zasoba.Objednano > 0 THEN 2
			ELSE 0
		END
	FROM Sklady_Zasoba AS Zasoba 
	INNER JOIN inserted ON inserted.Konto_ID = Zasoba.ID
	INNER JOIN Sklady_StavZasoby AS Stav WITH(NOLOCK) ON Stav.Konto_ID = Zasoba.ID
	INNER JOIN USER_ZasobyProdej AS Zas WITH(NOLOCK) ON Zas.ID = Zasoba.ID;

END
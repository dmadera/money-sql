IF OBJECT_ID('dbo.USER_PosledniPrijemZasoby', 'V') IS NOT NULL DROP VIEW dbo.USER_PosledniPrijemZasoby;
GO

CREATE VIEW dbo.USER_PosledniPrijemZasoby AS
SELECT 
	Pohyb.Konto_ID AS Zasoba_ID,
	Pohyb.Datum AS Datum,
	Pohyb.CisloDokladu AS CisloDokladu,
	Pohyb.JednotkaCena AS NakupniCena
FROM (
	SELECT 
		Pohyb.Konto_ID,
		MAX(Pohyb.Create_Date) AS Datum
	FROM Sklady_PohybZasoby AS Pohyb WITH (NOLOCK)
	WHERE 
		DruhPohybu = 0 AND Deleted = 0
	GROUP BY Pohyb.Konto_ID
) AS SubPohyb
INNER JOIN (
	SELECT Konto_ID, Deleted, CisloDokladu, Create_Date AS Datum, DruhPohybu, JednotkaCena
	FROM Sklady_PohybZasoby AS Pohyb WITH (NOLOCK)
	WHERE Deleted = 0
) AS Pohyb ON
	Pohyb.Konto_ID = SubPohyb.Konto_ID
	AND Pohyb.Datum = SubPohyb.Datum
	AND Pohyb.DruhPohybu = 0;
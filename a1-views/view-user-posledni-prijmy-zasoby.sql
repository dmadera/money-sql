IF OBJECT_ID('dbo.USER_PosledniPrijemZasoby', 'V') IS NOT NULL DROP VIEW dbo.USER_PosledniPrijemZasoby;
GO

CREATE VIEW dbo.USER_PosledniPrijemZasoby AS
SELECT 
	Pohyb.Konto_ID AS Zasoba_ID,
	Pohyb.Datum AS Datum,
	Pohyb.CisloDokladu AS CisloDokladu
FROM (
	SELECT 
		Pohyb.Konto_ID,
		MAX(Pohyb.Create_Date) AS Datum
	FROM Sklady_PohybZasoby AS Pohyb WITH (NOLOCK)
	WHERE 
		DokladObjectName = 'DodaciListPrijaty'
	GROUP BY Pohyb.Konto_ID
) AS SubPohyb
INNER JOIN (
	SELECT Konto_ID, CisloDokladu, Create_Date AS Datum, DokladObjectName
	FROM Sklady_PohybZasoby AS Pohyb WITH (NOLOCK)
) AS Pohyb ON
	Pohyb.Konto_ID = SubPohyb.Konto_ID
	AND Pohyb.Datum = SubPohyb.Datum
	AND DokladObjectName = 'DodaciListPrijaty'
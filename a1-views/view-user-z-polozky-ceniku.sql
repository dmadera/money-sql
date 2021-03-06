IF OBJECT_ID('dbo.USER_PolozkyCeniku', 'V') IS NOT NULL DROP VIEW dbo.USER_PolozkyCeniku;
GO

CREATE VIEW dbo.USER_PolozkyCeniku AS
SELECT
	Cena.ID AS ID,
	Cena.Artikl_ID AS Artikl_ID, 
	Zasoba.ID AS Zasoba_ID, 
	Zasoba.Sklad_ID AS Sklad_ID, 
	Cenik.ID AS Cenik_ID, 
	Cenik.Kod AS CenikKod,
	ROUND(StavZas.ZustatekJednotkaCena * 1.25, 2) AS Cena25,
	ROUND(StavZas.ZustatekJednotkaCena, 2) AS SkladovaCena,
	ROUND(CASE
		WHEN Cenik.Kod = '_NAKUP' THEN 0
		WHEN StavZas.ZustatekJednotkaCena = 0 THEN 0
		ELSE 100 / StavZas.ZustatekJednotkaCena * (Cena.Cena - StavZas.ZustatekJednotkaCena) 
	END, 2) AS Marze,
	ROUND(CASE
		WHEN ISNULL(PoslPrijem.NakupniCena, 0) = 0 THEN 0
		ELSE 100 / ISNULL(PoslPrijem.NakupniCena, 0)  * (Cena.Cena - ISNULL(PoslPrijem.NakupniCena, 0) ) 
	END, 2) AS MarzePosledniNakup,
	ROUND(CASE
		WHEN Cenik.Kod = '_NAKUP' THEN StavZas.ZustatekJednotkaCena
		WHEN Cenik.Kod = '_PRODEJ' THEN VychoziCena.Cena
		WHEN Cenik.Kod = '_AKCE' THEN VychoziCena.Cena
		ELSE Cena.Cena
	END, 2) AS Cena,
	ROUND(CASE
		WHEN 
			Cenik.Kod = '_PRODEJ' 
			AND StavZas.PocatekJednotkaCena <> StavZas.ZustatekJednotkaCena
			THEN ISNULL(PoslPrijem.NakupniCena, 0)  * (1 + Cena.MarzeP_UserData / 100) 
		ELSE 0 
	END, 2) AS BudouciCena,
	(CASE
		WHEN Cenik.Kod = '_PRODEJ' THEN 0
		WHEN Cenik.Kod = '_NAKUP'  THEN 0
		WHEN Cenik.Kod = '_AKCE'  THEN 1
		ELSE 1
	END) AS NepodlehaSleveDokladu,
	StavZas.ZustatekMnozstvi AS ZustatekMnozstvi
FROM dbo.Sklady_Zasoba AS Zasoba WITH (NOLOCK)
INNER JOIN dbo.Ceniky_PolozkaCeniku AS Cena (NOLOCK) ON Cena.Artikl_ID = Zasoba.Artikl_ID
INNER JOIN dbo.Ceniky_Cenik AS Cenik WITH (NOLOCK) ON Cenik.ID = Cena.Cenik_ID
LEFT JOIN USER_PosledniPrijemZasoby PoslPrijem WITH(NOLOCK) ON PoslPrijem.Zasoba_ID = Zasoba.ID
INNER JOIN dbo.Sklady_StavZasoby AS StavZas WITH (NOLOCK) ON StavZas.ID = Zasoba.AktualniStav_ID
INNER JOIN Ceniky_PolozkaCeniku VychoziCena WITH(NOLOCK) ON VychoziCena.Artikl_ID = Cena.Artikl_ID AND VychoziCena.Cenik_ID = (SELECT TOP 1 Agenda.VychoziCenik_ID FROM System_AgendaDetail AS Agenda)
WHERE (Zasoba.Deleted = 0) AND (Cena.Deleted = 0 OR Cena.Deleted IS NULL);
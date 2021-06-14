IF OBJECT_ID('dbo.USER_ArtiklySazba', 'V') IS NOT NULL DROP VIEW dbo.USER_ArtiklySazba;
GO

CREATE VIEW dbo.USER_ArtiklySazba AS
SELECT
	Art.ID AS Artikl_ID,
	CONCAT(STR(Sazba.Sazba, 2, 0), '%') AS Sazba
FROM Artikly_Artikl AS Art WITH(NOLOCK)
INNER JOIN (
	SELECT ArtSazba.Parent_ID AS Parent_ID, MAX(ArtSazba.Zacatek) AS Zacatek
	FROM Artikly_ArtiklDPH AS ArtSazba WITH(NOLOCK)
	INNER JOIN EconomicBase_SazbaDPH AS Sazba WITH(NOLOCK) ON Sazba.DruhSazby = ArtSazba.SazbaVystup AND Sazba.PlatnostDo >= GETDATE()
	WHERE ArtSazba.Zacatek <= GETDATE()
	GROUP BY ArtSazba.Parent_ID
) AS ArtSazbaSub ON ArtSazbaSub.Parent_ID = Art.ID
INNER JOIN Artikly_ArtiklDPH AS ArtSazba WITH(NOLOCK) ON ArtSazba.Parent_ID = ArtSazbaSub.Parent_ID AND ArtSazba.Zacatek = ArtSazbaSub.Zacatek
INNER JOIN EconomicBase_SazbaDPH AS Sazba WITH(NOLOCK) ON Sazba.DruhSazby = ArtSazba.SazbaVystup AND Sazba.PlatnostDo >= GETDATE();
IF OBJECT_ID('dbo.USER_ArtiklyDph', 'V') IS NOT NULL DROP VIEW dbo.USER_ArtiklyDph;
GO

CREATE VIEW dbo.USER_ArtiklyDph AS
SELECT DISTINCT 
	ArtSazby.Parent_ID AS ID, Sazba.Sazba 
FROM Artikly_PlatneSazbyDPHView as ArtSazby
INNER join (
	SELECT DruhSazby, MAX(PlatnostOd) AS PlatnostOd
	FROM EconomicBase_SazbaDPH
	WHERE GETDATE() BETWEEN PlatnostOd AND PlatnostDo
	GROUP BY DruhSazby
) AS PlatnaSazba ON PlatnaSazba.DruhSazby = ArtSazby.SazbaVystup
INNER JOIN EconomicBase_SazbaDPH AS Sazba ON 
	(Sazba.DruhSazby = PlatnaSazba.DruhSazby AND Sazba.PlatnostOd = PlatnaSazba.PlatnostOd)
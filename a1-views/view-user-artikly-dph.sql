IF OBJECT_ID('dbo.USER_ArtiklyDph', 'V') IS NOT NULL DROP VIEW dbo.USER_ArtiklyDph;
GO

CREATE VIEW dbo.USER_ArtiklyDph AS
SELECT DISTINCT 
	P.Parent_ID AS ID, S.Sazba 
FROM Artikly_PlatneSazbyDPHView P
INNER JOIN EconomicBase_SazbaDPH S ON S.DruhSazby = P.SazbaVystup 
	AND ((P.PovahaSazbyVystup_ID IS NULL AND S.PovahaSazbyDPH_ID IS NULL) OR (P.PovahaSazbyVystup_ID = S.PovahaSazbyDPH_ID))
WHERE GETDATE() BETWEEN PlatnostOd AND PlatnostDo
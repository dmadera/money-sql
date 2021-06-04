IF OBJECT_ID('dbo.UserArtiklyPriznaky', 'V') IS NOT NULL DROP VIEW dbo.UserArtiklyPriznaky;
GO

CREATE VIEW dbo.UserArtiklyPriznaky AS
SELECT
	Art.ID AS Artikl_ID,
	STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(Pk.Kod, '')), ' ')	WITHIN GROUP (ORDER BY Pk.Kod ASC) AS Priznaky
FROM Artikly_Artikl AS Art WITH(NOLOCK)
RIGHT JOIN Artikly_ArtiklProduktovyKlic AS ArtPk WITH(NOLOCK) ON ArtPk.Parent_ID = Art.ID
INNER JOIN Artikly_ProduktovyKlic AS Pk WITH(NOLOCK) ON Pk.ID = ArtPk.ProduktovyKlic_ID
WHERE LEN(Pk.Kod) = 1
GROUP BY Art.ID;
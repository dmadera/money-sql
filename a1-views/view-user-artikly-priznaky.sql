IF OBJECT_ID('dbo.USER_ArtiklyPriznaky', 'V') IS NOT NULL DROP VIEW dbo.USER_ArtiklyPriznaky;
GO

CREATE VIEW dbo.USER_ArtiklyPriznaky AS
SELECT
	Art.ID AS Artikl_ID,
	STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(Pk.Kod, '')), ' ')	WITHIN GROUP (ORDER BY LEN(Pk.Kod) DESC, Pk.Kod ASC) AS Priznaky
FROM Artikly_Artikl AS Art WITH(NOLOCK)
INNER JOIN Artikly_ArtiklProduktovyKlic AS ArtPk WITH(NOLOCK) ON ArtPk.Parent_ID = Art.ID
INNER JOIN Artikly_ProduktovyKlic AS Pk WITH(NOLOCK) ON Pk.ID = ArtPk.ProduktovyKlic_ID
WHERE LEN(Pk.Kod) <= 2
GROUP BY Art.ID;
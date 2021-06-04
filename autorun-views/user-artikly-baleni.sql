IF OBJECT_ID('dbo.UserArtiklyBaleni', 'V') IS NOT NULL DROP VIEW dbo.UserArtiklyBaleni;
GO

CREATE VIEW dbo.UserArtiklyBaleni AS
SELECT 
	ArtJed.Parent_ID as Artikl_ID, 
	STRING_AGG(FORMAT(ArtJed.VychoziMnozstvi, '#' ), '/') WITHIN GROUP (ORDER BY VychoziMnozstvi DESC) AS Mnozstvi,
	STRING_AGG(ArtJed.Kod, '/') WITHIN GROUP (ORDER BY VychoziMnozstvi DESC)  AS Jednotky
FROM Artikly_ArtiklJednotka AS ArtJed WITH(NOLOCK)
WHERE ArtJed.ParentJednotka_ID IS NOT NULL
GROUP BY ArtJed.Parent_ID;
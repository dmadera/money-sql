IF OBJECT_ID('dbo.USER_ArtiklyBaleniKarton', 'V') IS NOT NULL DROP VIEW dbo.USER_ArtiklyBaleniKarton;
GO

CREATE VIEW dbo.USER_ArtiklyBaleniKarton AS
SELECT 
	ArtJed.Parent_ID as Artikl_ID, 
	STRING_AGG(FORMAT(ArtJed.VychoziMnozstvi, '#' ), '/') WITHIN GROUP (ORDER BY VychoziMnozstvi DESC) AS Mnozstvi,
	STRING_AGG(ArtJed.Kod, '/') WITHIN GROUP (ORDER BY VychoziMnozstvi DESC)  AS Jednotky
FROM Artikly_ArtiklJednotka AS ArtJed WITH(NOLOCK)
INNER JOIN Ciselniky_Jednotka AS Jed WITH(NOLOCK) ON Jed.ID = ArtJed.Jednotka_ID
WHERE ArtJed.ParentJednotka_ID IS NOT NULL AND Jed.KartonovaJednotka_UserData = 1
GROUP BY ArtJed.Parent_ID;
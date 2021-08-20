IF OBJECT_ID('dbo.USER_ArtiklyJednotky', 'V') IS NOT NULL DROP VIEW dbo.USER_ArtiklyJednotky;
GO

CREATE VIEW dbo.USER_ArtiklyJednotky AS
SELECT 
	A.ID AS Artikl_ID, 
	A.Nazev,
	ISNULL(Jfol.Mnozstvi, NULL) AS MnFol,
	ISNULL(Jkar.Mnozstvi, NULL) AS MnKar,
	ISNULL(Jpal.Mnozstvi, NULL) AS MnPal
FROM Artikly_Artikl A WITH(NOLOCK)
LEFT JOIN (
	SELECT 
		AJ.Parent_ID AS Artikl_ID,
		MIN(AJ.VychoziMnozstvi) AS Mnozstvi
	FROM Artikly_ArtiklJednotka AJ WITH(NOLOCK)
	INNER JOIN Ciselniky_Jednotka J WITH(NOLOCK) ON J.Kod = 'fol' AND J.ID = AJ.Jednotka_ID
	WHERE AJ.ParentJednotka_ID IS NOT NULL
	GROUP BY AJ.Parent_ID
) Jfol ON Jfol.Artikl_ID = A.ID
LEFT JOIN (
	SELECT 
		AJ.Parent_ID AS Artikl_ID,
		MIN(AJ.VychoziMnozstvi) AS Mnozstvi
	FROM Artikly_ArtiklJednotka AJ WITH(NOLOCK)
	INNER JOIN Ciselniky_Jednotka J WITH(NOLOCK) ON J.Kod = 'kar' AND J.ID = AJ.Jednotka_ID
	WHERE AJ.ParentJednotka_ID IS NOT NULL
	GROUP BY AJ.Parent_ID
) Jkar ON Jkar.Artikl_ID = A.ID
LEFT JOIN (
	SELECT 
		AJ.Parent_ID AS Artikl_ID,
		MIN(AJ.VychoziMnozstvi) AS Mnozstvi
	FROM Artikly_ArtiklJednotka AJ WITH(NOLOCK)
	INNER JOIN Ciselniky_Jednotka J WITH(NOLOCK) ON J.Kod = 'pal' AND J.ID = AJ.Jednotka_ID
	WHERE AJ.ParentJednotka_ID IS NOT NULL
	GROUP BY AJ.Parent_ID
) Jpal ON Jpal.Artikl_ID = A.ID;
IF OBJECT_ID('dbo.USER_ArtiklyKategorie', 'V') IS NOT NULL DROP VIEW dbo.USER_ArtiklyKategorie;
GO

CREATE VIEW dbo.USER_ArtiklyKategorie AS
	WITH Tree (ID, Nazev, ParentObject_ID, Level, KompletniCesta, ListID) AS (
		-- anchor:
		SELECT 
			ID, Nazev, ParentObject_ID, 0, CAST(Nazev AS varchar(max)), CAST(ID AS varchar(max))
		FROM Artikly_KategorieArtiklu WHERE ParentObject_ID IS NULL
		UNION ALL
		-- recursive:
		SELECT 
			t.ID, t.Nazev, t.ParentObject_ID, Tree.Level + 1, 
			CAST(CONCAT(Tree.KompletniCesta, ' > ', t.Nazev) AS VARCHAR(max)),
			CAST(CONCAT(Tree.ListID, '|', t.ID) AS VARCHAR(max))
		FROM Tree 
		INNER JOIN Artikly_KategorieArtiklu AS t ON t.ParentObject_ID = Tree.ID
	)
	SELECT
		Art.ID AS Artikl_ID,
		SQ.Kategorie_UserData AS KategorieRetezec,
		SQ.Kategorie AS Kategorie
	FROM Artikly_Artikl AS Art
	RIGHT JOIN (
		SELECT 
			Art.ID AS ID,
			STRING_AGG(Kat.KompletniCesta, ' @ ') AS Kategorie_UserData,
			LOWER(STRING_AGG(Kat.ListID, '|')) AS Kategorie
		FROM Artikly_Artikl AS Art
		CROSS APPLY STRING_SPLIT(Art.Kategorie, '|') AS ArtKat
		INNER JOIN (
			SELECT 
				ID, KompletniCesta, ListID 
			FROM Tree
			WHERE ParentObject_ID IS NOT NULL
		) AS Kat ON CAST(Kat.ID AS varchar(100)) = ArtKat.value
		GROUP BY Art.ID
	) AS SQ ON SQ.ID = Art.ID;

SET Context_Info 0x55554;

-- jednotky 
-- nastavi prodejni jednotku prvni pod hlavni, pokud je kartonova
-- nastavi nakupni jednotku prvni pod hlavni
UPDATE Artikly_Artikl SET
	Artikly_Artikl.ProdejniJednotka_ID = ISNULL(SQ.ProdejniJednotka_ID, Artikly_ArtiklJednotka.ID),
	Artikly_Artikl.NakupniJednotka_ID = ISNULL(SQ.NakupniJednotka_ID, Artikly_ArtiklJednotka.ID)
FROM (
	SELECT
		Artikly_Artikl.ID AS ID,
		MinMnozstviT.Parent_ID AS ProdejniJednotka_ID,
		MinMnozstviT1.Parent_ID AS NakupniJednotka_ID
	FROM Artikly_Artikl
	LEFT JOIN (
		SELECT 
			Artikly_ArtiklJednotka.Parent_ID as Parent_ID, MIN(VychoziMnozstvi) as VychoziMnozstvi
		FROM  Artikly_ArtiklJednotka
		INNER JOIN Ciselniky_Jednotka AS Jednotka ON Jednotka.ID = Artikly_ArtiklJednotka.Jednotka_ID
		WHERE Artikly_ArtiklJednotka.ParentJednotka_ID IS NOT NULL AND Jednotka.KartonovaJednotka_UserData = 1
		GROUP BY Artikly_ArtiklJednotka.Parent_ID
	) MinMnozstviT ON Artikly_Artikl.ID = MinMnozstviT.Parent_ID
	LEFT JOIN (
		SELECT 
			Artikly_ArtiklJednotka.Parent_ID as Parent_ID, MIN(VychoziMnozstvi) as VychoziMnozstvi
		FROM  Artikly_ArtiklJednotka
		WHERE Artikly_ArtiklJednotka.ParentJednotka_ID IS NOT NULL
		GROUP BY Artikly_ArtiklJednotka.Parent_ID
	) MinMnozstviT1 ON Artikly_Artikl.ID = MinMnozstviT1.Parent_ID
	INNER JOIN Artikly_ArtiklJednotka ON 
		Artikly_ArtiklJednotka.Parent_ID = Artikly_Artikl.ID AND 
		MinMnozstviT.VychoziMnozstvi = Artikly_ArtiklJednotka.VychoziMnozstvi
) AS SQ
RIGHT JOIN Artikly_ArtiklJednotka ON Artikly_ArtiklJednotka.Parent_ID = SQ.ID
INNER JOIN Artikly_Artikl ON Artikly_ArtiklJednotka.Parent_ID = Artikly_Artikl.ID
WHERE 
	Artikly_ArtiklJednotka.ParentJednotka_ID IS NULL AND
	Artikly_ArtiklJednotka.Deleted = 0;

-- jednotky - u dodavatele nastavi prodejni jednotku
UPDATE Artikly_ArtiklDodavatel SET
	Jednotka_ID = ArtJed.Jednotka_ID,
	ArtiklJednotka_ID = ArtJed.ID
FROM Artikly_ArtiklDodavatel AS ArtDod
INNER JOIN Artikly_Artikl AS Artikl ON Artikl.ID = ArtDod.Parent_ID
INNER JOIN Artikly_ArtiklJednotka AS ArtJed ON ArtJed.ID = Artikl.NakupniJednotka_ID;
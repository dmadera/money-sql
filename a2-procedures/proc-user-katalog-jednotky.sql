CREATE OR ALTER PROCEDURE USER_KatalogJednotky AS BEGIN

SET Context_Info 0x55554;

-- jednotky 
-- nastavi prodejni jednotku prvni pod hlavni, pokud je kartonova (Ciselniky_Jednotka.KartonovaJednotka_UserData = 1)
-- nastavi nakupni jednotku prvni pod hlavni
UPDATE Artikly_Artikl SET
	ProdejniJednotka_ID = ISNULL(ArtJedPrvniKarton.ID, Artikl.HlavniJednotka_ID),
	NakupniJednotka_ID = ISNULL(ArtJedPrvni.ID, Artikl.HlavniJednotka_ID)
FROM Artikly_Artikl AS Artikl
LEFT JOIN (
	-- vybere jednotku 2. v poradi pod hlavni a zaroven KartonovaJednotka_UserData = 1
	SELECT
		ArtJed.Parent_ID, MIN(ArtJed.VychoziMnozstvi) AS VychoziMnozstvi
	FROM Artikly_ArtiklJednotka AS ArtJed 
	LEFT JOIN Ciselniky_Jednotka AS Jednotka ON Jednotka.ID = ArtJed.Jednotka_ID
	WHERE ArtJed.ParentJednotka_ID IS NOT NULL AND Jednotka.KartonovaJednotka_UserData = 1
	GROUP BY ArtJed.Parent_ID
) AS ArtJedPrvniKartonSub ON ArtJedPrvniKartonSub.Parent_ID = Artikl.ID
LEFT JOIN Artikly_ArtiklJednotka AS ArtJedPrvniKarton ON 
	ArtJedPrvniKarton.Parent_ID = ArtJedPrvniKartonSub.Parent_ID 
	AND ArtJedPrvniKarton.VychoziMnozstvi = ArtJedPrvniKartonSub.VychoziMnozstvi
LEFT JOIN (
	-- vybere jednotku poslední jednotku v poradi pod hlavni
	SELECT
		ArtJed.Parent_ID, MAX(ArtJed.VychoziMnozstvi) AS VychoziMnozstvi
	FROM Artikly_ArtiklJednotka AS ArtJed 
	LEFT JOIN Ciselniky_Jednotka AS Jednotka ON Jednotka.ID = ArtJed.Jednotka_ID
	WHERE ArtJed.ParentJednotka_ID IS NOT NULL
	GROUP BY ArtJed.Parent_ID
) AS ArtJedPrvniSub ON ArtJedPrvniSub.Parent_ID = Artikl.ID
LEFT JOIN Artikly_ArtiklJednotka AS ArtJedPrvni ON 
	ArtJedPrvni.Parent_ID = ArtJedPrvniSub.Parent_ID 
	AND ArtJedPrvni.VychoziMnozstvi = ArtJedPrvniSub.VychoziMnozstvi
WHERE Artikl.Deleted = 0

-- jednotky - u dodavatele nastavi prodejni jednotku
UPDATE Artikly_ArtiklDodavatel SET
	Jednotka_ID = ArtJed.Jednotka_ID,
	ArtiklJednotka_ID = ArtJed.ID,
	PovinnyNasobek = 0
FROM Artikly_ArtiklDodavatel AS ArtDod
INNER JOIN Artikly_Artikl AS Artikl ON Artikl.ID = ArtDod.Parent_ID
INNER JOIN Artikly_ArtiklJednotka AS ArtJed ON ArtJed.ID = Artikl.NakupniJednotka_ID;

RETURN 0

END
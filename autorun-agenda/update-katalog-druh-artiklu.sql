
SET Context_Info 0x55554;

DECLARE @VychoziDruhArtiklu AS UNIQUEIDENTIFIER;
	SET @VychoziDruhArtiklu = (SELECT TOP 1 ID FROM Ciselniky_DruhArtiklu AS DruhArtiklu WHERE DruhArtiklu.Kod = 'ZBO');

UPDATE Artikly_Artikl SET
	DruhArtiklu_ID = @VychoziDruhArtiklu
FROM Artikly_Artikl AS Artikl
WHERE Artikl.DruhArtiklu_ID IS NULL
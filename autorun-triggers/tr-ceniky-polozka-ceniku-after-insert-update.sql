CREATE OR ALTER TRIGGER TR_Ceniky_PolozkaCeniku_AfterInsertUpdate
ON Ceniky_PolozkaCeniku
AFTER INSERT, UPDATE
AS
BEGIN

	-- spusti trigger artikly, ktery aktualizuje i skladove zasoby a cenikove polozky
	UPDATE Artikly_Artikl SET
		Deleted = Artikl.Deleted
	FROM Artikly_Artikl AS Artikl
	INNER JOIN inserted AS Cena ON Cena.Artikl_ID = Artikl.ID;	

END;
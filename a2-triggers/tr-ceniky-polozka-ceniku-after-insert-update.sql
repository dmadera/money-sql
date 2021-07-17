CREATE OR ALTER TRIGGER USER_Ceniky_PolozkaCeniku_AfterInsertUpdate
ON Ceniky_PolozkaCeniku
AFTER INSERT, UPDATE
AS
BEGIN
	IF Context_Info() = 0x55555 
		RETURN;

	UPDATE Artikly_Artikl SET	
		ID = Artikl.ID
	FROM Artikly_Artikl AS Artikl
	INNER JOIN inserted AS Cena ON Cena.Artikl_ID = Artikl.ID;
END;
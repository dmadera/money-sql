CREATE OR ALTER TRIGGER TR_Ceniky_PolozkaCeniku_AfterInsertUpdate
ON Ceniky_PolozkaCeniku
AFTER INSERT, UPDATE
AS
BEGIN
	IF Context_Info() = 0x55555 
		RETURN;

	DECLARE @VychoziCenik_ID AS UNIQUEIDENTIFIER;
	SET @VychoziCenik_ID = (SELECT TOP 1 Agenda.VychoziCenik_ID FROM System_AgendaDetail AS Agenda);

	UPDATE Artikly_Artikl SET	
		ID = Artikl.ID
	FROM Artikly_Artikl AS Artikl
	INNER JOIN inserted AS Cena ON Cena.Artikl_ID = Artikl.ID AND Cena.Cenik_ID = @VychoziCenik_ID;
END;
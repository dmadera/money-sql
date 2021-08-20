CREATE OR ALTER TRIGGER USER_Ceniky_PolozkaCeniku_AfterDelete
ON Ceniky_PolozkaCeniku
AFTER DELETE
AS
BEGIN
	IF SESSION_CONTEXT(N'USER_Ceniky_PolozkaCeniku_AfterDelete') = 'disable'
		RETURN; 

	DECLARE @AkcniCenik_ID AS UNIQUEIDENTIFIER;
	SET @AkcniCenik_ID = (SELECT TOP 1 ID FROM Ceniky_Cenik AS Cenik WHERE Cenik.Kod = '_AKCE');

	-- smaze produktovy klic u Artiklu po smazani polozky z ceniku
	DELETE FROM Artikly_ArtiklProduktovyKlic
	WHERE
		ProduktovyKlic_ID IN (SELECT ID FROM Artikly_ProduktovyKlic Pk WHERE Kod = 'A' OR Kod = 'S')
		AND Parent_ID IN (
			SELECT Artikl_ID
			FROM deleted
			WHERE Cenik_ID = @AkcniCenik_ID
		);

END;
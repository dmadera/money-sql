CREATE OR ALTER TRIGGER USER_Objednavky_PolozkaObjednavkyVydane_AfterInsertUpdate
ON Objednavky_PolozkaObjednavkyVydane
AFTER INSERT, UPDATE
AS
BEGIN
	IF SESSION_CONTEXT(N'USER_Objednavky_PolozkaObjednavkyVydane_AfterInsertUpdate') = 'disable'
		RETURN; 

	DECLARE @Polozky AS USER_PolozkaDokladu;
	DECLARE @MnozstviVJednotkach NVARCHAR(MAX);
	DECLARE @Cursor_ID UNIQUEIDENTIFIER;
	DECLARE MY_CURSOR CURSOR LOCAL FAST_FORWARD FOR 
	SELECT Parent_ID FROM inserted GROUP BY Parent_ID;
	OPEN MY_CURSOR;
	FETCH NEXT FROM MY_CURSOR INTO @Cursor_ID;
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		DELETE FROM @Polozky;
		INSERT INTO @Polozky
		SELECT 
			Pol.ID,
			Obs.Artikl_ID,
			Pol.Mnozstvi,
			CASE 
				WHEN Pol.Vratka = 1 AND Doklad.ZapornyPohyb = 1 THEN 0
				WHEN Pol.Vratka = 1 AND Doklad.ZapornyPohyb = 0 THEN 1
				WHEN Pol.Vratka = 0 AND Doklad.ZapornyPohyb = 1 THEN 1
				ELSE 0
			END AS Vratka
		FROM Objednavky_PolozkaObjednavkyVydane AS Pol
		INNER JOIN Obchod_ObsahPolozkySArtiklem AS Obs ON Obs.ID = Pol.ObsahPolozky_ID
		INNER JOIN Objednavky_ObjednavkaVydana AS Doklad ON Doklad.ID = Pol.Parent_ID
		WHERE Pol.Parent_ID = @Cursor_ID;

		EXEC USER_PolozkyMnozstviVJednotkach @Polozky, @MnozstviVJednotkach OUTPUT, 0;
	
		UPDATE Objednavky_ObjednavkaVydana SET
			MnozstviVJedn_UserData = ISNULL(@MnozstviVJednotkach, '')
		WHERE ID = @Cursor_ID;
		
		FETCH NEXT FROM MY_CURSOR INTO @Cursor_ID;
	END;
	CLOSE MY_CURSOR;
	DEALLOCATE MY_CURSOR;
END

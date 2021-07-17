CREATE OR ALTER TRIGGER USER_Objednavky_PolozkaObjednavkyPrijate_AfterInsertUpdate
ON Objednavky_PolozkaObjednavkyPrijate
AFTER INSERT, UPDATE
AS
BEGIN
	
	/* marze, nakupni cena do polozky */
	UPDATE Objednavky_PolozkaObjednavkyPrijate SET
		Marze_UserData = IIF(Cena.JednotkovaSkladovaCena = 0 OR Pol.JednCena = 0, 0, ROUND(100/Cena.JednotkovaSkladovaCena*(Pol.JednCena-Cena.JednotkovaSkladovaCena), 2)),
		NakupniCena_UserData = Cena.JednotkovaSkladovaCena
	FROM Objednavky_PolozkaObjednavkyPrijate AS Pol
	INNER JOIN inserted ON inserted.ID = Pol.ID
	INNER JOIN Obchod_ObsahPolozkySArtiklem AS Obsah ON Obsah.ID = Pol.ObsahPolozky_ID
	INNER JOIN CSW_BI_StavSkladuVCenach AS Cena ON Cena.Artikl_ID = Obsah.Artikl_ID

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
		FROM Objednavky_PolozkaObjednavkyPrijate AS Pol
		INNER JOIN Obchod_ObsahPolozkySArtiklem AS Obs ON Obs.ID = Pol.ObsahPolozky_ID
		INNER JOIN Objednavky_ObjednavkaPrijata AS Doklad ON Doklad.ID = Pol.Parent_ID
		WHERE Pol.Parent_ID = @Cursor_ID;

		EXEC USER_PolozkyMnozstviVJednotkach @Polozky, @MnozstviVJednotkach OUTPUT, 0;
	
		UPDATE Objednavky_ObjednavkaPrijata SET
			MnozstviVJedn_UserData = ISNULL(@MnozstviVJednotkach, '')
		WHERE ID = @Cursor_ID;
		
		FETCH NEXT FROM MY_CURSOR INTO @Cursor_ID;
	END;
	CLOSE MY_CURSOR;
	DEALLOCATE MY_CURSOR;
END
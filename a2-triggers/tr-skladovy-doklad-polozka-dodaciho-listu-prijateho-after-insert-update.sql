CREATE OR ALTER TRIGGER USER_SkladovyDoklad_PolozkaDodacihoListuPrijateho_AfterInsertUpdate
ON SkladovyDoklad_PolozkaDodacihoListuPrijateho
AFTER INSERT, UPDATE
AS
BEGIN
	SET Context_Info 0x55555;

	UPDATE Ceniky_PolozkaCeniku SET
		MarzeP_UserData = Marze_UserData
	FROM  Ceniky_PolozkaCeniku AS Cena
	INNER JOIN Obchod_ObsahPolozkySArtiklem AS ObsahPol ON ObsahPol.Artikl_ID = Cena.Artikl_ID
	INNER JOIN inserted AS Polozka ON Polozka.ObsahPolozky_ID = ObsahPol.ID;

	/*DECLARE @Polozky AS USER_PolozkaDokladu;
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
		FROM SkladovyDoklad_PolozkaDodacihoListuPrijateho AS Pol
		INNER JOIN Obchod_ObsahPolozkySArtiklem AS Obs ON Obs.ID = Pol.ObsahPolozky_ID
		INNER JOIN SkladovyDoklad_DodaciListPrijaty AS Doklad ON Doklad.ID = Pol.Parent_ID
		WHERE Pol.Parent_ID = @Cursor_ID;

		EXEC USER_PolozkyMnozstviVJednotkach @Polozky, @MnozstviVJednotkach OUTPUT, 0;
	
		UPDATE SkladovyDoklad_DodaciListPrijaty SET
			MnozstviVJedn_UserData = ISNULL(@MnozstviVJednotkach, '')
		WHERE ID = @Cursor_ID;
		
		FETCH NEXT FROM MY_CURSOR INTO @Cursor_ID;
	END;
	CLOSE MY_CURSOR;
	DEALLOCATE MY_CURSOR;*/

END
CREATE OR ALTER TRIGGER USER_SkladovyDoklad_PolozkaDodacihoListuVydaneho_AfterInsert
ON SkladovyDoklad_PolozkaDodacihoListuVydaneho
AFTER INSERT, UPDATE
AS
BEGIN
	/* 
		MnozstviPozn_UserData:
		* posledni kus
		- odber do minusu
	*/
	UPDATE SkladovyDoklad_PolozkaDodacihoListuVydaneho SET
		MnozstviPozn_UserData = (CASE
			WHEN Zas.DostupneMnozstvi = 0 THEN '*'
			WHEN Zas.DostupneMnozstvi < 0 THEN '-'
			ELSE ''
		END),
		Marze_UserData = IIF(Cena.JednotkovaSkladovaCena = 0, 0, ROUND(100/Cena.JednotkovaSkladovaCena*(Pol.JednCena-Cena.JednotkovaSkladovaCena), 2)),
		NakupniCena_UserData = Cena.JednotkovaSkladovaCena,
		RPDP_UserData = IIF(Art.PreneseniDane_ID IS NULL, '', 'RPDP')
	FROM SkladovyDoklad_PolozkaDodacihoListuVydaneho AS Pol
	INNER JOIN inserted ON inserted.ID = Pol.ID
	INNER JOIN Obchod_ObsahPolozkySArtiklem AS Obsah ON Obsah.ID = Pol.ObsahPolozky_ID
	INNER JOIN Sklady_Zasoba AS Zas ON Zas.ID = Obsah.Zasoba_ID
	INNER JOIN CSW_BI_StavSkladuVCenach AS Cena ON Cena.Artikl_ID = Obsah.Artikl_ID
	INNER JOIN Artikly_Artikl AS Art ON Art.ID = Obsah.Artikl_ID


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
			Pol.Mnozstvi
		FROM SkladovyDoklad_PolozkaDodacihoListuVydaneho AS Pol
		INNER JOIN Obchod_ObsahPolozkySArtiklem AS Obs ON Obs.ID = Pol.ObsahPolozky_ID
		WHERE Pol.Parent_ID = @Cursor_ID;

		EXEC USER_PolozkyMnozstviVJednotkach @Polozky, @MnozstviVJednotkach OUTPUT, 0;
	
		UPDATE SkladovyDoklad_DodaciListVydany SET
			MnozstviVJedn_UserData = ISNULL(@MnozstviVJednotkach, '')
		WHERE ID = @Cursor_ID;
		
		FETCH NEXT FROM MY_CURSOR INTO @Cursor_ID;
	END;
	CLOSE MY_CURSOR;
	DEALLOCATE MY_CURSOR;
	
END
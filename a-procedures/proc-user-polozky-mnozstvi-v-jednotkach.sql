CREATE OR ALTER PROCEDURE USER_PolozkyMnozstviVJednotkach (
	@Polozky USER_PolozkaDokladu READONLY,
	@MnozstviVJednotkach VARCHAR(MAX) OUTPUT,
	@ZobrazVysledek BIT = 0
) AS BEGIN
	SET NOCOUNT ON;
	
	IF OBJECT_ID('tempdb..#MnozstviVJednotkach') IS NOT NULL 
	BEGIN
		DROP TABLE #MnozstviVJednotkach;
	END;

	DECLARE @dummy USER_MnozstviVJednotkach;
	SELECT * INTO #MnozstviVJednotkach FROM @dummy;

	DECLARE @Cursor_ID UNIQUEIDENTIFIER;
	DECLARE @Artikl_ID UNIQUEIDENTIFIER;
	DECLARE @Mnozstvi INT;
	DECLARE @Vratka BIT;

	DECLARE MY_CURSOR CURSOR LOCAL FAST_FORWARD FOR
	SELECT ID FROM @Polozky;

	OPEN MY_CURSOR
	FETCH NEXT FROM MY_CURSOR INTO @Cursor_ID
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		SELECT 
			@Artikl_ID = Artikl_ID,
			@Mnozstvi = Mnozstvi,
			@Vratka = Vratka
		FROM @Polozky
		WHERE ID = @Cursor_ID;

		EXEC USER_MnozstviArtikluVJednotkach @Artikl_ID, @Mnozstvi, @Vratka;
		
		FETCH NEXT FROM MY_CURSOR INTO @Cursor_ID
	END
	CLOSE MY_CURSOR;
	DEALLOCATE MY_CURSOR;

	SELECT 
		@MnozstviVJednotkach = STRING_AGG(CONCAT(Mnozstvi, ' ', Kod), ' ') WITHIN GROUP (ORDER BY VychoziMnozstvi DESC) 
	FROM (		
		SELECT 
			Kod, 
			SUM(Mnozstvi) AS Mnozstvi,
			MIN(VychoziMnozstvi) AS VychoziMnozstvi 
		FROM #MnozstviVJednotkach 
		WHERE JeVychoziJednotka = 0 and Vratka = 0
		GROUP BY Kod 
		UNION ALL
		SELECT 
			'ks', 
			SUM(Mnozstvi) AS Mnozstvi, 
			MIN(VychoziMnozstvi) AS VychoziMnozstvi 
		FROM #MnozstviVJednotkach 
		WHERE JeVychoziJednotka = 1 and Vratka = 0
	) AS M
	WHERE Mnozstvi > 0;

	DECLARE @Separator VARCHAR(3) = ' | ';

	SELECT 
		@MnozstviVJednotkach = CONCAT(@MnozstviVJednotkach, @Separator, STRING_AGG(CONCAT('-', Mnozstvi, ' ', Kod), ' ') WITHIN GROUP (ORDER BY VychoziMnozstvi DESC)) 
	FROM (		
		SELECT 
			Kod, 
			SUM(Mnozstvi) AS Mnozstvi,
			MIN(VychoziMnozstvi) AS VychoziMnozstvi 
		FROM #MnozstviVJednotkach 
		WHERE JeVychoziJednotka = 0 and Vratka = 1
		GROUP BY Kod 
		UNION ALL
		SELECT 
			'ks', 
			SUM(Mnozstvi) AS Mnozstvi, 
			MIN(VychoziMnozstvi) AS VychoziMnozstvi 
		FROM #MnozstviVJednotkach 
		WHERE JeVychoziJednotka = 1 and Vratka = 1
	) AS M
	WHERE Mnozstvi > 0;

	SELECT @MnozstviVJednotkach = IIF(
		CHARINDEX(@Separator, @MnozstviVJednotkach) = 1 
		OR CHARINDEX(@Separator, @MnozstviVJednotkach) = LEN(@MnozstviVJednotkach) - LEN(@Separator) + 1,
		REPLACE(@MnozstviVJednotkach, @Separator, ''),
		@MnozstviVJednotkach);

	IF @ZobrazVysledek = 1
		SELECT 
			SUM(Mnozstvi) AS Mnozstvi, 
			Kod, MIN(VychoziMnozstvi) AS VychoziMnozstvi 
		FROM #MnozstviVJednotkach 
		WHERE JeVychoziJednotka = 0 
		GROUP BY Kod
		UNION ALL
		SELECT 
			SUM(Mnozstvi) AS Mnozstvi, 
			'ks', 
			MIN(VychoziMnozstvi) AS VychoziMnozstvi 
		FROM #MnozstviVJednotkach 
		WHERE JeVychoziJednotka = 1 and Vratka = 0
		UNION ALL
		SELECT 
			SUM(Mnozstvi) AS Mnozstvi, 
			'ks*', 
			MIN(VychoziMnozstvi) AS VychoziMnozstvi 
		FROM #MnozstviVJednotkach 
		WHERE JeVychoziJednotka = 1 and Vratka = 1
		ORDER BY VychoziMnozstvi DESC

	SET NOCOUNT OFF;
END;
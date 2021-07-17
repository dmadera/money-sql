CREATE OR ALTER PROCEDURE USER_MnozstviArtikluVJednotkach (
	@ID UNIQUEIDENTIFIER,
	@Mnozstvi INT,
	@Vratka BIT,
	@ZobrazVysledek BIT = 0
) AS BEGIN
	
	SET NOCOUNT ON;
	
	IF OBJECT_ID('tempdb..#MnozstviVJednotkach') IS NULL 
	BEGIN
		DECLARE @dummy USER_MnozstviVJednotkach;
		SELECT * INTO #MnozstviVJednotkach FROM @dummy;
	END;

	DECLARE @VychoziMnozstvi INT;
	DECLARE @Cursor_ID UNIQUEIDENTIFIER;

	DECLARE MY_CURSOR CURSOR LOCAL FAST_FORWARD FOR
	SELECT ID FROM Artikly_ArtiklJednotka AS ArtJed WHERE Parent_ID = @ID ORDER BY VychoziMnozstvi DESC

	OPEN MY_CURSOR
	FETCH NEXT FROM MY_CURSOR INTO @Cursor_ID
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		INSERT INTO #MnozstviVJednotkach
		SELECT 
			ID,
			Kod, 
			VychoziMnozstvi,
			FLOOR(@Mnozstvi/VychoziMnozstvi),
			FLOOR(@Mnozstvi/VychoziMnozstvi) * VychoziMnozstvi,
			IIF(ParentJednotka_ID IS NULL, 1, 0),
			@Vratka
		FROM Artikly_ArtiklJednotka WHERE ID = @Cursor_ID;

		SET @Mnozstvi -= (SELECT FLOOR(@Mnozstvi/VychoziMnozstvi) * VychoziMnozstvi FROM Artikly_ArtiklJednotka WHERE ID = @Cursor_ID);
		
		FETCH NEXT FROM MY_CURSOR INTO @Cursor_ID;
	END
	CLOSE MY_CURSOR
	DEALLOCATE MY_CURSOR;

	IF @ZobrazVysledek = 1
		SELECT * FROM #MnozstviVJednotkach;

	SET NOCOUNT OFF;
END
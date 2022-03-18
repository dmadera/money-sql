CREATE OR ALTER TRIGGER USER_Artikly_ArtiklProduktovyKlic_AfterInsertUpdate
ON Artikly_ArtiklProduktovyKlic
AFTER INSERT, UPDATE
AS
BEGIN
	IF SESSION_CONTEXT(N'USER_Artikly_ArtiklProduktovyKlic_AfterInsertUpdate') = 'disable'
		RETURN; 

	EXEC sp_set_session_context N'USER_Artikly_Artikl_AfterInsertUpdate', N'disable';

	UPDATE Artikly_Artikl SET
		PLU = ISNULL(P.Priznaky, '')
	FROM Artikly_Artikl A
	INNER JOIN inserted ON inserted.Parent_ID = A.ID
	LEFT JOIN USER_ArtiklyPriznaky AS P ON P.Artikl_ID = A.ID;

	EXEC sp_set_session_context N'USER_Artikly_Artikl_AfterInsertUpdate', NULL;

	DECLARE @VychoziCenik_ID AS UNIQUEIDENTIFIER;
	SET @VychoziCenik_ID = (SELECT TOP 1 Agenda.VychoziCenik_ID FROM System_AgendaDetail AS Agenda);

	DECLARE @AkcniCenik_ID AS UNIQUEIDENTIFIER;
	SET @AkcniCenik_ID = (SELECT TOP 1 ID FROM Ceniky_Cenik AS Cenik WHERE Cenik.Kod = '_AKCE');

	EXEC sp_set_session_context N'USER_Ceniky_PolozkaCeniku_AfterInsertUpdate', N'disable';

	-- prida Artikly s PK 'A' nebo 'S' do akcniho ceniku 
	INSERT INTO Ceniky_PolozkaCeniku (
		Group_ID, Deleted, Hidden, Locked,
		Create_ID, Create_Date,
		Artikl_ID, Cena, Kod, Nazev, TypCeny, VlastniKod, 
		VlastniNazev, VychCena, VychoziCenik_ID, VychoziTypCeny, VypocetVyseZmeny, 
		VypocetZpusobVypoctu, Poznamka, Cenik_ID, 
		CanGetDataFromGroup, VlastniDruhSazby, DruhSazby, 
		NepodlehatSleveDokladu, Attachments, BudouciCena, ZmenaVMene, 
		ZmenaVProcentech, VypocetBudouciCeny, IDokladPriceListItemsExported
	) SELECT 
		@AkcniCenik_ID, 0, 0, 0,
		ISNULL(Art.Modify_ID, Art.Create_ID), ISNULL(Art.Modify_Date, Art.Create_Date),
		Art.ID, VychoziCena.Cena, Art.Kod, Art.Nazev, 0, 0, 
		0, VychoziCena.Cena, @VychoziCenik_ID, 0, 0, 
		0, '', @AkcniCenik_ID, 1, 0, 1,
		1, 0, 0, 0, 
		0, 0, 0
	FROM Artikly_Artikl AS Art
	INNER JOIN inserted ON inserted.Parent_ID = Art.ID AND inserted.ProduktovyKlic_ID IN (SELECT ID FROM Artikly_ProduktovyKlic Pk WHERE Kod = 'A' OR Kod = 'S')
	INNER JOIN Ceniky_PolozkaCeniku VychoziCena ON VychoziCena.Artikl_ID = Art.ID AND VychoziCena.Cenik_ID = @VychoziCenik_ID
	LEFT JOIN Ceniky_PolozkaCeniku Cena ON Cena.Artikl_ID = Art.ID AND Cena.Cenik_ID = @AkcniCenik_ID
	WHERE Cena.ID IS NULL AND Art.Hidden = 0 AND Art.Deleted = 0;

	EXEC sp_set_session_context N'USER_Ceniky_PolozkaCeniku_AfterInsertUpdate', NULL;
END
CREATE OR ALTER TRIGGER USER_Ceniky_PolozkaCeniku_AfterInsertUpdate
ON Ceniky_PolozkaCeniku
AFTER INSERT, UPDATE
AS
BEGIN
	IF SESSION_CONTEXT(N'USER_Ceniky_PolozkaCeniku_AfterInsertUpdate') = 'disable'
		RETURN; 

	DECLARE @VychoziCenik_ID AS UNIQUEIDENTIFIER;
	SET @VychoziCenik_ID = (SELECT TOP 1 Agenda.VychoziCenik_ID FROM System_AgendaDetail AS Agenda);

	UPDATE Ceniky_PolozkaCeniku SET
		Marze_UserData = PolCen.Marze,
		MarzePosledniNakup_UserData = PolCen.MarzePosledniNakup,
		Cena = PolCen.Cena,
		BudouciCena = IIF(PolCen.Marze <> Cena.Marze_UserData, PolCen.BudouciCena, 0),
		Cena25_UserData = PolCen.Cena25,
		CisloDokladu_UserData = ISNULL(PoslPrijem.CisloDokladu, ''),
		DatumZmenyZasoby_UserData = IIF(PoslPrijem.Datum IS NULL, '', FORMAT(PoslPrijem.Datum, 'yyyy.MM.dd HH:mm:ss')),
		PosledniNaskladneni_UserData = ISNULL(PoslPrijem.Datum, CAST('1753-01-01 00:00:00' AS DATETIME)),
		VypocetVyseZmeny = 0,
		NepodlehatSleveDokladu = PolCen.NepodlehaSleveDokladu
	FROM Ceniky_PolozkaCeniku AS Cena
	INNER JOIN inserted ON inserted.ID = Cena.ID
	INNER JOIN Artikly_Artikl AS Artikl ON Artikl.ID = Cena.Artikl_ID
	INNER JOIN USER_PolozkyCeniku AS PolCen ON PolCen.ID = Cena.ID
	LEFT JOIN USER_PosledniPrijemZasoby AS PoslPrijem ON PoslPrijem.Zasoba_ID = PolCen.Zasoba_ID;

	EXEC sp_set_session_context N'USER_Artikly_Artikl_AfterInsertUpdate', N'disable';

	UPDATE Artikly_Artikl SET
		StitekCena_UserData = ArtStitek.ProdejniCena, 
		StitekTisk_UserData = 1
	FROM Artikly_Artikl Art
	INNER JOIN inserted ON inserted.Artikl_ID = Art.ID AND inserted.Cenik_ID = @VychoziCenik_ID
	INNER JOIN USER_ArtiklyStitek AS ArtStitek ON Art.ID = ArtStitek.ID
	WHERE 
		Art.StitekCena_UserData != ArtStitek.ProdejniCena
		OR (Art.StitekMnozstvi_UserData = 0 AND ArtStitek.Mnozstvi > 0);

	EXEC sp_set_session_context N'USER_Artikly_Artikl_AfterInsertUpdate', NULL; 
END;
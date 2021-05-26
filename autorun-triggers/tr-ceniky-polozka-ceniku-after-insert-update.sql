CREATE OR ALTER TRIGGER TR_Ceniky_PolozkaCeniku_AfterInsertUpdate
ON Ceniky_PolozkaCeniku
AFTER INSERT, UPDATE
AS
BEGIN

	DECLARE @VychoziCenik_ID AS UNIQUEIDENTIFIER;
	SET @VychoziCenik_ID = (SELECT TOP 1 Agenda.VychoziCenik_ID FROM System_AgendaDetail AS Agenda);

	UPDATE Ceniky_PolozkaCeniku SET
		SkladovaCena_UserData = StavCena.JednotkovaSkladovaCena,
		Marze_UserData = IIF(StavCena.JednotkovaSkladovaCena = 0, 0, ROUND(100/StavCena.JednotkovaSkladovaCena*(Cena.Cena-StavCena.JednotkovaSkladovaCena), 2)),
		Cena = ROUND(Cena.Cena, 2),
		NepodlehatSleveDokladu = IIF(Cena.Cenik_ID = @VychoziCenik_ID, 0, 1),
		Cenik_ID = @VychoziCenik_ID
	FROM Ceniky_PolozkaCeniku AS Cena 
	INNER JOIN inserted ON inserted.ID = Cena.ID
	INNER JOIN CSW_BI_StavSkladuVCenach AS StavCena ON StavCena.Artikl_ID = Cena.Artikl_ID AND StavCena.Sklad_ID = Cena.Sklad_ID;

	-- spusti trigger artikly, ktery aktualizuje i skladove zasoby
	UPDATE Artikly_Artikl SET
		Deleted = Artikl.Deleted
	FROM Artikly_Artikl AS Artikl
	INNER JOIN inserted AS Cena ON Cena.Artikl_ID = Artikl.ID 
	WHERE Cena.Cenik_ID = @VychoziCenik_ID;

END;
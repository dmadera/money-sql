CREATE OR ALTER TRIGGER TR_Ceniky_PolozkaCeniku_AfterInsertUpdate
ON Ceniky_PolozkaCeniku
AFTER INSERT, UPDATE
AS
BEGIN

	DECLARE @VychoziCenik_ID AS UNIQUEIDENTIFIER;
	SET @VychoziCenik_ID = (SELECT TOP 1 Agenda.VychoziCenik_ID FROM System_AgendaDetail AS Agenda);

	DECLARE @VychoziSklad_ID AS UNIQUEIDENTIFIER;
	SET @VychoziSklad_ID = (SELECT TOP 1 Agenda.VychoziSklad_ID FROM System_AgendaDetail AS Agenda);

	UPDATE Ceniky_PolozkaCeniku SET
		SkladovaCena_UserData = StavCena.JednotkovaSkladovaCena,
		Marze_UserData = IIF(StavCena.JednotkovaSkladovaCena = 0, 0, ROUND(100/StavCena.JednotkovaSkladovaCena*(Cena.Cena-StavCena.JednotkovaSkladovaCena), 2)),
		Cena = ROUND(Cena.Cena, 2),
		NepodlehatSleveDokladu = IIF(Cena.Cenik_ID = @VychoziCenik_ID, 0, 1),
		Sklad_ID = @VychoziSklad_ID
		--CisloDokladu_UserData = ISNULL(Pohyb.CisloDokladu, ''),
		--DatumZmenyZasoby_UserData = IIF(pohyb.Datum IS NULL, '', FORMAT(Pohyb.Datum, 'yyyy.MM.dd HH:mm:ss'))
	FROM Ceniky_PolozkaCeniku AS Cena 
	INNER JOIN inserted ON inserted.ID = Cena.ID
	INNER JOIN CSW_BI_StavSkladuVCenach AS StavCena ON StavCena.Artikl_ID = Cena.Artikl_ID AND StavCena.Sklad_ID = Cena.Sklad_ID
	LEFT JOIN Sklady_Zasoba AS Zasoba ON Zasoba.Artikl_ID = Cena.Artikl_ID
	LEFT JOIN (
		SELECT 
			Pohyb.Konto_ID,
			ISNULL(MAX(Pohyb.Modify_Date), MAX(Pohyb.Create_Date)) AS Datum
		FROM S5_Sklady_PohybZasobyPrehled AS Pohyb
		WHERE Pohyb.DruhPohybu = 0
		GROUP BY Pohyb.Konto_ID
	) AS SubPohyb ON SubPohyb.Konto_ID = Zasoba.ID
	LEFT JOIN (
		SELECT Konto_ID, CisloDokladu, ISNULL(Modify_Date, Create_Date) AS Datum
		FROM S5_Sklady_PohybZasobyPrehled
	) AS Pohyb ON Pohyb.Konto_ID = SubPohyb.Konto_ID AND Pohyb.Datum = SubPohyb.Datum

	-- spusti trigger artikly, ktery aktualizuje i skladove zasoby
	UPDATE Artikly_Artikl SET
		Deleted = Artikl.Deleted
	FROM Artikly_Artikl AS Artikl
	INNER JOIN inserted AS Cena ON Cena.Artikl_ID = Artikl.ID 
	WHERE Cena.Cenik_ID = @VychoziCenik_ID;

END;
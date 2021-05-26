CREATE OR ALTER TRIGGER TR_SkladovyDoklad_DodaciListPrijaty_AfterInsert
ON SkladovyDoklad_DodaciListPrijaty
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @VychoziCenik_ID AS UNIQUEIDENTIFIER;
	SET @VychoziCenik_ID = (SELECT TOP 1 Agenda.VychoziCenik_ID FROM System_AgendaDetail AS Agenda);

	-- po tvorbe DL Money automaticky edituje neco na artiklech
	-- tzn. spusti se na polozky trigger artiklu

	ALTER TABLE Ceniky_PolozkaCeniku DISABLE TRIGGER TR_Ceniky_PolozkaCeniku_AfterInsertUpdate;

	UPDATE Ceniky_PolozkaCeniku SET 
		SkladovaCena_UserData = StavCena.JednotkovaSkladovaCena,
		Marze_UserData = IIF(StavCena.JednotkovaSkladovaCena = 0, 0, ROUND(100/StavCena.JednotkovaSkladovaCena*(Cena.Cena-StavCena.JednotkovaSkladovaCena), 2)),
		Cena = ROUND(Cena.Cena, 2),
		CisloDokladu_UserData = ISNULL(Doklad.CisloDokladu, ''),
		DatumZmenyZasoby_UserData = IIF(ISNULL(Doklad.Modified, Doklad.Created) IS NULL, '', FORMAT(ISNULL(Doklad.Modified, Doklad.Created), 'yyyy.MM.dd HH:mm:ss'))
	FROM Ceniky_PolozkaCeniku AS Cena
	INNER JOIN Obchod_ObsahPolozkySArtiklem AS ObsahPol ON ObsahPol.Artikl_ID = Cena.Artikl_ID AND ObsahPol.Sklad_ID = Cena.Sklad_ID
	INNER JOIN SkladovyDoklad_PolozkaDodacihoListuPrijateho AS Pol ON Pol.ObsahPolozky_ID = ObsahPol.ID 
	INNER JOIN inserted AS Doklad ON Doklad.ID = Pol.Parent_ID
	INNER JOIN CSW_BI_StavSkladuVCenach AS StavCena ON StavCena.Artikl_ID = Cena.Artikl_ID AND StavCena.Sklad_ID = Cena.Sklad_ID

	ALTER TABLE Ceniky_PolozkaCeniku ENABLE TRIGGER TR_Ceniky_PolozkaCeniku_AfterInsertUpdate;
END
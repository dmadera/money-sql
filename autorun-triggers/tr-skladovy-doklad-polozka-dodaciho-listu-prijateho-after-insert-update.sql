CREATE OR ALTER TRIGGER TR_SkladovyDoklad_PolozkaDodacihoListuPrijateho_AfterInsertUpdate
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
END
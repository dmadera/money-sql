CREATE OR ALTER TRIGGER USER_SkladovyDoklad_PolozkaDodacihoListuPrijateho_AfterInsertUpdate
ON SkladovyDoklad_PolozkaDodacihoListuPrijateho
AFTER INSERT, UPDATE
AS
BEGIN

	IF SESSION_CONTEXT(N'USER_SkladovyDoklad_PolozkaDodacihoListuPrijateho_AfterInsertUpdate') = 'disable'
		RETURN; 

	EXEC sp_set_session_context N'USER_Ceniky_PolozkaCeniku_AfterInsertUpdate', N'disable';

	UPDATE Ceniky_PolozkaCeniku SET
		MarzeP_UserData = Marze_UserData,
		Locked = 1
	FROM  Ceniky_PolozkaCeniku AS Cena
	INNER JOIN Obchod_ObsahPolozkySArtiklem AS ObsahPol ON ObsahPol.Artikl_ID = Cena.Artikl_ID
	INNER JOIN inserted AS Polozka ON Polozka.ObsahPolozky_ID = ObsahPol.ID
	WHERE Polozka.Deleted = 0;

	EXEC sp_set_session_context N'USER_Ceniky_PolozkaCeniku_AfterInsertUpdate', NULL;
END
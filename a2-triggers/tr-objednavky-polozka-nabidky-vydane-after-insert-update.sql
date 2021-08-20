CREATE OR ALTER TRIGGER USER_Objednavky_PolozkaNabidkyVydane_AfterInsertUpdate
ON Objednavky_PolozkaNabidkyVydane
AFTER INSERT, UPDATE
AS
BEGIN
	IF SESSION_CONTEXT(N'USER_Objednavky_PolozkaNabidkyVydane_AfterInsertUpdate') = 'disable'
		RETURN; 
	
	/* marze, nakupni cena do polozky */
	UPDATE Objednavky_PolozkaNabidkyVydane SET
		Marze_UserData = IIF(Cena.JednotkovaSkladovaCena = 0 OR Pol.JednCena = 0, 0, ROUND(100/Cena.JednotkovaSkladovaCena*(Pol.JednCena-Cena.JednotkovaSkladovaCena), 2)),
		NakupniCena_UserData = Cena.JednotkovaSkladovaCena
	FROM Objednavky_PolozkaNabidkyVydane AS Pol
	INNER JOIN inserted ON inserted.ID = Pol.ID
	INNER JOIN Obchod_ObsahPolozkySArtiklem AS Obsah ON Obsah.ID = Pol.ObsahPolozky_ID
	INNER JOIN CSW_BI_StavSkladuVCenach AS Cena ON Cena.Artikl_ID = Obsah.Artikl_ID
	
END
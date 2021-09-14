CREATE OR ALTER TRIGGER USER_Objednavky_PolozkaObjednavkyPrijate_AfterInsertUpdate
ON Objednavky_PolozkaObjednavkyPrijate
AFTER INSERT, UPDATE
AS
BEGIN
	IF SESSION_CONTEXT(N'USER_Objednavky_PolozkaObjednavkyPrijate_AfterInsertUpdate') = 'disable'
		RETURN; 

	/* marze, nakupni cena do polozky */
	UPDATE Objednavky_PolozkaObjednavkyPrijate SET
		Marze_UserData = IIF(Cena.JednotkovaSkladovaCena = 0 OR Pol.JednCena = 0, 0, ROUND(100/Cena.JednotkovaSkladovaCena*(Pol.JednCena-Cena.JednotkovaSkladovaCena), 2)),
		NakupniCena_UserData = Cena.JednotkovaSkladovaCena,
		DoporuceneMnozstvi_UserData = 
			IIF(J.MnKar > 0 AND Pol.Mnozstvi % J.MnKar != 0 
				AND ((Pol.Mnozstvi < J.MnKar AND Pol.Mnozstvi % J.MnKar >= J.MnKar * 2/3) OR (Pol.Mnozstvi > J.MnKar)),
				CONCAT(
					CAST(CEILING(Pol.Mnozstvi/J.MnKar)*J.MnKar AS INT), 
					'  | +',
					CAST(J.MnKar - Pol.Mnozstvi % J.MnKar AS INT)
				),
				''
			)
	FROM Objednavky_PolozkaObjednavkyPrijate AS Pol
	INNER JOIN inserted ON inserted.ID = Pol.ID
	INNER JOIN Obchod_ObsahPolozkySArtiklem AS Obsah ON Obsah.ID = Pol.ObsahPolozky_ID
	INNER JOIN USER_ArtiklyJednotky J ON J.Artikl_ID = Obsah.Artikl_ID
	INNER JOIN CSW_BI_StavSkladuVCenach AS Cena ON Cena.Artikl_ID = Obsah.Artikl_ID

END
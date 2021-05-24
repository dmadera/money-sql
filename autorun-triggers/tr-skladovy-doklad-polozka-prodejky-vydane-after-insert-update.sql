CREATE OR ALTER TRIGGER TR_SkladovyDoklad_PolozkaProdejkyVydane_AfterInsert
ON SkladovyDoklad_PolozkaProdejkyVydane
AFTER INSERT, UPDATE
AS
BEGIN

	/* 
		MnozstviPozn_UserData:
		* posledni kus
		- odber do minusu
	*/
	UPDATE SkladovyDoklad_PolozkaProdejkyVydane SET
		MnozstviPozn_UserData = (CASE
			WHEN Zas.DostupneMnozstvi = 0 THEN '*'
			WHEN Zas.DostupneMnozstvi < 0 THEN '-'
			ELSE ''
		END),
		Marze_UserData = IIF(Cena.JednotkovaSkladovaCena = 0, 0, ROUND(100/Cena.JednotkovaSkladovaCena*(Pol.JednCena-Cena.JednotkovaSkladovaCena), 2)),
		NakupniCena_UserData = Cena.JednotkovaSkladovaCena,
		RPDP_UserData = IIF(Art.PreneseniDane_ID IS NULL, '', 'RPDP')
	FROM SkladovyDoklad_PolozkaProdejkyVydane AS Pol
	INNER JOIN inserted ON inserted.ID = Pol.ID
	INNER JOIN Obchod_ObsahPolozkySArtiklem AS Obsah ON Obsah.ID = Pol.ObsahPolozky_ID
	INNER JOIN Sklady_Zasoba AS Zas ON Zas.ID = Obsah.Zasoba_ID
	INNER JOIN CSW_BI_StavSkladuVCenach AS Cena ON Cena.Artikl_ID = Obsah.Artikl_ID
	INNER JOIN Artikly_Artikl AS Art ON Art.ID = Obsah.Artikl_ID

	
END
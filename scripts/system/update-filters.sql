-- Firma
EXECUTE USER_System_Filter
	'Firma', 'V��e slevy', 'Firma', NULL, 'AdFi.HodnotaSlevy {0}', 1;
EXECUTE USER_System_Filter
	'Firma', 'Vlastn� sleva', 'Firma', NULL, 'AdFi.VlastniSleva {0}', 3;

-- FakturaVydana
EXECUTE USER_System_Filter
	'FakturaVydana', 'Odb�ratel - Typ spojen�', 'Odb�ratel', 'TypSpojeni',
	'FaFa.Firma_ID IN (SELECT [Root_ID] FROM [\ACTUALAGENDA]..[Adresar_Spojeni] WITH(NOLOCK) WHERE ([TypSpojeni_ID] {0})) AND (FaFa.Firma_ID IS NOT NULL)',
	5;

-- DodaciListVydany
EXECUTE USER_System_Filter
	'DodaciListVydany', 'Odb�ratel - Kredit FA', 'Adresa', '',
	'AdFi.KreditFA_UserData {0}', 2;
EXECUTE USER_System_Filter
	'DodaciListVydany', 'Odb�ratel - Existuje e-mail', 'Adresa', '',
	'NOT (AdFi.EmailSpojeni_ID IS NULL)', 3;
EXECUTE USER_System_Filter
	'DodaciListVydany', 'Odb�ratel - Existuje telefon', 'Adresa', '',
	'NOT (AdFi.EmailSpojeni_ID IS NULL)', 3;


-- PolozkaCeniku
EXECUTE USER_System_Filter
	'PolozkaCeniku', 'Druh polo�ky katalogu', 'Katalog', 'DruhArtiklu',
	'ArAr.DruhArtiklu_ID IN (SELECT [ID] FROM [\ACTUALAGENDA]..[Ciselniky_DruhArtiklu] WITH(NOLOCK) WHERE ([ID] {0})) ', 
	5;

USE S4_System
GO 

-- ObjednavkaPrijata
EXECUTE USER_System_Grid_Column 
	'ObjednavkaPrijata', 'Adresar_Firma', 'AdFi.KreditFa_UserData', 'KreditFa_UserData', 'Kredit FA', 0;

-- DodaciListVydany
EXECUTE USER_System_Grid_Column 
	'DodaciListVydany', 'Adresar_Firma', 'AdFi.KreditFa_UserData', 'KreditFa_UserData', 'Kredit FA', 0;
EXECUTE USER_System_Grid_Column 
	'DodaciListVydany', 'Adresar_Firma', 'AdFi.NahradniPlneni_UserData', 'NahradniPlneni_UserData', 'Odbìratel NP', 0;
EXECUTE USER_System_Grid_Column 
	'DodaciListVydany', 'SkladovyDoklad_DodaciListVydany', 'SkDLVy.StavExpedice', 'StavExpedice', 'Stav expedice', 0;

-- PolozkaObjednavkyPrijate
EXECUTE USER_System_Grid_Column 
	'PolozkaObjednavkyPrijate', 'Artikly_Artikl', 'ArAr.BaleniMnozstvi_UserData', 'BaleniMnozstvi_UserData', 'Balení množství', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaObjednavkyPrijate', 'Artikly_Artikl', 'ArAr.BaleniJednotky_UserData', 'BaleniJednotky_UserData', 'Balení jednotky', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaObjednavkyPrijate', 'Artikly_Artikl', 'ArAr.BaleniMnozstviKart_UserData', 'BaleniMnozstviKart_UserData', 'Balení množství kart', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaObjednavkyPrijate', 'Artikly_Artikl', 'ArAr.BaleniJednotkyKart_UserData', 'BaleniJednotkyKart_UserData', 'Balení jednotky kart', 0;

-- PolozkaObjednavkyVydane
EXECUTE USER_System_Grid_Column 
	'PolozkaObjednavkyVydane', 'Artikly_Artikl', 'ArAr.BaleniMnozstvi_UserData', 'BaleniMnozstvi_UserData', 'Balení množství', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaObjednavkyVydane', 'Artikly_Artikl', 'ArAr.BaleniJednotky_UserData', 'BaleniJednotky_UserData', 'Balení jednotky', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaObjednavkyVydane', 'Artikly_Artikl', 'ArAr.BaleniMnozstviKart_UserData', 'BaleniMnozstviKart_UserData', 'Balení množství kart', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaObjednavkyVydane', 'Artikly_Artikl', 'ArAr.BaleniJednotkyKart_UserData', 'BaleniJednotkyKart_UserData', 'Balení jednotky kart', 0;

-- PolozkaDodacihoListuVydanehoMetadataTemplate
EXECUTE USER_System_Grid_Column 
	'PolozkaDodacihoListuVydanehoMetadataTemplate', 'Artikly_Artikl', 'ArAr.BaleniMnozstvi_UserData', 'BaleniMnozstvi_UserData', 'Balení množství', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaDodacihoListuVydanehoMetadataTemplate', 'Artikly_Artikl', 'ArAr.BaleniJednotky_UserData', 'BaleniJednotky_UserData', 'Balení jednotky', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaDodacihoListuVydanehoMetadataTemplate', 'Artikly_Artikl', 'ArAr.BaleniMnozstviKart_UserData', 'BaleniMnozstviKart_UserData', 'Balení množství kart', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaDodacihoListuVydanehoMetadataTemplate', 'Artikly_Artikl', 'ArAr.BaleniJednotkyKart_UserData', 'BaleniJednotkyKart_UserData', 'Balení jednotky kart', 0;

-- PolozkaProdejkyVydaneMetadataTemplate
EXECUTE USER_System_Grid_Column 
	'PolozkaProdejkyVydaneMetadataTemplate', 'Artikly_Artikl', 'ArAr.BaleniMnozstvi_UserData', 'BaleniMnozstvi_UserData', 'Balení množství', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaProdejkyVydaneMetadataTemplate', 'Artikly_Artikl', 'ArAr.BaleniJednotky_UserData', 'BaleniJednotky_UserData', 'Balení jednotky', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaProdejkyVydaneMetadataTemplate', 'Artikly_Artikl', 'ArAr.BaleniMnozstviKart_UserData', 'BaleniMnozstviKart_UserData', 'Balení množství kart', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaProdejkyVydaneMetadataTemplate', 'Artikly_Artikl', 'ArAr.BaleniJednotkyKart_UserData', 'BaleniJednotkyKart_UserData', 'Balení jednotky kart', 0;

-- PolozkaDodacihoListuPrijatehoMetadataTemplate
EXECUTE USER_System_Grid_Column 
	'PolozkaDodacihoListuPrijatehoMetadataTemplate', 'Artikly_Artikl', 'ArAr.BaleniMnozstvi_UserData', 'BaleniMnozstvi_UserData', 'Balení množství', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaDodacihoListuPrijatehoMetadataTemplate', 'Artikly_Artikl', 'ArAr.BaleniJednotky_UserData', 'BaleniJednotky_UserData', 'Balení jednotky', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaDodacihoListuPrijatehoMetadataTemplate', 'Artikly_Artikl', 'ArAr.BaleniMnozstviKart_UserData', 'BaleniMnozstviKart_UserData', 'Balení množství kart', 0;
EXECUTE USER_System_Grid_Column 
	'PolozkaDodacihoListuPrijatehoMetadataTemplate', 'Artikly_Artikl', 'ArAr.BaleniJednotkyKart_UserData', 'BaleniJednotkyKart_UserData', 'Balení jednotky kart', 0;

-- Zasoba
EXECUTE USER_System_Grid_Column 
	'Zasoba', 'Artikly_Artikl', 'ArAr.BaleniMnozstvi_UserData', 'BaleniMnozstvi_UserData', 'Balení množství', 0;
EXECUTE USER_System_Grid_Column 
	'Zasoba', 'Artikly_Artikl', 'ArAr.BaleniJednotky_UserData', 'BaleniJednotky_UserData', 'Balení jednotky', 0;
EXECUTE USER_System_Grid_Column 
	'Zasoba', 'Artikly_Artikl', 'ArAr.BaleniMnozstviKart_UserData', 'BaleniMnozstviKart_UserData', 'Balení množství kart', 0;
EXECUTE USER_System_Grid_Column 
	'Zasoba', 'Artikly_Artikl', 'ArAr.BaleniJednotkyKart_UserData', 'BaleniJednotkyKart_UserData', 'Balení jednotky kart', 0;
EXECUTE USER_System_Grid_Column 
	'Zasoba', 'Ceniky_PolozkaCeniku', 'CePo.Marze_UserData', 'Marze_UserData', 'Marže', 0, 1;

-- oprava spatne provazaneho sloupce Druh polozky katalogu
UPDATE MetaData_GridColumns SET
	DefaultVisible = 1,
	ColumnName = 'ArArCiDr.Nazev'
FROM MetaData_GridColumns AS C 
INNER JOIN MetaData_Objects AS O ON O.ID = C.Object_ID
WHERE C.ColumnName = 'CiDr.Nazev' AND O.ObjectName = 'Zasoba';

UPDATE MetaData_GridTables SET
	KeyColumnForeign = 'ArAr.DruhArtiklu_ID',
	TableAlias = 'ArArCiDr'
FROM MetaData_GridTables T
INNER JOIN MetaData_Objects O on O.ID = T.Object_ID
WHERE O.ObjectName = 'Zasoba' AND T.TableName = 'Ciselniky_DruhArtiklu';

-- Artikl
EXECUTE USER_System_Grid_Column 
	'Artikl', 'Ceniky_PolozkaCeniku', 'CePo.Marze_UserData', 'Marze_UserData', 'Marže', 0, 1;
EXECUTE USER_System_Grid_Column 
	'Artikl', 'Sklady_StavZasoby', 'SkSt.ZustatekJednotkaCena', 'ZustatekJednotkaCena', 'Skladová cena', 0, 1;

-- PolozkaCeniku
EXECUTE USER_System_Grid_Column 
	'PolozkaCeniku', 'Sklady_StavZasoby', 'SkSt.ZustatekJednotkaCena', 'ZustatekJednotkaCena', 'Skladová cena', 0, 1;
EXECUTE USER_System_Grid_Column 
	'PolozkaCeniku', 'Artikly_Artikl', 'ArtArt.ZustatekJednotkaCena', 'ZustatekJednotkaCena', 'Skladová cena', 0, 1;

EXECUTE USER_System_Grid_Table
	'PolozkaCeniku', 'Ciselniky_DruhArtiklu', 'ArArCiDr', 'ID', 'ArAr.DruhArtiklu_ID';
EXECUTE USER_System_Grid_Column 
	'PolozkaCeniku', 'Ciselniky_DruhArtiklu', 'ArArCiDr.Nazev', 'DruhArtikluNazev', 'Druh položky katalogu', 0;

-- ProdejkaVydana
EXECUTE USER_System_Grid_Table
	'ProdejkaVydana', 'EconomicBase_NavazujiciDoklad', 'EcNa', '', '', 'EcNa.DokladZdroj_ID = SkPrV.ID AND EcNa.DokladCilObjectName = ''PokladniDoklad''';
EXECUTE USER_System_Grid_Column 
	'ProdejkaVydana', 'EconomicBase_NavazujiciDoklad', 'EcNa.PopisCil', 'PopisCil', 'Navazující pokladní doklad', 0;
EXECUTE USER_System_Grid_Column 
	'ProdejkaVydana', 'Adresar_Firma', 'AdFi.Nazev', 'AdFiNazev', 'Firma zažadit jako', 0;
EXECUTE USER_System_Grid_Column 
	'ProdejkaVydana', 'SkladovyDoklad_ProdejkaVydana', 'SkPrV.StavExpedice', 'StavExpedice', 'Stav expedice', 0;

-- PohybZasoby
UPDATE MetaData_GridTables SET
	TableName = 'USER_S5_Sklady_PohybZasobyPrehled'
FROM MetaData_GridTables T
INNER JOIN MetaData_Objects O ON O.ID = T.Object_ID
WHERE (O.ObjectName = 'PohybZasobyPrehled' AND T.TableName = 'S5_Sklady_PohybZasobyPrehled');
EXECUTE USER_System_Grid_Column 
	'PohybZasobyPrehled', 'USER_S5_Sklady_PohybZasobyPrehled', 'SkPo.DatumVystaveni', 'DatumVystaveni', 'Datum vystavení', 0;
EXECUTE USER_System_Grid_Table
	'PohybZasobyPrehled', 'Adresar_Firma', 'AdFi', 'ID', 'SkPo.Firma_ID';
EXECUTE USER_System_Grid_Column 
	'PohybZasobyPrehled', 'Adresar_Firma', 'AdFi.Kod', 'AdFiKod', 'Firma kód', 0;
EXECUTE USER_System_Grid_Column 
	'PohybZasobyPrehled', 'Adresar_Firma', 'AdFi.Nazev', 'AdFiNazev', 'Firma zaøadit jako', 0;

-- HistorickaCena
EXECUTE USER_System_Grid_Table
	'HistorickaCena', 'System_Users', 'SyUs', 'ID', 'CeHi.Create_ID', NULL, 1, 0;
EXECUTE USER_System_Grid_Column 
	'HistorickaCena', 'System_Users', 'SyUs.FullName', 'FullName', 'Uživatel', 0;
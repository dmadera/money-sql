-- uvolni editaci nakupnich jednotek v katalogu
ALTER TABLE Obchod_ObsahPolozkySArtiklem 
	DROP CONSTRAINT FK_Obchod_ObsahPolozkySArtiklem_Artikly_ArtiklJednotka_Jednotka_ID;
ALTER TABLE Obchod_ObsahPolozkySArtiklem  WITH NOCHECK 
	ADD CONSTRAINT FK_Obchod_ObsahPolozkySArtiklem_Artikly_ArtiklJednotka_Jednotka_ID 
	FOREIGN KEY(Jednotka_ID)
	REFERENCES Artikly_ArtiklJednotka (ID)
	ON DELETE SET NULL;
ALTER TABLE Obchod_ObsahPolozkySArtiklem 
	CHECK CONSTRAINT FK_Obchod_ObsahPolozkySArtiklem_Artikly_ArtiklJednotka_Jednotka_ID;

-- smaze nepouzivane typy spojeni
DELETE FROM Adresar_TypSpojeni
where Nazev NOT LIKE '@%' AND Nazev NOT LIKE '#%';

IF EXISTS(SELECT 1 FROM sys.columns  WHERE Name = N'StavExpedice' AND Object_ID = Object_ID(N'dbo.SkladovyDoklad_DodaciListVydany'))
BEGIN
    ALTER TABLE SkladovyDoklad_DodaciListVydany DROP COLUMN StavExpedice;
END;
ALTER TABLE SkladovyDoklad_DodaciListVydany ADD StavExpedice AS 
CASE 
	WHEN Expedovano_UserData <> '1753-01-01 00:00:00.000' THEN 'EX'
	WHEN Rozvoz_UserData <> '1753-01-01 00:00:00.000' THEN 'RO'
	WHEN Pripraveno_UserData <> '1753-01-01 00:00:00.000' THEN 'PØ'
	ELSE ''
END;

IF EXISTS(SELECT 1 FROM sys.columns  WHERE Name = N'StavExpedice' AND Object_ID = Object_ID(N'dbo.SkladovyDoklad_ProdejkaVydana'))
BEGIN
    ALTER TABLE SkladovyDoklad_ProdejkaVydana DROP COLUMN StavExpedice;
END;
ALTER TABLE SkladovyDoklad_ProdejkaVydana ADD StavExpedice AS 
CASE 
	WHEN Expedovano_UserData <> '1753-01-01 00:00:00.000' THEN 'EX'
	WHEN Rozvoz_UserData <> '1753-01-01 00:00:00.000' THEN 'RO'
	WHEN Pripraveno_UserData <> '1753-01-01 00:00:00.000' THEN 'PØ'
	ELSE ''
END;

IF EXISTS(SELECT 1 FROM sys.columns  WHERE Name = N'StavExpediceKod' AND Object_ID = Object_ID(N'dbo.SkladovyDoklad_DodaciListVydany'))
BEGIN
    ALTER TABLE SkladovyDoklad_DodaciListVydany DROP COLUMN StavExpediceKod;
END;
ALTER TABLE SkladovyDoklad_DodaciListVydany ADD StavExpediceKod AS 
CASE 
	WHEN Expedovano_UserData <> '1753-01-01 00:00:00.000' THEN 'delivered'
	WHEN Rozvoz_UserData <> '1753-01-01 00:00:00.000' THEN 'shipped'
	WHEN Pripraveno_UserData <> '1753-01-01 00:00:00.000' THEN 'prepared'
	ELSE ''
END;

IF EXISTS(SELECT 1 FROM sys.columns  WHERE Name = N'StavExpediceKod' AND Object_ID = Object_ID(N'dbo.SkladovyDoklad_ProdejkaVydana'))
BEGIN
    ALTER TABLE SkladovyDoklad_ProdejkaVydana DROP COLUMN StavExpediceKod;
END;
ALTER TABLE SkladovyDoklad_ProdejkaVydana ADD StavExpediceKod AS 
CASE 
	WHEN Expedovano_UserData <> '1753-01-01 00:00:00.000' THEN 'delivered'
	WHEN Rozvoz_UserData <> '1753-01-01 00:00:00.000' THEN 'shipped'
	WHEN Pripraveno_UserData <> '1753-01-01 00:00:00.000' THEN 'prepared'
	ELSE ''
END;

UPDATE SkladovyDoklad_DodaciListVydany SET
	Expedovano_UserData = DatumSkladovehoPohybu
WHERE PriznakVyrizeno = 1;

UPDATE SkladovyDoklad_ProdejkaVydana SET
	Expedovano_UserData = DatumUcetnihoPripadu
WHERE ZauctovaniZpracovano = 1;
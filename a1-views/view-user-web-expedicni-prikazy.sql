IF OBJECT_ID('dbo.USER_WEB_ExpedicniPrikazy', 'V') IS NOT NULL DROP VIEW dbo.USER_WEB_ExpedicniPrikazy;
GO

CREATE VIEW dbo.USER_WEB_ExpedicniPrikazy AS
SELECT 
	D.ID AS id,
	D.CisloDokladu AS uid,
	IIF(D.DatumVystaveni = '1753-01-01 00:00:00.000', NULL, IIF(CAST(D.DatumVystaveni AS date) = CAST(D.Create_Date as date), D.Create_Date, D.DatumVystaveni)) AS created,
	D.Vystavil AS createdBy, 
	F.Kod AS companyUid,
	F.Nazev As companyTitle,
	D.DodaciAdresaNazev as recipientTitle,
	D.DodaciAdresaMisto as recipientCity,
	D.DodaciAdresaPSC as recipientZip,
	D.AdresaKontaktniOsobaNazev as recipientPerson,
	F.Tel1Cislo as recipientPersonPhone,
	IIF(D.ZapornyPohyb = 1, -1, 1) * D.SumaZaklad AS totalPrice,
	ISNULL(zpD.Kod, '') AS shippingCode,
	ISNULL(zpD.Nazev, '') AS shippingName,
	IIF(D.Pripraveno_UserData = '1753-01-01 00:00:00.000', NULL, D.Pripraveno_UserData) AS preparedOn,
	IIF(D.Rozvoz_UserData = '1753-01-01 00:00:00.000', NULL, D.Rozvoz_UserData) AS shippedOn,
	IIF(D.Expedovano_UserData = '1753-01-01 00:00:00.000', NULL, D.Expedovano_UserData) AS completedOn,
	D.StavExpedice AS shippingStatus,
	D.StavExpediceKod AS shippingStatusCode,
	'DodaciListVydany' AS tableName
FROM SkladovyDoklad_DodaciListVydany D WITH (NOLOCK)
INNER JOIN Adresar_Firma F WITH (NOLOCK) ON F.ID = D.Firma_ID
LEFT JOIN Ciselniky_ZpusobDopravy zpD WITH (NOLOCK) ON zpD.ID = D.ZpusobDopravy_ID
WHERE 
	(D.Deleted = 0) 
	AND (D.Faze = 1)
UNION 
SELECT 
	D.ID AS id, 
	D.CisloDokladu AS uid,
	IIF(D.DatumVystaveni = '1753-01-01 00:00:00.000', NULL, IIF(CAST(D.DatumVystaveni AS date) = CAST(D.Create_Date as date), D.Create_Date, D.DatumVystaveni)) AS created,
	D.Vystavil AS createdBy, 
	F.Kod AS companyUid,
	F.Nazev As companyTitle,
	D.DodaciAdresaNazev as recipientTitle,
	D.DodaciAdresaMisto as recipientCity,
	D.DodaciAdresaPSC as recipientZip,
	D.AdresaKontaktniOsobaNazev as recipientPerson,
	F.Tel1Cislo as recipientPersonPhone,
	IIF(D.ZapornyPohyb = 1, -1, 1) * D.SumaZaklad AS totalPrice,
	ISNULL(zpD.Kod, '') AS shippingCode,
	ISNULL(zpD.Nazev, '') AS shippingName,
	IIF(D.Pripraveno_UserData = '1753-01-01 00:00:00.000', NULL, D.Pripraveno_UserData) AS preparedOn,
	IIF(D.Rozvoz_UserData = '1753-01-01 00:00:00.000', NULL, D.Rozvoz_UserData) AS shippedOn,
	IIF(D.Expedovano_UserData = '1753-01-01 00:00:00.000', NULL, D.Expedovano_UserData) AS completedOn,
	D.StavExpedice AS shippingStatus,
	D.StavExpediceKod AS shippingStatusCode,
	'ProdejkaVydana' AS tableName
FROM SkladovyDoklad_ProdejkaVydana D WITH (NOLOCK)
INNER JOIN Adresar_Firma F WITH (NOLOCK) ON F.ID = D.Firma_ID
LEFT JOIN Ciselniky_ZpusobDopravy zpD WITH (NOLOCK) ON zpD.ID = D.ZpusobDopravy_ID
WHERE 
	(D.Deleted = 0) 
	AND (D.Faze = 1)
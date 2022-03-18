IF OBJECT_ID('dbo.USER_WEB_Pohyby', 'V') IS NOT NULL DROP VIEW dbo.USER_WEB_Pohyby;
GO

CREATE VIEW dbo.USER_WEB_Pohyby AS
SELECT 
	P.ID as id,
	Z.Artikl_ID as stockItemId, 
	Z.Kod as stockItemUid,
	P.PolozkaNazev as stockItemTitle,
	P.ProdejniJednCena as price,
	MnozstviZ as amount,
	P.Jednotka as unit, 
	P.Doklad_ID as stockIssueId,
	P.CisloDokladu as stockIssueUid,
	F.Kod as companyUid,
	P.AdresaNazev as companyTitle,
	ISNULL(D.created, P.DatumVystaveni) as created,
	D.shippingStatusCode,
	D.shippingStatus,
	D.shippingCode,
	D.shippingName
FROM USER_S5_Sklady_PohybZasobyPrehled P
INNER JOIN dbo.Sklady_Zasoba Z WITH(NOLOCK) ON Z.ID = P.Konto_ID
LEFT JOIN USER_WEB_ExpedicniPrikazy D WITH(NOLOCK) ON D.id = P.Doklad_ID
INNER JOIN dbo.Adresar_Firma F WITH(NOLOCK) ON F.ID = P.Firma_ID
WHERE MnozstviZ <> 0
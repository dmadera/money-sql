IF OBJECT_ID('dbo.USER_WEB_Katalog', 'V') IS NOT NULL DROP VIEW dbo.USER_WEB_Katalog;
GO

CREATE VIEW dbo.USER_WEB_Katalog AS
SELECT 
	A.ID as id,
	A.Kod as uid,
	A.Nazev as title,
	A.PLU as flags,
	aJ.Kod as unit,
	A.Zkratka12 as position,
	A.StitekCena_UserData as price,
	S.ZustatekMnozstvi as stockAmount,
	A.BaleniMnozstvi_UserData as packageAmounts,
	A.BaleniJednotky_UserData as packageUnits,
	A.KategorieRetezec_UserData as category,
	D.Kod as itemTypeCode, 
	D.Nazev as itemTypeTitle,
	Z.Rezervovano as reservedAmount, 
	Z.Objednano as orderedAmount,
	ISNULL(pS.amountNotYetPrepared, 0) as notYetPreparedAmount,
	A.PoznamkaTisk_UserData as stockNote
FROM Artikly_Artikl A WITH (NOLOCK)
INNER JOIN Artikly_ArtiklJednotka aJ WITH(NOLOCK) ON aJ.ID = A.HlavniJednotka_ID
INNER JOIN Ciselniky_DruhArtiklu D WITH (NOLOCK) ON D.ID = A.DruhArtiklu_ID
INNER JOIN Sklady_Zasoba Z WITH (NOLOCK) ON Z.Artikl_ID = A.ID
INNER JOIN Sklady_StavZasoby S WITH (NOLOCK) ON S.ID = Z.AktualniStav_ID
LEFT JOIN (
	SELECT P.artiklId as artiklId, sum(IIF(D.totalPrice < 0, P.amount * -1, P.amount)) as amountNotYetPrepared from (
		SELECT O.Artikl_ID AS artiklId, IIF(P.Vratka = 0, P.Mnozstvi, P.Mnozstvi *-1) as amount, P.Parent_ID as parentId 
		from SkladovyDoklad_PolozkaDodacihoListuVydaneho P
		inner join Obchod_ObsahPolozkySArtiklem O on O.ID = P.ObsahPolozky_ID
		WHERE P.Deleted = 0
		UNION
		SELECT O.Artikl_ID AS artiklId, IIF(P.Vratka = 0, P.Mnozstvi, P.Mnozstvi *-1) as amount, P.Parent_ID as parentId 
		from SkladovyDoklad_PolozkaProdejkyVydane P
		inner join Obchod_ObsahPolozkySArtiklem O on O.ID = P.ObsahPolozky_ID
		WHERE P.Deleted = 0
	) P
	INNER JOIN USER_WEB_ExpedicniPrikazy D ON D.id = P.parentId
	WHERE shippingStatus = ''
	GROUP BY P.artiklId
) pS ON pS.artiklId = A.ID
WHERE 
	(A.Deleted = 0) AND
	(D.Kod <> 'ZRU')
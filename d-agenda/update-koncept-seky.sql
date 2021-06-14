DECLARE @pocet INT = (SELECT COUNT(*) FROM Ucetnictvi_InterniDoklad AS ID WHERE ID.CisloDokladu = '_SK000000');

IF @pocet != 1 RAISERROR('Pocet nalezenych seku _SK000000 != 1!', 16, 5);

UPDATE Ucetnictvi_InterniDoklad SET
	Nazev = 'NEMAZAT koncept šeku',
	DatumVystaveni = DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0),
	Create_Date = DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0),
	Modify_Date = DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)
FROM Ucetnictvi_InterniDoklad AS ID
WHERE ID.CisloDokladu = '_SK000000'
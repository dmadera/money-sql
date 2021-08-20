IF OBJECT_ID('dbo.USER_ArtiklyStitek', 'V') IS NOT NULL DROP VIEW dbo.USER_ArtiklyStitek;
GO

CREATE VIEW dbo.USER_ArtiklyStitek AS
SELECT 
	Art.ID AS ID,
	Art.Nazev AS Nazev, 
	Art.BaleniMnozstvi_UserData AS BaleniMnozstvi,
	Art.BaleniJednotky_UserData AS BaleniJednotky,
	ISNULL(Cena.Cena, 0) AS ProdejniCena,  
	ISNULL(Stav.ZustatekMnozstvi, 0) AS Mnozstvi
FROM Artikly_Artikl AS Art WITH(NOLOCK)
LEFT JOIN Ceniky_PolozkaCeniku AS Cena WITH(NOLOCK) ON Cena.Artikl_ID = Art.ID AND Cenik_ID = (SELECT TOP 1 VychoziCenik_ID FROM System_AgendaDetail)
LEFT JOIN Sklady_Zasoba AS Zas WITH(NOLOCK) ON Zas.Artikl_ID = Art.ID AND Zas.Sklad_ID = (SELECT TOP 1 VychoziSklad_ID FROM System_AgendaDetail)
LEFT JOIN Sklady_StavZasoby AS Stav WITH(NOLOCK) ON Stav.Konto_ID = Zas.ID
SELECT 
	Obj.ID, 
	Obj.CisloDokladu, 
	Obj.FakturacniAdresaNazev, 
	Obj.Nazev, 
	MIN(CAST(Pol.PriznakVyrizeno AS INT)) AS Vyrizeno
FROM Objednavky_ObjednavkaPrijata AS Obj WITH(NOLOCK)
INNER JOIN Objednavky_PolozkaObjednavkyPrijate AS Pol WITH(NOLOCK) ON Pol.Parent_ID = Obj.ID 
INNER JOIN Obchod_ObsahPolozkySArtiklem AS ObsahPol WITH(NOLOCK) ON ObsahPol.ID = Pol.ObsahPolozky_ID
INNER JOIN Sklady_StavZasoby AS Stav WITH(NOLOCK) ON Stav.Konto_ID = ObsahPol.Zasoba_ID
WHERE 
	Obj.PriznakVyrizeno = 0
	AND Obj.Deleted = 0
	AND Pol.PriznakVyrizeno = 0
	AND (Pol.Zbyva > Stav.ZustatekMnozstvi)
GROUP BY Obj.ID, Obj.CisloDokladu, Obj.FakturacniAdresaNazev, Obj.Nazev
HAVING MIN(CAST(Pol.PriznakVyrizeno AS INT)) = 0
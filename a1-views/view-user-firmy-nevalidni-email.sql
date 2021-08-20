IF OBJECT_ID('dbo.USER_FirmyNevalidniEmail', 'V') IS NOT NULL DROP VIEW dbo.USER_FirmyNevalidniEmail;
GO

CREATE VIEW dbo.USER_FirmyNevalidniEmail AS
SELECT 
	F.Kod, F.Nazev, S.SpojeniCislo
FROM Adresar_Firma F WITH(NOLOCK)
INNER JOIN Adresar_Spojeni S WITH(NOLOCK) ON S.Parent_ID = F.ID
INNER JOIN Adresar_TypSpojeni T WITH(NOLOCK) ON T.ID = S.TypSpojeni_ID
WHERE T.DruhSpojeni = 2 
	AND NOT (S.SpojeniCislo LIKE '%_@__%.__%' 
    AND PATINDEX('%[^a-z,0-9,@,.,_]%', REPLACE(S.SpojeniCislo, '-', 'a')) = 0);
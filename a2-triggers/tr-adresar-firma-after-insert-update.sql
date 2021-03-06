CREATE OR ALTER TRIGGER USER_Adresar_Firma_AfterInsertUpdate
ON Adresar_Firma
AFTER INSERT, UPDATE
AS
BEGIN
	IF SESSION_CONTEXT(N'USER_Adresar_Firma_AfterInsertUpdate') = 'disable'
		RETURN; 
	
	-- pokud u firmy neexistuje osoba "PREB", vytvorit kopii osobu 
	INSERT INTO Adresar_Osoba (
		Parent_ID, Root_ID, Group_ID, Deleted, Locked, Create_ID, Create_Date, Modify_ID, Modify_Date, Kod, Poznamka, 
		Jmeno, Prijmeni, Pohlavi, Funkce, 
		CisloOsoby, DatumPosty, Email, KrestniJmeno, Nazev, Osloveni, PosilatPostu, Spojeni, 
		Hidden, FaxCislo, FaxMistniCislo, FaxPredvolba, FaxPredvolbaStat, 
		FaxStatID, FaxKlapka, Attachments, EmailSpojeni_ID, FaxSpojeni_ID,
		FunkceOsoby_ID, OsloveniProEmail, DatumNarozeni, System_Komentar, System_Priznak
	)
	SELECT 
		Firma.ID, Firma.ID, Osoba.Group_ID, Osoba.Deleted, Osoba.Locked, ISNULL(Firma.Modify_ID, Firma.Create_ID), GETDATE(), Firma.Modify_ID, Firma.Modify_Date, CONCAT(Firma.Kod, 'PRE'), Osoba.Poznamka, 
		'', '', Osoba.Pohlavi, Osoba.Funkce, 
		1, Osoba.DatumPosty, Osoba.Email, Osoba.KrestniJmeno, Osoba.Nazev, Osoba.Osloveni, Osoba.PosilatPostu, Osoba.Spojeni, 
		Osoba.Hidden, Osoba.FaxCislo, Osoba.FaxMistniCislo, Osoba.FaxPredvolba, Osoba.FaxPredvolbaStat, 
		Osoba.FaxStatID, Osoba.FaxKlapka, Osoba.Attachments, Osoba.EmailSpojeni_ID, Osoba.FaxSpojeni_ID, 
		Osoba.FunkceOsoby_ID, Osoba.OsloveniProEmail, Osoba.DatumNarozeni, Osoba.System_Komentar, Osoba.System_Priznak
	FROM inserted AS Firma
	LEFT JOIN ( 
		SELECT Osoba.Parent_ID AS Firma_ID
		FROM Adresar_Osoba AS Osoba WITH (NOLOCK)
		WHERE Osoba.FunkceOsoby_ID = (SELECT TOP 1 ID FROM Adresar_FunkceOsoby AS Funkce WHERE Funkce.Code = 'PRE')
	) AS NotFirma ON NotFirma.Firma_ID = Firma.ID
	INNER JOIN Adresar_Osoba AS Osoba WITH (NOLOCK) ON Osoba.Kod = 'AD00001PRE'
	WHERE NotFirma.Firma_ID IS NULL AND Osoba.ID IS NOT NULL;

	-- aktualizuje data prebirajici osoby
	UPDATE Adresar_Osoba SET
		Kod = CONCAT(Firma.Kod, 'PRE'),
		Jmeno = '',
		Prijmeni = IIF(SpojeniPreb.ID IS NULL, SpojeniTel.Popis, SpojeniPreb.Popis),
		Nazev = IIF(SpojeniPreb.ID IS NULL, SpojeniTel.Popis, SpojeniPreb.Popis),
		Tel1Cislo = IIF(SpojeniPreb.ID IS NULL, SpojeniTel.SpojeniCislo, SpojeniPreb.SpojeniCislo),
		TelefonSpojeni1_ID = IIF(SpojeniPreb.ID IS NULL, SpojeniTel.ID, SpojeniPreb.ID)
	FROM Adresar_Osoba AS Osoba
	INNER JOIN Adresar_Firma AS Firma ON Firma.ID = Osoba.Parent_ID
	INNER JOIN inserted ON inserted.ID = Firma.ID
	LEFT JOIN (
		SELECT Spojeni.ID, Spojeni.Parent_ID, Spojeni.Popis, Spojeni.SpojeniCislo
		FROM Adresar_Spojeni AS Spojeni WITH (NOLOCK)
		INNER JOIN Adresar_TypSpojeni AS TypSpojeni WITH (NOLOCK) ON TypSpojeni.ID = Spojeni.TypSpojeni_ID
		WHERE TypSpojeni.Kod = 'TelPreb'
	) AS SpojeniPreb ON SpojeniPreb.Parent_ID = Firma.ID 
	LEFT JOIN (
		SELECT Spojeni.ID, Spojeni.Parent_ID, Spojeni.Popis, Spojeni.SpojeniCislo
		FROM Adresar_Spojeni AS Spojeni WITH (NOLOCK)
		INNER JOIN Adresar_TypSpojeni AS TypSpojeni WITH (NOLOCK) ON TypSpojeni.ID = Spojeni.TypSpojeni_ID
		INNER JOIN (
			SELECT Spojeni.Parent_ID, MIN(LEN(TypSpojeni.Kod)) AS LenTypSpoj
			FROM Adresar_Spojeni AS Spojeni WITH (NOLOCK)
			INNER JOIN Adresar_TypSpojeni AS TypSpojeni WITH (NOLOCK) ON TypSpojeni.ID = Spojeni.TypSpojeni_ID
			WHERE TypSpojeni.Kod LIKE 'Tel%' AND Spojeni.Popis != ''
			GROUP BY Spojeni.Parent_ID
		) AS SQ ON SQ.Parent_ID = Spojeni.Parent_ID AND TypSpojeni.Kod LIKE 'Tel%' AND Spojeni.Popis != '' AND LEN(TypSpojeni.Kod) = SQ.LenTypSpoj
	) AS SpojeniTel ON SpojeniTel.Parent_ID = Firma.ID;

	-- aktualizuje nazevFirmy v dodavatelske tabulce
	UPDATE Artikly_ArtiklDodavatel SET
		NazevFirmy = F.Nazev
	FROM Artikly_ArtiklDodavatel AD WITH (NOLOCK)
	INNER JOIN inserted F ON F.ID = AD.Firma_ID;

	UPDATE Adresar_Firma SET 
		Doprava_UserData = ISNULL(Doprava.Nazev, ''),
		Platba_UserData = ISNULL(Platba.Nazev, ''),
		NahradniPlneni_UserData = IIF(Firma.EvidovatNahradniPlneni = 1, 'NP', ''),
		Sek_UserData = ISNULL(FirAdrKlic.Kod, ''),
		HlavniCinnost_UserData = ISNULL(FirCinnost.Kod, ''),
		HlavniOsoba_ID = Osoba.ID,
		UvadetNaDokladech = 1,
		KreditFa_UserData = CASE
			WHEN Firma.PouzivatKredit = 0 THEN 'FA'
			WHEN Firma.PouzivatKredit = 1 AND Firma.HodnotaKreditu = 0 THEN '' 
			WHEN Firma.PouzivatKredit = 1 AND Firma.HodnotaKreditu > 0 THEN CONCAT('FA ', FORMAT(Firma.HodnotaKreditu / 1000, '#')) END,
		Provozovna_UserData = IIF(Firma.OdlisnaAdresaProvozovny = 1, 
			Firma.ProvNazev 
			+ IIF(Firma.ProvNazev <> '' AND Firma.ProvMisto <> '', ', ', '') + Firma.ProvMisto 
			+ IIF((Firma.ProvNazev <> '' OR Firma.ProvMisto <> '') AND Firma.ProvUlice <> '', ', ', '') + Firma.ProvUlice, ''),
		DatumPorizeni_UserData = IIF(Firma.DatumPorizeni_UserData = '1753-01-01 00:00:00.000', GETDATE(), Firma.DatumPorizeni_UserData) 
	FROM Adresar_Firma AS Firma
	INNER JOIN inserted ON inserted.ID = Firma.ID
	LEFT JOIN Ciselniky_ZpusobDopravy AS Doprava WITH (NOLOCK) ON Doprava.ID = Firma.ZpusobDopravy_ID
	LEFT JOIN Ciselniky_ZpusobPlatby AS Platba WITH (NOLOCK) ON Platba.ID = Firma.ZpusobPlatby_ID
	LEFT JOIN (
		SELECT FirAdrKlic.Parent_ID, Kod
		FROM Adresar_FirmaAdresniKlic AS FirAdrKlic
		INNER JOIN Adresar_AdresniKlic AS AdrKlic WITH (NOLOCK) ON AdrKlic.ID = FirAdrKlic.AdresniKlic_ID
		WHERE AdrKlic.Kod = '-SEK'
	) AS FirAdrKlic ON FirAdrKlic.Parent_ID = Firma.ID
	LEFT JOIN (
		SELECT FirCinnost.Parent_ID, Cinnost.Kod AS Kod, MIN(FirCinnost.Poradi) AS Poradi
		FROM Adresar_FirmaCinnost AS FirCinnost WITH (NOLOCK)
		INNER JOIN Ciselniky_Cinnost AS Cinnost WITH (NOLOCK) ON Cinnost.ID = FirCinnost.Cinnost_ID
		GROUP BY FirCinnost.Parent_ID, Cinnost.Kod
	) AS FirCinnost ON FirCinnost.Parent_ID = Firma.ID
	LEFT JOIN Adresar_Osoba AS Osoba WITH (NOLOCK) ON Osoba.Parent_ID = Firma.ID AND Osoba.FunkceOsoby_ID = (SELECT TOP 1 ID FROM Adresar_FunkceOsoby AS Funkce WHERE Funkce.Code = 'PRE');
END
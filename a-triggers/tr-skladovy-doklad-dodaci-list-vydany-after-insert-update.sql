CREATE OR ALTER TRIGGER USER_SkladovyDoklad_DodaciListVydany_AfterInsertUpdate
ON SkladovyDoklad_DodaciListVydany
AFTER INSERT, UPDATE
AS
BEGIN

	INSERT INTO Ucetnictvi_InterniDoklad (
            Group_ID, Locked, Deleted, Faze,
            CleneniDPH_ID, DomaciMena_ID, Predkontace_ID, PredkontaceZaokrouhleni_ID, RegistraceDPH_ID, 
			UcetDal_ID, UcetMD_ID, PrimarniUcetMD_ID, PrimarniUcetDal_ID,
			SazbaDPH0_ID, SazbaDPH1_ID, SazbaDPH2_ID, Stat_ID, DruhDokladu_ID, Mena_ID, 
			ZaokrouhleniCelkovaCastka_ID, ZaokrouhleniDPH_ID, ZaokrouhleniDruhSazbyDPH, 
			TypDokladu, MojeFirmaFirma_ID, MojeFirmaStat_ID,
			DatumSchvaleni, DatumZauctovani, Schvalil_ID, Zauctoval_ID, 
            Poznamka, ParovaciSymbol, Create_ID, Create_Date, Modify_ID, Modify_Date, Vystavil, Odkaz, 
			CiselnaRada_ID,
            DatumPlneni, DatumUcetnihoPripadu, DatumVystaveni, DatumPlatby, DatumUplatneni, 
			AdresaMisto, AdresaNazev, AdresaPSC, AdresaStat, AdresaUlice,
			AdresaKontaktniOsobaJmeno, AdresaKontaktniOsobaNazev, AdresaKontaktniOsobaPrijmeni, 
			Osoba_ID, Firma_ID, IC, Jmeno, DIC
        ) SELECT
            ID.Group_ID, 0, 0, 0, 
			ID.CleneniDPH_ID, ID.DomaciMena_ID, ID.Predkontace_ID, ID.PredkontaceZaokrouhleni_ID, ID.RegistraceDPH_ID, 
			ID.UcetDal_ID, ID.UcetMD_ID, ID.PrimarniUcetMD_ID, ID.PrimarniUcetDal_ID,
			ID.SazbaDPH0_ID, ID.SazbaDPH1_ID, ID.SazbaDPH2_ID, ID.Stat_ID, ID.DruhDokladu_ID, ID.Mena_ID, 
			ID.ZaokrouhleniCelkovaCastka_ID, ID.ZaokrouhleniDPH_ID, ID.ZaokrouhleniDruhSazbyDPH,
			ID.TypDokladu, D.MojeFirmaFirma_ID, D.MojeFirmaStat_ID,
			GETDATE(), GETDATE(), D.Schvalil_ID, D.Zauctoval_ID,
			D.Nazev, D.CisloDokladu, D.Create_ID, GETDATE(), D.Modify_ID, GETDATE(), D.Vystavil, D.Odkaz,
			(SELECT ID FROM Ciselniky_CiselnaRada AS CisRada WHERE CisRada.Kod = '_SEKY'),
			GETDATE(),  GETDATE(),  GETDATE(), GETDATE(), GETDATE(),
			D.AdresaMisto, D.AdresaNazev, D.AdresaPSC, D.AdresaStat, D.AdresaUlice,
			D.AdresaKontaktniOsobaJmeno, D.AdresaKontaktniOsobaNazev, D.AdresaKontaktniOsobaPrijmeni, 
			D.Osoba_ID, D.Firma_ID, D.IC, D.Jmeno, D.DIC
        FROM inserted as D
		INNER JOIN System_Groups AS Grp ON Grp.ID = D.Group_ID
        INNER JOIN Adresar_Firma AS Fir ON Fir.ID = D.Firma_ID
		LEFT JOIN Adresar_FirmaAdresniKlic AS FirAdrKl ON FirAdrKl.Parent_ID = D.Firma_ID
		LEFT JOIN Adresar_AdresniKlic AS AdrKlic ON AdrKlic.ID = FirAdrKl.AdresniKlic_ID AND AdrKlic.Kod = '-SEK'
		LEFT JOIN Ucetnictvi_InterniDoklad AS IDa ON IDa.ParovaciSymbol = D.CisloDokladu
        LEFT JOIN Ucetnictvi_InterniDoklad AS ID ON ID.CisloDokladu = '_SK000000'
        WHERE 
			D.Storno = 0
			AND AdrKlic.ID IS NULL
			AND D.SumaCelkem >= 5000 
			AND (Fir.VlastniSleva = 0 OR Fir.HodnotaSlevy <= 0) 
			AND IDa.ID IS NULL;

	UPDATE Ucetnictvi_InterniDoklad SET
		ID = ID.ID
	FROM Ucetnictvi_InterniDoklad AS ID
	INNER JOIN inserted ON inserted.CisloDokladu = ID.ParovaciSymbol;

END
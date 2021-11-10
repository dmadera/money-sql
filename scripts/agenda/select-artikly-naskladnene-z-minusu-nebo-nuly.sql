	SELECT 
		A.KategorieRetezec_UserData, A.Kod, A.Nazev, S.ProdejniCena, S.Mnozstvi, S.BaleniJednotky, S.BaleniMnozstvi 
	from Artikly_Artikl A 
	inner join USER_ArtiklyStitek S ON S.ID = A.ID
	inner join Ciselniky_DruhArtiklu D ON D.ID = A.DruhArtiklu_ID
	where 
		A.StitekMnozstvi_UserData > 0
		AND A.ID IN (	
			SELECT O.Artikl_ID
			FROM SkladovyDoklad_PolozkaDodacihoListuVydaneho P
			inner join Obchod_ObsahPolozkySArtiklem O ON O.ID = P.ObsahPolozky_ID
			where MnozstviPozn_UserData IN ('-', '*')
			UNION ALL
			SELECT O.Artikl_ID
			FROM SkladovyDoklad_PolozkaProdejkyVydane P
			inner join Obchod_ObsahPolozkySArtiklem O ON O.ID = P.ObsahPolozky_ID
			where MnozstviPozn_UserData IN ('-', '*')
		)
	order by KategorieRetezec_UserData, A.Kod
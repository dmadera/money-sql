UPDATE System_UserAgenda SET
	ShowDeleteDialog = 1, 
	DataBox_Aktivni = 0, 
	CI_Aktivni = 0, 
	FilterListsOwn = 0,
	FilterLists = 0, 
	Attachments = 0,
	PridatNovyArtiklDoCeniku = 1,
	PridatNovyArtiklDoSkladu = 1,
	ZobrazitKartuSkladoveZasoby = 0,
	ZobrazitKartuCeniku = 1,
	PridatNovyArtiklDoCenikuGuidList = '',
	PridatNovyArtiklDoSkladuGuidList = '',
	R1 = 255, G1 = 255, B1 = 255, A1 = 255,
	R2 = 240, G2 = 255, B2 = 255, A2 = 255,
	RowGridColor1Enabled = 1,
	RowGridColor2Enabled = 1
FROM System_UserAgenda;
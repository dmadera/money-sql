UPDATE System_UserSettings SET
	PamatovatSiSloupec = 1,
	PositionDetailTabs = 1,
	SumovatPoPridaniVsechPolozek = 0,
	AllowDragDropInTreeList = 0,
	FilterLists = 1,
	AdrAutoAres = 1,
	AdrAutoAresEx = 0 
FROM S4_System.dbo.System_UserSettings;
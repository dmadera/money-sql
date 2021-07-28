IF NOT EXISTS(
	SELECT F.ID 
	FROM MetaData_Filters AS F
	INNER JOIN MetaData_Objects AS O ON O.ID = F.Object_ID
	WHERE FilterCaption = 'Výše slevy' AND O.ObjectName = 'Firma'
)
	INSERT INTO MetaData_Filters (
		Parent_ID, 
		Object_ID, 
		Position, FilterCaption, DataType, ObjectName, Condition, 
		Enumerator_ID, IsUser, CommandTimeout, DateTimeMetaType, DateTimeType, IsGenerated,DecimalCount, Module_ID,Tag)
	SELECT
		(SELECT TOP 1 F.ID FROM MetaData_FilterGroups AS F INNER JOIN MetaData_Objects AS O ON O.ID = F.Object_ID WHERE F.GroupCaption = 'Firma'), 
		(SELECT TOP 1 ID FROM MetaData_Objects WHERE ObjectName = 'Firma'), 
		0, 'Výše slevy', 1, NULL, 'AdFi.HodnotaSlevy {0}', 
		NULL, 1, 30, 0, 0, 1, 2, NULL, 0;

IF NOT EXISTS(
	SELECT F.ID 
	FROM MetaData_Filters AS F
	INNER JOIN MetaData_Objects AS O ON O.ID = F.Object_ID
	WHERE FilterCaption = 'Vlastní sleva' AND O.ObjectName = 'Firma'
)
	INSERT INTO MetaData_Filters (
		Parent_ID, 
		Object_ID, 
		Position, FilterCaption, DataType, ObjectName, Condition, 
		Enumerator_ID, IsUser, CommandTimeout, DateTimeMetaType, DateTimeType, IsGenerated,DecimalCount, Module_ID,Tag)
	SELECT
		(SELECT TOP 1 F.ID FROM MetaData_FilterGroups AS F INNER JOIN MetaData_Objects AS O ON O.ID = F.Object_ID WHERE F.GroupCaption = 'Firma'), 
		(SELECT TOP 1 ID FROM MetaData_Objects WHERE ObjectName = 'Firma'), 
		0, 'Vlastní sleva', 3, NULL, 'AdFi.VlastniSleva {0}', 
		NULL, 1, 30, 0, 0, 1, 2, NULL, 0;

IF NOT EXISTS(
	SELECT F.ID 
	FROM MetaData_Filters AS F
	INNER JOIN MetaData_Objects AS O ON O.ID = F.Object_ID
	WHERE FilterCaption = 'Odbìratel - Typ spojení' AND O.ObjectName = 'FakturaVydana'
)
	INSERT INTO MetaData_Filters (
		Parent_ID, 
		Object_ID, 
		Position, FilterCaption, DataType, ObjectName, Condition, 
		Enumerator_ID, IsUser, CommandTimeout, DateTimeMetaType, DateTimeType, IsGenerated,DecimalCount, Module_ID,Tag)
	SELECT
		(SELECT TOP 1 F.ID FROM MetaData_FilterGroups AS F INNER JOIN MetaData_Objects AS O ON O.ID = F.Object_ID WHERE F.GroupCaption = 'Odbìratel' AND O.ObjectName = 'FakturaVydana'), 
		(SELECT TOP 1 ID FROM MetaData_Objects WHERE ObjectName = 'FakturaVydana'), 
		6, 'Odbìratel - Typ spojení', 5, 'TypSpojeni', 'FaFa.Firma_ID IN (SELECT [Root_ID] FROM [\ACTUALAGENDA]..[Adresar_Spojeni] WITH(NOLOCK) WHERE ([TypSpojeni_ID] {0})) AND (FaFa.Firma_ID IS NOT NULL)', 
		'00000000-0000-0000-0000-000000000000', 1, 30, 0, 0, 1, 2, '00000000-0000-0000-0000-000000000000', 0;

	DELETE FROM MetaData_Filters
	WHERE FilterCaption = 'Odbìratel - Typ spojení';
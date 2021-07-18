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
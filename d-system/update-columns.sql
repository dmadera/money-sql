IF NOT EXISTS(
	SELECT C.ID
	FROM MetaData_GridColumns AS C
	INNER JOIN MetaData_Objects AS O ON O.ID = C.Object_ID
	WHERE C.ColumnName = 'AdFi.KreditFa_UserData' AND O.ObjectName = 'ObjednavkaPrijata'
)
	INSERT INTO MetaData_GridColumns (
		Table_ID, 
		Object_ID, 
		ColumnName, ColumnAlias, ColumnCaption, ColumnType, ColumnPriority, 
		DefaultVisible, Enumerator_ID, DateTimeType, IsFixed, IsHidden, C.IsUser, 
		UserData, ColumnAlignment, DecimalCount, IsGenerated, C.Module_ID)
	SELECT
		(SELECT T.ID FROM MetaData_GridTables AS T INNER JOIN MetaData_Objects AS O ON O.ID = T.Object_ID WHERE T.TableName = 'Adresar_Firma' AND O.ObjectName = 'ObjednavkaPrijata'),
		(SELECT O.ID FROM MetaData_GridTables AS T INNER JOIN MetaData_Objects AS O ON O.ID = T.Object_ID WHERE T.TableName = 'Adresar_Firma' AND O.ObjectName = 'ObjednavkaPrijata'),
		'AdFi.KreditFa_UserData', 'KreditFA', 'Kredit FA', 0, 700, 
		0, NULL, 0, 0, 0, 1, 
		1, 0, 2, 1, NULL;
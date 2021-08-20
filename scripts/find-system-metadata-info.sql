select
	O.ObjectName,
	T.TableName,
	T.KeyColumn,
	T.KeyColumnForeign,
	T.KeyCustomRelation,
	C.ColumnName,
	C.ColumnAlias,
	C.ColumnType
from MetaData_GridColumns C
inner join MetaData_GridTables T ON T.ID = C.Table_ID
inner join MetaData_Objects O ON O.ID = C.Object_ID
where ColumnName = 'CiDr.Nazev'

select 
	O.ObjectName,
	T.TableName,
	T.KeyColumn,
	T.KeyColumnForeign,
	T.KeyCustomRelation
from MetaData_GridTables T
inner join MetaData_Objects O ON O.ID = T.Object_ID
where T.TableName = 'Ciselniky_DruhArtiklu' AND O.ObjectName = 'PolozkaCeniku'

select 
	O.ObjectName,
	F.FilterCaption,
	F.DataType,
	F.Condition,
	F.ObjectName AS ObjectNameJoin
from MetaData_Filters F
inner join MetaData_Objects O ON O.ID = F.Object_ID
where F.FilterCaption LIKE 'Odbìratel%' AND O.ObjectName = 'DodaciListVydany'
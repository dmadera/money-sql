select
	C.ID,
	O.ObjectName,
	T.ID,
	T.TableName,
	T.TableLocation,
	T.KeyColumn,
	T.KeyColumnForeign,
	T.KeyCustomRelation,
	C.ColumnName,
	C.ColumnAlias,
	C.ColumnType,
	C.ColumnCaption
from MetaData_GridColumns C
inner join MetaData_GridTables T ON T.ID = C.Table_ID
inner join MetaData_Objects O ON O.ID = C.Object_ID
where O.ObjectName LIKE '%prodejkav%'
--where T.TableLocation <> 1
order by C.ColumnCaption 

select 
	T.ID,
	O.ObjectName,
	T.TableName,
	T.KeyColumn,
	T.KeyColumnForeign,
	T.KeyCustomRelation
from MetaData_GridTables T
inner join MetaData_Objects O ON O.ID = T.Object_ID
where O.ObjectName LIKE '%historickaCena%'

select 
	O.ObjectName,
	F.FilterCaption,
	F.DataType,
	F.Condition,
	F.ObjectName AS ObjectNameJoin
from MetaData_Filters F
inner join MetaData_Objects O ON O.ID = F.Object_ID
where F.FilterCaption LIKE 'Odbìratel%' AND O.ObjectName = 'DodaciListVydany'
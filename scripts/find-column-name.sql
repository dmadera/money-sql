SELECT      
	C.name  AS 'ColumnName',
	T.name AS 'TableName'
FROM sys.columns C
JOIN sys.tables  T   ON C.object_id = T.object_id
WHERE c.name LIKE '%decim%'
ORDER BY TableName, ColumnName;
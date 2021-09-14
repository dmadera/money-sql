USE S4_System;

UPDATE MetaData_GridColumns SET
	DecimalCount = 2
-- select *
FROM MetaData_GridColumns
WHERE DecimalCount = 4;

UPDATE MetaData_GridColumns SET
	DecimalCount = 0
-- select *
FROM MetaData_GridColumns
WHERE 
	ColumnName LIKE '%mnozstvi%' 
	OR ColumnName LIKE '%.zbyva'
	OR ColumnName LIKE '%objednano%' 
	OR ColumnName LIKE '%rezervovano%';

UPDATE MetaData_GridColumns SET
	DecimalCount = 1
-- select *
FROM MetaData_GridColumns
WHERE 
	ColumnName LIKE '%marze%';

UPDATE MetaData_GridColumns SET
	ColumnAlignment = 1
FROM MetaData_GridColumns
WHERE 
	ColumnName LIKE '%balenimnozstvi_userdata%' 
	OR ColumnName LIKE '%balenijednotky_userdata%'
	OR ColumnName LIKE '%balenimnozstvikart_userdata%' 
	OR ColumnName LIKE '%balenijednotkykart_userdata%' 
	OR ColumnName LIKE '%sazbadph_userdata%'
	OR ColumnName LIKE '%prodej20avg_userdata%'
	OR ColumnName LIKE '%prodej20med_userdata%';
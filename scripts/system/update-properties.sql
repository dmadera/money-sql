USE S4_System;

UPDATE MetaData_Properties SET
	DecimalPlaces = 2
-- select *
FROM MetaData_Properties
WHERE DecimalPlaces = 4;

UPDATE MetaData_Properties SET
	DecimalPlaces = 0
-- select *
FROM MetaData_Properties
WHERE 
	PropertyName LIKE '%mnozstvi%' 
	OR PropertyName LIKE '%.zbyva'
	OR PropertyName LIKE '%objednano%' 
	OR PropertyName LIKE '%rezervovano%';

UPDATE MetaData_Properties SET
	DecimalPlaces = 1
-- select *
FROM MetaData_Properties
WHERE 
	PropertyName LIKE '%marze%';
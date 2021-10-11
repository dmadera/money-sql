USE S4_System;

DELETE FROM MetaData_Overrides WHERE IsUser = 1;
INSERT INTO MetaData_Overrides (Object_ID, Property_ID, IsUser, Length, DecimalPlaces, InnerObject_ID) 
SELECT
	Object_ID, P.ID, 1, null, 2, null
FROM MetaData_Properties P
INNER JOIN MetaData_Objects O ON O.ID = P.Object_ID
WHERE ObjectName LIKE 'Polozka%' AND PropertyName LIKE '%cena%';

/*UPDATE MetaData_Properties SET
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
*/
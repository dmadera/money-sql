USE S4_System;

DELETE FROM MetaData_Overrides WHERE IsUser = 1;
INSERT INTO MetaData_Overrides (Object_ID, Property_ID, IsUser, Length, DecimalPlaces, InnerObject_ID) 
SELECT
	Object_ID, P.ID, 1, null, 2, null
FROM MetaData_Properties P
INNER JOIN MetaData_Objects O ON O.ID = P.Object_ID
WHERE ObjectName LIKE 'Polozka%' AND PropertyName LIKE '%cena%';

INSERT INTO MetaData_Overrides (Object_ID, Property_ID, IsUser, Length, DecimalPlaces, InnerObject_ID) 
SELECT
	Object_ID, P.ID, 1, null, 0, null
FROM MetaData_Properties P
INNER JOIN MetaData_Objects O ON O.ID = P.Object_ID
WHERE P.PropertyName LIKE 'mnozstvi%'
	OR PropertyName LIKE '%objednano%' 
	OR PropertyName LIKE '%rezervovano%';

INSERT INTO MetaData_Overrides (Object_ID, Property_ID, IsUser, Length, DecimalPlaces, InnerObject_ID) 
SELECT
	Object_ID, P.ID, 1, null, 1, null
FROM MetaData_Properties P
INNER JOIN MetaData_Objects O ON O.ID = P.Object_ID
WHERE P.PropertyName LIKE '%marze%';

UPDATE Adresar_Firma SET Zprava = SUBSTRING(Zprava, 1, LEN(Zprava)-2)
FROM Adresar_Firma
WHERE Zprava LIKE '%' + CHAR(13) + CHAR(10);

UPDATE Adresar_Firma SET Zprava = SUBSTRING(Zprava, 1, LEN(Zprava)-2)
FROM Adresar_Firma
WHERE Zprava LIKE '%' + CHAR(13) + CHAR(10);

UPDATE Adresar_Firma SET Zprava = SUBSTRING(Zprava, 3, LEN(Zprava)-2)
FROM Adresar_Firma
WHERE Zprava LIKE CHAR(13) + CHAR(10) + '%';

UPDATE Adresar_Firma SET Zprava = SUBSTRING(Zprava, 3, LEN(Zprava)-2)
FROM Adresar_Firma
WHERE Zprava LIKE CHAR(13) + CHAR(10) + '%';
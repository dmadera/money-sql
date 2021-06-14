DECLARE @sql VARCHAR(MAX) = N''
DECLARE @crlf VARCHAR(2) = CHAR(13) + CHAR(10) ;

SELECT @sql += N'DROP VIEW ' 
    + QUOTENAME(OBJECT_SCHEMA_NAME(O.object_id)) + N'.'
    + QUOTENAME(O.name) + N'; ' + @crlf
FROM sys.views AS O
WHERE O.Name LIKE 'USER_%';

SELECT @sql += N'DROP TRIGGER ' 
    + QUOTENAME(OBJECT_SCHEMA_NAME(O.object_id)) + N'.'
    + QUOTENAME(O.name) + N'; ' + @crlf
FROM sys.triggers AS O
WHERE O.is_ms_shipped = 0
  AND O.parent_class_desc = N'OBJECT_OR_COLUMN'
  AND O.name LIKE 'USER_%';

SELECT @sql += N'DROP PROCEDURE ' 
    + QUOTENAME(SCHEMA_NAME(schema_id)) + N'.'
    + QUOTENAME(O.name) + N'; ' + @crlf
FROM sys.procedures AS O
WHERE O.Name LIKE 'USER_%';

SELECT @sql += N'DROP TYPE ' 
    + QUOTENAME(SCHEMA_NAME(schema_id)) + N'.'
    + QUOTENAME(O.name) + N'; ' + @crlf
FROM sys.types AS O
WHERE O.Name LIKE 'USER_%';

PRINT(@sql);
EXEC(@sql);

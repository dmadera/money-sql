DECLARE @sql VARCHAR(MAX) = ''
DECLARE @crlf VARCHAR(2) = CHAR(13) + CHAR(10) ;

SELECT @sql = @sql + 'DROP VIEW ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(V.name) +';' + @crlf
FROM sys.views AS V
WHERE V.Name LIKE 'USER_%';

PRINT @sql;
EXEC(@sql);
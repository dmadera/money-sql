USE S4_Agenda_PEMA;
GO

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT  QUOTENAME(t.name) AS DeletedTrigger
FROM sys.triggers AS t
WHERE t.is_ms_shipped = 0
  AND t.parent_class_desc = N'OBJECT_OR_COLUMN';

SELECT @sql += 
    N'DROP TRIGGER ' + 
    QUOTENAME(OBJECT_SCHEMA_NAME(t.object_id)) + N'.' + 
    QUOTENAME(t.name) + N'; ' + NCHAR(13)
FROM sys.triggers AS t
WHERE t.is_ms_shipped = 0
  AND t.parent_class_desc = N'OBJECT_OR_COLUMN';

EXEC(@sql);
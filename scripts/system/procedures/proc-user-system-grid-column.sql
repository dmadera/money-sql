USE S4_System
GO

CREATE OR ALTER PROCEDURE USER_System_Grid_Column 
	@ObjectName varchar(50),
	@TableName varchar(50),
	@ColumnName varchar(100),
	@ColumnAlias varchar(100),
	@ColumnCaption varchar(100),
	@ColumnType int,
	@ColumnAlignment int = 0
AS BEGIN

	SET NOCOUNT ON;
	DELETE FROM MetaData_GridColumns WHERE ID IN (
		SELECT C.ID	FROM MetaData_GridColumns AS C
		INNER JOIN MetaData_Objects AS O ON O.ID = C.Object_ID
		WHERE C.ColumnName = @ColumnName AND O.ObjectName = @ObjectName
	);
	SET NOCOUNT OFF;

	DECLARE @ObjectID uniqueidentifier;
	DECLARE @TableID uniqueidentifier;
	
	SELECT @TableID = T.ID, @ObjectID = O.ID 
	FROM MetaData_GridTables AS T (NOLOCK)
	INNER JOIN MetaData_Objects AS O (NOLOCK) ON O.ID = T.Object_ID 
	WHERE T.TableName = @TableName AND O.ObjectName = @ObjectName;

	INSERT INTO MetaData_GridColumns ( 
		Object_ID, Table_ID,
		ColumnName, ColumnAlias, ColumnCaption, ColumnType, ColumnAlignment,
		ColumnPriority, DefaultVisible, DateTimeType, IsFixed, IsHidden, C.IsUser, 
		UserData, DecimalCount, IsGenerated)
	SELECT
		@ObjectID, @TableID,
		@ColumnName, @ColumnAlias, @ColumnCaption, @ColumnType, @ColumnAlignment,
		700, 0, 0, 0, 0, 1, 1, 2, 1;

	RETURN 0;

END
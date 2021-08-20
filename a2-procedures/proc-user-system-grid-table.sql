CREATE OR ALTER PROCEDURE USER_System_Grid_Table
	@ObjectName varchar(50),
	@TableName varchar(100),
	@TableAlias varchar(50),
	@KeyColumn varchar(100),
	@KeyColumnForeign varchar(100),
	@KeyCustomRelation varchar(MAX) = NULL,
	@RelationType int = 1,
	@Priority int = 100
AS BEGIN

	IF EXISTS (
		SELECT T.ID	FROM MetaData_GridTables AS T
		INNER JOIN MetaData_Objects AS O ON O.ID = T.Object_ID
		WHERE T.TableName = @TableName AND O.ObjectName = @ObjectName
	) RETURN 0;

	DECLARE @ObjectID uniqueidentifier;
	
	SELECT @ObjectID = O.ID 
	FROM MetaData_Objects AS O (NOLOCK)
	WHERE O.ObjectName = @ObjectName;

	INSERT INTO MetaData_GridTables( 
		Object_ID, TableName, TableAlias,
		TableLocation, KeyColumn, KeyColumnForeign,
		RelationType, Priority, IsUser, IsGenerated,
		KeyCustomRelation, Module_ID)
	SELECT
		@ObjectID, @TableName, @TableAlias,
		1, @KeyColumn, @KeyColumnForeign,
		@RelationType, @Priority, 1, 1,
		@KeyCustomRelation, NULL;

	RETURN 0;

END
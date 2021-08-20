CREATE OR ALTER PROCEDURE USER_System_Filter 
	@ObjectName varchar(50),
	@FilterCaption varchar(100),
	@FilterGroupName varchar(100),
	@ObjectNameJoin varchar(50),
	@Condition varchar(max),
	@DataType int,
	@Position int = 0
AS BEGIN

	SET NOCOUNT ON;
	DELETE FROM MetaData_Filters WHERE ID IN (
		SELECT F.ID	FROM MetaData_Filters AS F
		INNER JOIN MetaData_Objects AS O ON O.ID = F.Object_ID
		WHERE F.FilterCaption = @FilterCaption AND O.ObjectName = @ObjectName
	);
	SET NOCOUNT OFF;

	DECLARE @ObjectID uniqueidentifier;
	DECLARE @FilterGroupID uniqueidentifier;
	
	SELECT @ObjectID = O.ID 
	FROM MetaData_Objects AS O (NOLOCK)
	WHERE O.ObjectName = @ObjectName;

	SELECT @FilterGroupID = G.ID 
	FROM MetaData_FilterGroups AS G (NOLOCK)
	INNER JOIN MetaData_Objects AS O (NOLOCK) ON O.ID = G.Object_ID
	WHERE O.ObjectName = @ObjectName AND G.GroupCaption = @FilterGroupName;

	INSERT INTO MetaData_Filters ( 
		Parent_ID, Object_ID, 
		Position, FilterCaption, DataType, ObjectName, Condition, 
		Enumerator_ID, IsUser, CommandTimeout, DateTimeMetaType, DateTimeType, IsGenerated, DecimalCount, Module_ID, Tag)
	SELECT
		@FilterGroupID, @ObjectID, 
		@Position, @FilterCaption, @DataType, @ObjectNameJoin, @Condition,
		NULL, 1, 30, 0, 0, 1, 2, NULL, 0;

	RETURN 0;

END
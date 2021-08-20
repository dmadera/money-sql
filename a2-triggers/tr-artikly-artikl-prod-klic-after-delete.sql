CREATE OR ALTER TRIGGER USER_Artikly_ArtiklProduktovyKlic_AfterDelete
ON Artikly_ArtiklProduktovyKlic
AFTER DELETE
AS
BEGIN
	IF SESSION_CONTEXT(N'USER_Artikly_ArtiklProduktovyKlic_AfterDelete') = 'disable'
		RETURN; 

	EXEC sp_set_session_context N'USER_Artikly_Artikl_AfterInsertUpdate', N'disable';

	-- aktualizuje PLU na zaklade PK
	UPDATE Artikly_Artikl SET
		PLU = ISNULL(P.Priznaky, '')
	FROM Artikly_Artikl A WITH(NOLOCK)
	INNER JOIN deleted ON deleted.Parent_ID = A.ID
	LEFT JOIN USER_ArtiklyPriznaky AS P ON P.Artikl_ID = A.ID;

	EXEC sp_set_session_context N'USER_Artikly_Artikl_AfterInsertUpdate', NULL;

	DECLARE @AkcniCenik_ID AS UNIQUEIDENTIFIER;
	SET @AkcniCenik_ID = (SELECT TOP 1 ID FROM Ceniky_Cenik AS Cenik WHERE Cenik.Kod = '_AKCE');

	EXEC sp_set_session_context N'USER_Ceniky_PolozkaCeniku_AfterDelete', N'disable';

	-- odebere Artikly bez PK 'A' nebo 'S' z akcniho ceniku 
	DELETE FROM Ceniky_PolozkaCeniku
	WHERE Cenik_ID = @AkcniCenik_ID AND Artikl_ID IN ( 
		SELECT 
			Apk.Parent_ID AS Artikl_ID
		FROM deleted Apk
		INNER JOIN Artikly_ProduktovyKlic P ON P.ID = Apk.ProduktovyKlic_ID
		WHERE P.Kod = 'A' OR P.Kod = 'S'
	);

	EXEC sp_set_session_context N'USER_Ceniky_PolozkaCeniku_AfterDelete', NULL;

END
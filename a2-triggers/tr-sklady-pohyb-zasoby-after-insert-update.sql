CREATE OR ALTER TRIGGER USER_Sklady_PohybZasoby_AfterInsertUpdate
ON Sklady_PohybZasoby
AFTER INSERT, UPDATE
AS
BEGIN

	IF SESSION_CONTEXT(N'USER_Sklady_PohybZasoby_AfterInsertUpdate') = 'disable'
		RETURN; 

	EXEC sp_set_session_context N'USER_Artikly_Artikl_AfterInsertUpdate', N'disable';

	UPDATE Artikly_Artikl SET
		StitekMnozstvi_UserData = S.ZustatekMnozstvi
	FROM Artikly_Artikl A
	INNER JOIN Sklady_Zasoba Z ON Z.Artikl_ID = A.ID
	INNER JOIN inserted P ON P.Konto_ID = Z.ID
	INNER JOIN Sklady_StavZasoby S ON S.ID = Z.AktualniStav_ID
	WHERE (P.Deleted = 0) AND (P.DruhPohybu = 1) AND (P.Znamenko = 0);
	
	EXEC sp_set_session_context N'USER_Artikly_Artikl_AfterInsertUpdate', NULL
END
CREATE OR ALTER TRIGGER USER_Artikly_ArtiklJednotka_AfterInsertUpdate
ON Artikly_ArtiklJednotka
AFTER INSERT, UPDATE
AS
BEGIN
	IF SESSION_CONTEXT(N'USER_Artikly_ArtiklJednotka_AfterInsertUpdate') = 'disable'
		RETURN; 

	UPDATE Artikly_ArtiklJednotka SET
		NedelitelneMnozstvi = 0
	FROM Artikly_ArtiklJednotka AS ArtJed
	INNER JOIN inserted ON inserted.ID = ArtJed.ID
	WHERE ArtJed.ParentJednotka_ID IS NOT NULL;

END
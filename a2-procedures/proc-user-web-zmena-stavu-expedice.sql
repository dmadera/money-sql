/**
	RETURN 1 - doklad neni aktivni k expedici nebo nebyl nalezen
	RETURN 2 - nelze zmenit stav dokladu
*/
CREATE OR ALTER PROCEDURE USER_WEB_ZmenaStavuExpedice
	@CisloDokladu varchar(50),
	@Datum DateTime,
	@NovyStavExpedice varchar(50) --'Expedovano', 'Pripraveno', 'Rozvoz'
AS BEGIN

	DECLARE @ID uniqueidentifier = NULL;
	DECLARE @TableName nvarchar(100) = 'SkladovyDoklad_';
	DECLARE @StavExpedice nvarchar(100) = NULL;

	SELECT 
		@ID = D.id, 
		@TableName += D.tableName, 
		@StavExpedice = D.shippingStatus
	FROM USER_WEB_AktivniExpedicniPrikazy D WHERE D.uid = @CisloDokladu;
	IF @ID = NULL BEGIN;
		RETURN 1;
	END;

	IF @NovyStavExpedice = 'Pripraveno' AND NOT EXISTS (SELECT 1 WHERE @StavExpedice IN ('')) RETURN 2;
	IF @NovyStavExpedice = 'Rozvoz' AND NOT EXISTS (SELECT 1 WHERE @StavExpedice IN ('', 'Pøipraveno')) RETURN 2;
	IF @NovyStavExpedice = 'Expedovano' AND NOT EXISTS (SELECT 1 WHERE @StavExpedice IN ('', 'Pøipraveno', 'Na rozvozu')) RETURN 2;

	DECLARE @Sql nvarchar(max), @ColumnName nvarchar(50) = @NovyStavExpedice + '_UserData', @AdditionalSet nvarchar(200) = '';    

	IF @TableName = 'SkladovyDoklad_DodaciListVydany' AND @NovyStavExpedice = 'Expedovano' SET @AdditionalSet = FORMATMESSAGE(', DatumSkladovehoPohybu=''%s''', CONVERT(VARCHAR(30), @Datum, 126));

    SET @Sql = FORMATMESSAGE('UPDATE %s SET %s=''%s''%s WHERE ID = ''%s''', @TableName, @ColumnName, CONVERT(VARCHAR(30), @Datum, 126), @AdditionalSet, CONVERT(nvarchar(200), @ID));
	
	DECLARE @Result INT = 0;

    Exec @Result = sp_executesql @Sql;
	
	RETURN @Result;

END
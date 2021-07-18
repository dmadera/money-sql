USE S4_System;

DECLARE @Name VARCHAR(100);
-- colors
DECLARE @Magenta INT = 16711935;
DECLARE @Red INT = -65536;
DECLARE @Bordo INT = -4194304;
DECLARE @Grey INT = -8355712;
DECLARE @Blue INT = -16748352;

SET @Name = 'Zasoba je objednana';
IF NOT EXISTS(SELECT TOP 1 ID FROM MetaData_GridColors WHERE Name = @Name)
	INSERT INTO MetaData_GridColors 
		(Object_ID, Name, IsUser, IsGenerated)
		SELECT TOP 1 Obj.ID, @Name, 1, 0
		FROM MetaData_Objects AS Obj
		WHERE Obj.ObjectName = 'Zasoba';

UPDATE MetaData_GridColors SET
	Condition = '([StavZobrazeniRadku_UserData] = 2)',
	Priority = 10,
	BackColor = -1, 
	FontColor = @Blue, 
	FontStyle = 0
WHERE Name = @Name;

SET @Name = 'Zasoba je pod minimem';
IF NOT EXISTS(SELECT TOP 1 ID FROM MetaData_GridColors WHERE Name = @Name)
	INSERT INTO MetaData_GridColors 
		(Object_ID, Name, IsUser, IsGenerated)
		SELECT TOP 1 Obj.ID, @Name, 1, 0
		FROM MetaData_Objects AS Obj
		WHERE Obj.ObjectName = 'Zasoba';

UPDATE MetaData_GridColors SET
	Condition = '([StavZobrazeniRadku_UserData] = 1)',
	Priority = 100,
	BackColor = -1, 
	FontColor = @Bordo, 
	FontStyle = 0
WHERE Name = @Name;

SET @Name = 'Polozka objednavky do minusu';
IF NOT EXISTS(SELECT TOP 1 ID FROM MetaData_GridColors WHERE Name = @Name)
	INSERT INTO MetaData_GridColors 
		(Object_ID, Name, IsUser, IsGenerated)
		SELECT TOP 1 Color.Object_ID, @Name, 1, 0
		FROM MetaData_GridColors AS Color
		WHERE Color.ID = 'D4D80FD4-24C7-4E43-8950-91B0DF20AC5E';

UPDATE MetaData_GridColors SET
	Condition = '([Zbyva] > [ZustatekMnozstvi] AND [PriznakVyrizeno] = 0)',
	Priority = 10,
	BackColor = -1, 
	FontColor = @Bordo, 
	FontStyle = 0
WHERE Name = @Name;	

SET @Name = 'Zvyseni marze';
IF NOT EXISTS(SELECT TOP 1 ID FROM MetaData_GridColors WHERE Name = @Name)
	INSERT INTO MetaData_GridColors 
		(Object_ID, Name, IsUser, IsGenerated)
		SELECT TOP 1 Obj.ID, @Name, 1, 0
		FROM MetaData_Objects AS Obj
		WHERE Obj.ObjectName = 'PolozkaCeniku';

UPDATE MetaData_GridColors SET
	Condition = '([BudouciCena] <> 0 AND [Marze_UserData] > [MarzeP_UserData])',
	Priority = 10,
	BackColor = -1, 
	FontColor = @Blue, 
	FontStyle = 0
	WHERE Name = @Name;

SET @Name = 'Pokles marze';
IF NOT EXISTS(SELECT TOP 1 ID FROM MetaData_GridColors WHERE Name = @Name)
	INSERT INTO MetaData_GridColors 
		(Object_ID, Name, IsUser, IsGenerated)
		SELECT TOP 1 Obj.ID, @Name, 1, 0
		FROM MetaData_Objects AS Obj
		WHERE Obj.ObjectName = 'PolozkaCeniku';

UPDATE MetaData_GridColors SET
	Condition = '([BudouciCena] <> 0 AND [Marze_UserData] < [MarzeP_UserData])',
	Priority = 10,
	BackColor = -1, 
	FontColor = @Bordo, 
	FontStyle = 0
	WHERE Name = @Name;


SET @Name = 'Neni na sklade';
IF NOT EXISTS(SELECT TOP 1 ID FROM MetaData_GridColors WHERE Name = @Name)
	INSERT INTO MetaData_GridColors 
		(Object_ID, Name, IsUser, IsGenerated)
		SELECT TOP 1 Obj.ID, @Name, 1, 0
		FROM MetaData_Objects AS Obj
		WHERE Obj.ObjectName = 'Artikl';

UPDATE MetaData_GridColors SET
	Condition = '([CelkoveMnozstviNaSkladech] <= 0)',
	Priority = 10,
	BackColor = -1, 
	FontColor = @Bordo, 
	FontStyle = 0
	WHERE Name = @Name;


SET @Name = 'Polozka DLV do minusu';
IF NOT EXISTS(SELECT TOP 1 ID FROM MetaData_GridColors WHERE Name = @Name)
	INSERT INTO MetaData_GridColors 
		(Object_ID, Name, IsUser, IsGenerated)
		SELECT TOP 1 Obj.ID, @Name, 1, 0
		FROM MetaData_Objects AS Obj
		WHERE Obj.ObjectName = 'PolozkaDodacihoListuVydaneho';
		
UPDATE MetaData_GridColors SET
	Condition = '([MnozstviPozn_UserData] = ''-'')',
	Priority = 10,
	BackColor = -1, 
	FontColor = @Bordo, 
	FontStyle = 0
WHERE Name = @Name;	

SET @Name = 'Polozka PV do minusu';
IF NOT EXISTS(SELECT TOP 1 ID FROM MetaData_GridColors WHERE Name = @Name)
	INSERT INTO MetaData_GridColors 
		(Object_ID, Name, IsUser, IsGenerated)
		SELECT TOP 1 Obj.ID, @Name, 1, 0
		FROM MetaData_Objects AS Obj
		WHERE Obj.ObjectName = 'PolozkaProdejkyVydane';
		
UPDATE MetaData_GridColors SET
	Condition = '([MnozstviPozn_UserData] = ''-'')',
	Priority = 10,
	BackColor = -1, 
	FontColor = @Bordo, 
	FontStyle = 0
WHERE Name = @Name;	

SET @Name = 'Firma povoleno na FA';
IF NOT EXISTS(SELECT TOP 1 ID FROM MetaData_GridColors WHERE Name = @Name)
	INSERT INTO MetaData_GridColors 
		(Object_ID, Name, IsUser, IsGenerated)
		SELECT O.ID, @Name, 1, 0 
		FROM MetaData_GridTables AS T 
		INNER JOIN MetaData_Objects AS O ON O.ID = T.Object_ID 
		WHERE T.TableName = 'Adresar_Firma' AND O.ObjectName = 'ObjednavkaPrijata';

UPDATE MetaData_GridColors SET
	Condition = '([KreditFA] LIKE ''FA%'' )',
	Priority = 10,
	BackColor = -1, 
	FontColor = @Blue, 
	FontStyle = 0
	WHERE Name = @Name;
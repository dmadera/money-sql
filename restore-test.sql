USE master;
GO

ALTER DATABASE S4_Agenda_PEMA_test SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

RESTORE FILELISTONLY
   FROM disk = '\\DBSERVER\Backup\S4_Agenda_PEMA.bak';
RESTORE DATABASE S4_Agenda_PEMA_test 
   FROM DISK = '\\DBSERVER\Backup\S4_Agenda_PEMA.bak'
   WITH REPLACE,
   MOVE 'S4_Agenda_PEMA' TO 'D:\MSSQL\MSSQL15.MSSQLSERVER\MSSQL\DATA\S4_Agenda_PEMA_test.mdf', 
   MOVE 'S4_Agenda_PEMA_log' TO 'D:\MSSQL\MSSQL15.MSSQLSERVER\MSSQL\DATA\S4_Agenda_PEMA_test_log.ldf', 
   stats = 5;

ALTER DATABASE S4_Agenda_PEMA_test SET MULTI_USER;
GO

USE S4_Agenda_PEMA_test;
UPDATE System_AgendaDetail SET
	AgnBackColorEnabled = 1,
	A1 = 255,
	R1 = 255, 
	G1 = 0, 
	B1 = 0
FROM System_AgendaDetail;
GO
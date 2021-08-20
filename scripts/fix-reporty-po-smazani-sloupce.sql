
UPDATE System_Reports SET
	DataSetQueries = REPLACE(DataSetQueries, 'RPDP_UserData, ', ' ')
where DataSetQueries like '%_UserData%';

UPDATE System_Reports SET
	DataSetQueries = REPLACE(DataSetQueries, 'RPDP_UserData ', ' ')
where DataSetQueries like '%_UserData%';


SELECT 
	Name,
	DatasetQueries
FROM System_Reports
WHERE DataSetQueries like '%_UserData%' and DataSetQueries like '%RPDP_UserData%';
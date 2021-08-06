-- Имена сервера и экземпляра
Select @@SERVERNAME as [Server\Instance];
-- версия SQL Server
Select @@VERSION as SQLServerVersion;
-- экземпляр SQL Server
Select @@ServiceName AS ServiceInstance;
-- Текущая БД (БД, в контексте которой
Select DB_NAME() AS CurrentDB_Name;

SELECT @@Servername AS ServerName ,
create_date AS ServerStarted ,
DATEDIFF(s, create_date, GETDATE()) / 86400 AS DaysRunning ,
DATEDIFF(s, create_date, GETDATE()) AS SecondsRunnig
FROM sys.databases
WHERE name = 'tempdb';
GO

EXEC sp_helpdb;
--OR
EXEC sp_Databases;
--OR
SELECT @@SERVERNAME AS Server ,
name AS DBName ,
recovery_model_Desc AS RecoveryModel ,
Compatibility_level AS CompatiblityLevel ,
create_date ,
state_desc
FROM sys.databases
ORDER BY Name;



-- В примере в WHERE U - таблицы
USE kontrolna_1;
GO
SELECT *
FROM sys.objects
WHERE type = 'U';




EXEC sp_Helpfile;
--OR
SELECT @@Servername AS Server ,
DB_NAME() AS DB_Name ,
File_id ,
Type_desc ,
Name ,
LEFT(Physical_Name, 1) AS Drive ,
Physical_Name ,
RIGHT(physical_name, 3) AS Ext ,
Size ,
Growth
FROM sys.database_files
ORDER BY File_id;
GO



SELECT @@Servername AS ServerName ,
TABLE_CATALOG ,
TABLE_SCHEMA ,
TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME ;


CREATE TABLE #rowcount
( Tablename VARCHAR(128) ,
Rowcnt INT );
EXEC sp_MSforeachtable ' insert into #rowcount select ''?'', count(*) from ?'
SELECT *
FROM #rowcount
ORDER BY Tablename ,
Rowcnt;
DROP TABLE #rowcount;


SELECT @@ServerName AS Server ,
DB_NAME() AS DBName ,
OBJECT_SCHEMA_NAME(p.object_id) AS SchemaName ,
OBJECT_NAME(p.object_id) AS TableName ,
i.Type_Desc ,
i.Name AS IndexUsedForCounts ,
SUM(p.Rows) AS Rows
FROM sys.partitions p
JOIN sys.indexes i ON i.object_id = p.object_id
AND i.index_id = p.index_id
WHERE i.type_desc IN ( 'CLUSTERED', 'HEAP' )
-- This is key (1 index per table)
AND OBJECT_SCHEMA_NAME(p.object_id) <> 'sys'
GROUP BY p.object_id ,
i.type_desc ,
i.Name
ORDER BY SchemaName ,
TableName;


SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
t.Name AS HeapTable ,
t.Create_Date
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
AND i.type_desc = 'HEAP'
ORDER BY t.Name


SELECT @@ServerName AS ServerName ,
DB_NAME() AS DBName ,
OBJECT_NAME(ddius.object_id) AS TableName ,
SUM(ddius.user_seeks + ddius.user_scans + ddius.user_lookups)
AS Reads ,
SUM(ddius.user_updates) AS Writes ,
SUM(ddius.user_seeks + ddius.user_scans + ddius.user_lookups
+ ddius.user_updates) AS [Reads&Writes] ,
( SELECT DATEDIFF(s, create_date, GETDATE()) / 86400
FROM master.sys.databases
WHERE name = 'tempdb'
) AS SampleDays ,
( SELECT DATEDIFF(s, create_date, GETDATE()) AS SecoundsRunnig
FROM master.sys.databases
WHERE name = 'tempdb'
) AS SampleSeconds
FROM sys.dm_db_index_usage_stats ddius
INNER JOIN sys.indexes i ON ddius.object_id = i.object_id
AND i.index_id = ddius.index_id
WHERE OBJECTPROPERTY(ddius.object_id, 'IsUserTable') = 1
AND ddius.database_id = DB_ID()
GROUP BY OBJECT_NAME(ddius.object_id)
ORDER BY [Reads&Writes] DESC;
GO

SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
o.name AS ViewName ,
o.[Type] ,
o.create_date
FROM sys.objects o
WHERE o.[Type] = 'V' -- View
ORDER BY o.NAME

SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
Name AS ViewName ,
create_date
FROM sys.Views
ORDER BY Name


SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
o.name AS StoredProcedureName ,
o.[Type] ,
o.create_date
FROM sys.objects o
WHERE o.[Type] = 'P' -- Stored Procedures
ORDER BY o.name


-- Функции
SELECT @@Servername AS ServerName ,
DB_NAME() AS DB_Name ,
o.name AS 'Functions' ,
o.[Type] ,
o.create_date
FROM sys.objects o
WHERE o.Type = 'FN' -- Function
ORDER BY o.NAME;

-- Триггеры
SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
parent.name AS TableName ,
o.name AS TriggerName ,
o.[Type] ,
o.create_date
FROM sys.objects o
INNER JOIN sys.objects parent ON o.parent_object_id = parent.object_id
WHERE o.Type = 'TR' -- Triggers
ORDER BY parent.name ,
o.NAME

-- Check Constraints
SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
parent.name AS 'TableName' ,
o.name AS 'Constraints' ,
o.[Type] ,
o.create_date
FROM sys.objects o
INNER JOIN sys.objects parent
ON o.parent_object_id = parent.object_id
WHERE o.Type = 'C' -- Check Constraints
ORDER BY parent.name ,
o.name




SELECT @@Servername AS Server ,
DB_NAME() AS DBName ,
isc.Table_Name AS TableName ,
isc.Table_Schema AS SchemaName ,
Ordinal_Position AS Ord ,
Column_Name ,
Data_Type ,
Numeric_Precision AS Prec ,
Numeric_Scale AS Scale ,
Character_Maximum_Length AS LEN , -- -1 means MAX like Varchar(MAX)
Is_Nullable ,
Column_Default ,
Table_Type
FROM INFORMATION_SCHEMA.COLUMNS isc
INNER JOIN information_schema.tables ist
ON isc.table_name = ist.table_name
-- WHERE Table_Type = 'BASE TABLE' -- 'Base Table' or 'View'
ORDER BY DBName ,
TableName ,
SchemaName ,
Ordinal_position;
-- Имена столбцов и количество повторов
-- Используется для поиска одноимённых столбцов с разными типами данных/длиной
SELECT @@Servername AS Server ,
DB_NAME() AS DBName ,
Column_Name ,
Data_Type ,
Numeric_Precision AS Prec ,
Numeric_Scale AS Scale ,
Character_Maximum_Length ,
COUNT(*) AS Count
FROM information_schema.columns isc
INNER JOIN information_schema.tables ist
ON isc.table_name = ist.table_name
WHERE Table_type = 'BASE TABLE'
GROUP BY Column_Name ,
Data_Type ,
Numeric_Precision ,
Numeric_Scale ,
Character_Maximum_Length;
-- Информация по используемым типам данных
SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
Data_Type ,
Numeric_Precision AS Prec ,
Numeric_Scale AS Scale ,
Character_Maximum_Length AS [Length] ,
COUNT(*) AS COUNT
FROM information_schema.columns isc
INNER JOIN information_schema.tables ist
ON isc.table_name = ist.table_name
WHERE Table_type = 'BASE TABLE'
GROUP BY Data_Type ,
Numeric_Precision ,
Numeric_Scale ,
Character_Maximum_Length
ORDER BY Data_Type ,
Numeric_Precision ,
Numeric_Scale ,
Character_Maximum_Length
-- Large object data types or Binary Large Objects(BLOBs)
-- Помните, что индексы по этим таблицам не могут быть перестроены в режиме "online"online"online"
SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
isc.Table_Name ,
Ordinal_Position AS Ord ,
Column_Name ,
Data_Type AS BLOB_Data_Type ,
Numeric_Precision AS Prec ,
Numeric_Scale AS Scale ,
Character_Maximum_Length AS [Length]
FROM information_schema.columns isc
INNER JOIN information_schema.tables ist
ON isc.table_name = ist.table_name
WHERE Table_type = 'BASE TABLE'
AND ( Data_Type IN ( 'text', 'ntext', 'image', 'XML' )
OR ( Data_Type IN ( 'varchar', 'nvarchar', 'varbinary' )
AND Character_Maximum_Length = -1
)
) -- varchar(max), nvarchar(max), varbinary(max)
ORDER BY isc.Table_Name ,
Ordinal_position;



-- Table Defaults
SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
parent.name AS TableName ,
o.name AS Defaults ,
o.[Type] ,
o.Create_date
FROM sys.objects o
INNER JOIN sys.objects parent
ON o.parent_object_id = parent.object_id
WHERE o.[Type] = 'D' -- Defaults
ORDER BY parent.name ,
o.NAME


-- Вычисляемые столбцы
SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
OBJECT_SCHEMA_NAME(object_id) AS SchemaName ,
OBJECT_NAME(object_id) AS Tablename ,
Column_id ,
Name AS Computed_Column ,
[Definition] ,
is_persisted
FROM sys.computed_columns
ORDER BY SchemaName ,
Tablename ,
[Definition];


SELECT @@Servername AS ServerName ,
DB_NAME() AS DBName ,
OBJECT_SCHEMA_NAME(object_id) AS SchemaName ,
OBJECT_NAME(object_id) AS TableName ,
Column_id ,
Name AS IdentityColumn ,
Seed_Value ,
Last_Value
FROM sys.identity_columns
ORDER BY SchemaName ,
TableName ,
Column_id;
GO



SELECT @@Servername AS ServerName ,
DB_NAME() AS DB_Name ,
o.Name AS TableName ,
i.Name AS IndexName
FROM sys.objects o
INNER JOIN sys.indexes i ON o.object_id = i.object_id
WHERE o.Type = 'U' -- User table
AND LEFT(i.Name, 1) <> '_' -- Remove hypothetical indexes
ORDER BY o.NAME ,
i.name;
GO


-- Foreign Keys
SELECT @@Servername AS ServerName ,
DB_NAME() AS DB_Name ,
parent.name AS 'TableName' ,
o.name AS 'ForeignKey' ,
o.[Type] ,
o.Create_date
FROM sys.objects o
INNER JOIN sys.objects parent ON o.parent_object_id = parent.object_id
WHERE o.[Type] = 'F' -- Foreign Keys
ORDER BY parent.name ,
o.name

--13.залежності
EXEC sp_msdependencies NULL

EXEC sp_msdependencies N'dogovoru',null, 1315327 

EXEC sp_MSdependencies N'dogovoru', null, 1053183 

CREATE TABLE #TempTable1
    (
      Type INT ,
      ObjName VARCHAR(256) ,
      Owner VARCHAR(25) ,
      Sequence INT
    ); 
INSERT  INTO #TempTable1
        EXEC sp_MSdependencies NULL 
SELECT  *
FROM     #TempTable1
WHERE   Type = 8 --Tables 
ORDER BY Sequence ,
        ObjName 
DROP TABLE #TempTable1;
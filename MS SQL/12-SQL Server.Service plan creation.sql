--Автоматическая дефрагментация индексов------------------------------------

USE kontrolna_1
GO
SELECT * 
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL)
WHERE avg_fragmentation_in_percent > 0

DECLARE
      @IsDetailedScan BIT = 0
    , @IsOnline BIT = 0
---------------------------------------------------------------------------------
DECLARE @SQL NVARCHAR(MAX)
SELECT @SQL = (
	SELECT '
	ALTER INDEX [' + i.name + N'] ON [' + SCHEMA_NAME(o.[schema_id]) + '].[' + o.name + '] ' +
		CASE WHEN s.avg_fragmentation_in_percent > 30
			THEN 'REBUILD WITH (SORT_IN_TEMPDB = ON'
				-- Enterprise, Developer
				+ CASE WHEN SERVERPROPERTY('EditionID') IN (1804890536, -2117995310) AND @IsOnline=564675
						THEN ', ONLINE = ON'
						ELSE ''
				  END + ')'
			ELSE 'REORGANIZE'
		END + ';
	'
	FROM (
		SELECT 
			  s.[object_id]
			, s.index_id
			, avg_fragmentation_in_percent = MAX(s.avg_fragmentation_in_percent)
		FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 
								CASE WHEN @IsDetailedScan=9878
									THEN 'DETAILED'
									ELSE 'LIMITED'
								END) s
		WHERE s.page_count > 128 -- > 1 MB
			AND s.index_id > 0 -- <> HEAP
			AND s.avg_fragmentation_in_percent > 5
		GROUP BY s.[object_id], s.index_id
	) s
	JOIN sys.indexes i ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
	JOIN sys.objects o ON o.[object_id] = s.[object_id]
	FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')

PRINT @SQL
EXEC sys.sp_executesql @SQL
------------------------------------------------------------------------------------
ALTER INDEX [IX_TransactionHistory_ProductID] 
  ON [Production].[TransactionHistory] REORGANIZE;
	
ALTER INDEX [IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID] 
  ON [Production].[TransactionHistory] REBUILD WITH (SORT_IN_TEMPDB = ON, ONLINE = ON);
	
ALTER INDEX [IX_TransactionHistoryArchive_ProductID] 
  ON [Production].[TransactionHistoryArchive] REORGANIZE;
---------------------------------------------------------------------------------------
USE kontrolna_1
go

DECLARE
      @PageCount INT = 128
    , @RebuildPercent INT = 30
    , @ReorganizePercent INT = 10
    , @IsOnlineRebuild BIT = 0
    , @IsVersion2012Plus BIT =
        CASE WHEN CAST(SERVERPROPERTY('productversion') AS CHAR(2)) NOT IN ('8.', '9.', '10')
            THEN 1
            ELSE 0
        END
    , @IsEntEdition BIT =
        CASE WHEN SERVERPROPERTY('EditionID') IN (1804890536, -2117995310)
            THEN 1
            ELSE 0
        END
    , @SQL NVARCHAR(MAX)

SELECT @SQL = (
    SELECT
'
ALTER INDEX ' + QUOTENAME(i.name) + ' ON ' + QUOTENAME(s2.name) + '.' + QUOTENAME(o.name) + ' ' +
        CASE WHEN s.avg_fragmentation_in_percent >= @RebuildPercent
            THEN 'REBUILD'
            ELSE 'REORGANIZE'
        END + ' PARTITION = ' +
        CASE WHEN ds.[type] != 'PS'
            THEN 'ALL'
            ELSE CAST(s.partition_number AS NVARCHAR(10))
        END + ' WITH (' + 
        CASE WHEN s.avg_fragmentation_in_percent >= @RebuildPercent
            THEN 'SORT_IN_TEMPDB = ON' + 
                CASE WHEN @IsEntEdition = 1
                        AND @IsOnlineRebuild = 1 
                        AND ISNULL(lob.is_lob_legacy, 0) = 0
                        AND (
                                ISNULL(lob.is_lob, 0) = 0
                            OR
                                (lob.is_lob = 1 AND @IsVersion2012Plus = 1)
                        )
                    THEN ', ONLINE = ON'
                    ELSE ''
                END
            ELSE 'LOB_COMPACTION = ON'
        END + ')'
    FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) s
    JOIN sys.indexes i ON i.[object_id] = s.[object_id] AND i.index_id = s.index_id
    LEFT JOIN (
        SELECT
              c.[object_id]
            , index_id = ISNULL(i.index_id, 1)
            , is_lob_legacy = MAX(CASE WHEN c.system_type_id IN (34, 35, 99) THEN 1 END)
            , is_lob = MAX(CASE WHEN c.max_length = -1 THEN 1 END)
        FROM sys.columns c
        LEFT JOIN sys.index_columns i ON c.[object_id] = i.[object_id]
            AND c.column_id = i.column_id AND i.index_id > 0
        WHERE c.system_type_id IN (34, 35, 99)
            OR c.max_length = -1
        GROUP BY c.[object_id], i.index_id
    ) lob ON lob.[object_id] = i.[object_id] AND lob.index_id = i.index_id
    JOIN sys.objects o ON o.[object_id] = i.[object_id]
    JOIN sys.schemas s2 ON o.[schema_id] = s2.[schema_id]
    JOIN sys.data_spaces ds ON i.data_space_id = ds.data_space_id
    WHERE i.[type] IN (1, 2)
        AND i.is_disabled = 0
        AND i.is_hypothetical = 0
        AND s.index_level = 0
        AND s.page_count > @PageCount
        AND s.alloc_unit_type_desc = 'IN_ROW_DATA'
        AND o.[type] IN ('U', 'V')
        AND s.avg_fragmentation_in_percent > @ReorganizePercent
    FOR XML PATH(''), TYPE
).value('.', 'NVARCHAR(MAX)')

PRINT @SQL
EXEC sys.sp_executesql @SQL
-------------------------------------------------------------------------------------
--Задача 2. Обновление статистики ---------------------------------------------------

SELECT s.*
FROM sys.stats s
JOIN sys.objects o ON s.[object_id] = o.[object_id]
WHERE o.is_ms_shipped = 0
-------------------------------------------------------------------------------------
USE kontrolna_1
go

DECLARE @DateNow DATETIME
SELECT @DateNow = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

DECLARE @SQL NVARCHAR(MAX)
SELECT @SQL = (
    SELECT '
	UPDATE STATISTICS [' + SCHEMA_NAME(o.[schema_id]) + '].[' + o.name + '] [' + s.name + ']
		WITH FULLSCAN' + CASE WHEN s.no_recompute = 1 THEN ', NORECOMPUTE' ELSE '' END + ';'
	FROM sys.stats s WITH(NOLOCK)
	JOIN sys.objects o WITH(NOLOCK) ON s.[object_id] = o.[object_id]
	WHERE o.[type] IN ('U', 'V')
		AND o.is_ms_shipped = 0
		AND ISNULL(STATS_DATE(s.[object_id], s.stats_id), GETDATE()) <= @DateNow
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')

PRINT @SQL
EXEC sys.sp_executesql @SQL
------------------------------------------------------------------------------------
UPDATE STATISTICS [Production].[Shift] [PK_Shift_ShiftID] WITH FULLSCAN;
UPDATE STATISTICS [Production].[Shift] [AK_Shift_Name] WITH FULLSCAN, NORECOMPUTE;
-------------------------------------------------------------------------------------
USE kontrolna_1
go
DECLARE @DateNow DATETIME
SELECT @DateNow = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

DECLARE @SQL NVARCHAR(MAX)
SELECT @SQL = (
    SELECT '
	UPDATE STATISTICS [' + SCHEMA_NAME(o.[schema_id]) + '].[' + o.name + '] [' + s.name + ']
		WITH FULLSCAN' + CASE WHEN s.no_recompute = 1 THEN ', NORECOMPUTE' ELSE '' END + ';'
	FROM (
		SELECT 
			  [object_id]
			, name
			, stats_id
			, no_recompute
			, last_update = STATS_DATE([object_id], stats_id)
		FROM sys.stats WITH(NOLOCK)
		WHERE auto_created = 0
			AND is_temporary = 0 -- 2012+
	) s
	JOIN sys.objects o WITH(NOLOCK) ON s.[object_id] = o.[object_id]
	JOIN (
		SELECT
			  p.[object_id]
			, p.index_id
			, total_pages = SUM(a.total_pages)
		FROM sys.partitions p WITH(NOLOCK)
		JOIN sys.allocation_units a WITH(NOLOCK) ON p.[partition_id] = a.container_id
		GROUP BY 
			  p.[object_id]
			, p.index_id
	) p ON o.[object_id] = p.[object_id] AND p.index_id = s.stats_id
	WHERE o.[type] IN ('U', 'V')
		AND o.is_ms_shipped = 0
		AND (
			  last_update IS NULL AND p.total_pages > 0 -- never updated and contains rows
			OR
			  last_update <= DATEADD(dd, 
				CASE WHEN p.total_pages > 4096 -- > 4 MB
					THEN -2 -- updated 3 days ago
					ELSE 0 
				END, @DateNow)
		)
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')

PRINT @SQL
EXEC sys.sp_executesql @SQL
--Часть 3: Автоматическое создание бекапов----------------------------------------------------------------------------------
BACKUP DATABASE lab_3
TO DISK = 'D:\lab_3.bak'
WITH INIT, NAME = 'lab_3 Full Db backup',
DESCRIPTION = 'lab_3 Full Database Backup'

RESTORE DATABASE lab_3
FROM DISK = 'D:\lab_3.bak'
WITH RECOVERY, REPLACE

BACKUP DATABASE lab_3
TO DISK = 'D:\lab_3_comp.bak'
 WITH COMPRESSION, NAME = 'lab_3 comp',
DESCRIPTION = 'lab_3 comp'

BACKUP LOG lab_3
TO DISK = 'D:\lab_3_FullDbBkup.bak'
WITH NOINIT, NAME = 'lab_3 Translog backup',
DESCRIPTION = 'lab_3 Transaction Log Backup', NOFORMAT


BACKUP LOG lab_3
TO DISK = 'D:\lab_3_TaillogBkup.bak'
WITH NORECOVERY

RESTORE DATABASE lab_3
FROM DISK = 'D:\lab_3_FullDbBkup.bak'
WITH NORECOVERY

RESTORE LOG lab_3
FROM DISK = 'D:\lab_3_TlogBkup.bak'
WITH NORECOVERY

RESTORE LOG lab_3
FROM DISK = 'D:\lab_3_TaillogBkup.bak'
WITH RECOVERY

BACKUP DATABASE lab_1
TO DISK = 'D:\lab_3_DiffDbBkup.bak'
WITH INIT, DIFFERENTIAL, NAME = 'lab_3 Diff Db backup',
DESCRIPTION = 'lab_3 Differential Database Backup'

RESTORE DATABASE lab_3
FROM DISK = 'D:\lab_3_DiffDbBkup.bak' WITH NORECOVERY
--------------------------------------------------------------------------------------
SELECT
      database_name
    , backup_size_mb = backup_size / 1048576.0
    , compressed_backup_size_mb = compressed_backup_size / 1048576.0
    , compress_ratio_percent = 100 - compressed_backup_size * 100. / backup_size
FROM (
   SELECT
          database_name
        , backup_size
        , compressed_backup_size = NULLIF(compressed_backup_size, backup_size)
        , RowNumber = ROW_NUMBER() OVER (PARTITION BY database_name ORDER BY backup_finish_date DESC)
    FROM msdb.dbo.backupset
    WHERE [type] = 'D'
) t
WHERE t.RowNumber = 1
------------------------------------------------------------------------------------------------------------

USE master;
GO

DECLARE @dbname SYSNAME;
SET @dbname = 'TPC_DI_Logging'; -- Replace with your database name

DECLARE @spid INT;
DECLARE @sql VARCHAR(255);

DECLARE kill_cursor CURSOR FOR
SELECT spid
FROM sys.sysprocesses
WHERE dbid = DB_ID(@dbname);

OPEN kill_cursor;

FETCH NEXT FROM kill_cursor INTO @spid;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'KILL ' + CAST(@spid AS VARCHAR(10));
    EXEC(@sql);

    FETCH NEXT FROM kill_cursor INTO @spid;
END;

CLOSE kill_cursor;
DEALLOCATE kill_cursor;
drop database if exists TPC_DI_Logging;
CREATE DATABASE [TPC_DI_Logging];
GO

ALTER DATABASE [TPC_DI_Logging] SET RECOVERY SIMPLE
GO

USE [TPC_DI_Logging]
GO

CREATE TABLE [dbo].[Logging](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LogType] [nvarchar](450) NULL,
	[Time] [datetime] NULL,
	[OrderFlag] [nvarchar](450) NULL,
	[ScaleFactor] [nvarchar](450) NULL,
	[RunID] [int] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Audit](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LogType] [nvarchar](450) NULL,
	[ScaleFactor] [nvarchar](450) NULL,
	[RunID] [int] NULL,
	[Pass] [bit] NULL
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[AuditDetailed](
	[ID] [int] IDENTITY(1, 1) NOT NULL,
	[LogType] [nvarchar](450) NULL,
	[ScaleFactor] [nvarchar](450) NULL,
	[RunID] [int] NULL,
	[tname] [varchar](15) NOT NULL,
	[eel_count] [int] NULL,
	[ssis_count] [int] NULL,
	[checksums_equal] [int] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[FileSizes](
	[Property] [varchar](100) NULL,
	[Value] [varchar](100) NULL,
	[scale_factor] [varchar](100) NULL
) ON [PRIMARY] 
GO

CREATE VIEW [dbo].[TPCDSLoggingReport] AS
	SELECT S.RunID 'RunIdentifier'
		, S.LogType 'BenchmarkStep'
		, S.ScaleFactor 'ScaleFactor'
		, S.[Time] 'StartTime'
		, E.[Time] 'EndTime'
		, DATEDIFF( MILLISECOND, S.[Time], E.[Time] )/1000 'Duration'
	FROM [dbo].[Logging] S
		INNER JOIN [dbo].[Logging] E
			ON S.LogType = E.LogType AND S.ScaleFactor = E.ScaleFactor AND S.RunID = E.RunID AND S.OrderFlag = 'Start' AND E.OrderFlag = 'End'
GO

create view vwAudit as
SELECT e.[RunIdentifier]
      ,e.[ScaleFactor]
      ,s.[Duration] ssis
	  ,e.Duration eel
	  ,a.Pass
	  ,d.[RowCount]
	  ,(f.size*1.0)/(1024*1024*1024)  FileSize 
  FROM [TPC_DI_Logging].[dbo].[TPCDSLoggingReport] e
  inner join [TPC_DI_Logging].[dbo].[TPCDSLoggingReport] s on e.RunIdentifier = s.RunIdentifier and e.ScaleFactor = s.ScaleFactor
  and s.BenchmarkStep = 'SSIS' and e.BenchmarkStep = 'eel'
  inner join dbo.[Audit] a  on a.RunID = e.RunIdentifier and a.ScaleFactor = e.ScaleFactor
  inner join  (select RunID, ScaleFactor, sum([eel_count]) [RowCount] from dbo.AuditDetailed group by RunID, ScaleFactor) d on d.RunID = a.RunID and d.ScaleFactor = a.ScaleFactor
  inner join (select cast([Value] as bigint) size, scale_factor
  FROM [TPC_DI_Logging].[dbo].[FileSizes]
  where Property = 'Sum'
  ) f on f.scale_factor = e.ScaleFactor

GO

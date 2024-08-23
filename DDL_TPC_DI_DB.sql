USE master;
GO

DECLARE @dbname SYSNAME;
SET @dbname = 'TPC_DI_DB'; -- Replace with your database name

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


DROP DATABASE IF EXISTS TPC_DI_DB;
GO

CREATE DATABASE TPC_DI_DB;
GO

ALTER DATABASE [TPC_DI_DB] SET RECOVERY SIMPLE
GO

USE [TPC_DI_DB]
GO
CREATE SCHEMA [Source]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[BatchDate](
	[BatchDate] [date] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[CashTransaction](
	[CT_CA_ID] [numeric](11, 0) NULL,
	[CT_DTS] [datetime] NULL,
	[CT_AMT] [numeric](10, 2) NULL,
	[CT_NAME] [varchar](100) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[CustomerMgmt](
	[ActionType] [nvarchar](255) NULL,
	[ActionTS] [nvarchar](255) NULL,
	[C_ID] [int] NULL,
	[C_TAX_ID] [nvarchar](255) NULL,
	[C_GNDR] [nvarchar](255) NULL,
	[C_TIER] [nvarchar](255) NULL,
	[C_DOB] [nvarchar](255) NULL,
	[C_L_NAME] [nvarchar](255) NULL,
	[C_F_NAME] [nvarchar](255) NULL,
	[C_M_NAME] [nvarchar](255) NULL,
	[C_ADLINE1] [nvarchar](255) NULL,
	[C_ADLINE2] [nvarchar](255) NULL,
	[C_ZIPCODE] [nvarchar](255) NULL,
	[C_CITY] [nvarchar](255) NULL,
	[C_STATE_PROV] [nvarchar](255) NULL,
	[C_CTRY] [nvarchar](255) NULL,
	[C_PRIM_EMAIL] [nvarchar](255) NULL,
	[C_ALT_EMAIL] [nvarchar](255) NULL,
	[C_PHONE_1_CTRY_CODE] [nvarchar](255) NULL,
	[C_PHONE_1_AREA_CODE] [nvarchar](255) NULL,
	[C_PHONE_1_LOCAL] [nvarchar](255) NULL,
	[C_PHONE_1_EXT] [nvarchar](255) NULL,
	[C_PHONE_2_CTRY_CODE] [nvarchar](255) NULL,
	[C_PHONE_2_AREA_CODE] [nvarchar](255) NULL,
	[C_PHONE_2_LOCAL] [nvarchar](255) NULL,
	[C_PHONE_2_EXT] [nvarchar](255) NULL,
	[C_PHONE_3_CTRY_CODE] [nvarchar](255) NULL,
	[C_PHONE_3_AREA_CODE] [nvarchar](255) NULL,
	[C_PHONE_3_LOCAL] [nvarchar](255) NULL,
	[C_PHONE_3_EXT] [nvarchar](255) NULL,
	[C_LCL_TX_ID] [nvarchar](255) NULL,
	[C_NAT_TX_ID] [nvarchar](255) NULL,
	[CA_ID] [int] NULL,
	[CA_TAX_ST] [nvarchar](255) NULL,
	[CA_B_ID] [nvarchar](255) NULL,
	[CA_NAME] [nvarchar](255) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[DailyMarket](
	[DM_DATE] [date] NULL,
	[DM_S_SYMB] [varchar](15) NULL,
	[DM_CLOSE] [numeric](8, 2) NULL,
	[DM_HIGH] [numeric](8, 2) NULL,
	[DM_LOW] [numeric](8, 2) NULL,
	[DM_VOL] [numeric](12, 0) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[Date](
	[SK_DateID] [numeric](11, 0) NULL,
	[DateValue] [varchar](20) NULL,
	[DateDesc] [varchar](20) NULL,
	[CalendarYearID] [numeric](4, 0) NULL,
	[CalendarYearDesc] [varchar](20) NULL,
	[CalendarQtrID] [numeric](5, 0) NULL,
	[CalendarQtrDesc] [varchar](20) NULL,
	[CalendarMonthID] [numeric](6, 0) NULL,
	[CalendarMonthDesc] [varchar](20) NULL,
	[CalendarWeekID] [numeric](6, 0) NULL,
	[CalendarWeekDesc] [varchar](20) NULL,
	[DayOfWeekNum] [numeric](1, 0) NULL,
	[DayOfWeekDesc] [varchar](10) NULL,
	[FiscalYearID] [numeric](4, 0) NULL,
	[FiscalYearDesc] [varchar](20) NULL,
	[FiscalQtrID] [numeric](5, 0) NULL,
	[FiscalQtrDesc] [varchar](20) NULL,
	[HolidayFlag] [nvarchar](5) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[Finwire](
	[Record] [nvarchar](999) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[HoldingHistory](
	[HH_H_T_ID] [numeric](15, 0) NULL,
	[HH_T_ID] [numeric](15, 0) NULL,
	[HH_BEFORE_QTY] [numeric](6, 0) NULL,
	[HH_AFTER_QTY] [numeric](6, 0) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[HR](
	[EmployeeID] [numeric](11, 0) NULL,
	[ManagerID] [numeric](11, 0) NULL,
	[EmployeeFirstName] [varchar](30) NULL,
	[EmployeeLastName] [varchar](30) NULL,
	[EmployeeMI] [varchar](1) NULL,
	[EmployeeJobCode] [numeric](3, 0) NULL,
	[EmployeeBranch] [varchar](30) NULL,
	[EmployeeOffice] [varchar](10) NULL,
	[EmployeePhone] [varchar](14) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[Industry](
	[IN_ID] [varchar](2) NULL,
	[IN_NAME] [varchar](50) NULL,
	[IN_SC_ID] [varchar](4) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[Prospect](
	[AgencyID] [varchar](30) NULL,
	[LastName] [varchar](30) NULL,
	[FirstName] [varchar](30) NULL,
	[MiddleInitial] [varchar](1) NULL,
	[Gender] [varchar](1) NULL,
	[AddressLine1] [varchar](80) NULL,
	[AddressLine2] [varchar](80) NULL,
	[PostalCode] [varchar](12) NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](20) NULL,
	[Country] [varchar](24) NULL,
	[Phone] [varchar](30) NULL,
	[Income] [numeric](9, 0) NULL,
	[NumberCars] [numeric](2, 0) NULL,
	[NumberChildren] [numeric](2, 0) NULL,
	[MaritalStatus] [varchar](1) NULL,
	[Age] [numeric](3, 0) NULL,
	[CreditRating] [numeric](4, 0) NULL,
	[OwnOrRentFlag] [varchar](1) NULL,
	[Employer] [varchar](30) NULL,
	[NumberCreditCards] [numeric](2, 0) NULL,
	[NetWorth] [numeric](12, 0) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[StatusType](
	[ST_ID] [varchar](4) NULL,
	[ST_NAME] [varchar](10) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[TaxRate](
	[TX_ID] [varchar](4) NULL,
	[TX_NAME] [varchar](50) NULL,
	[TX_RATE] [numeric](6, 5) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[Time](
	[SK_TimeID] [numeric](11, 0) NULL,
	[TimeValue] [varchar](20) NULL,
	[HourID] [numeric](2, 0) NULL,
	[HourDesc] [varchar](20) NULL,
	[MinuteID] [numeric](2, 0) NULL,
	[MinuteDesc] [varchar](20) NULL,
	[SecondID] [numeric](2, 0) NULL,
	[SecondDesc] [varchar](20) NULL,
	[MarketHoursFlag] [nvarchar](5) NULL,
	[OfficeHoursFlag] [nvarchar](5) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[TradeHistory](
	[TH_T_ID] [numeric](15, 0) NULL,
	[TH_DTS] [datetime] NULL,
	[TH_ST_ID] [varchar](4) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[Trade](
	[T_ID] [numeric](15, 0) NULL,
	[T_DTS] [datetime] NULL,
	[T_ST_ID] [varchar](4) NULL,
	[T_TT_ID] [varchar](3) NULL,
	[T_IS_CASH] [nvarchar](5) NULL,
	[T_S_SYMB] [varchar](15) NULL,
	[T_QTY] [numeric](6, 0) NULL,
	[T_BID_PRICE] [numeric](8, 2) NULL,
	[T_CA_ID] [numeric](11, 0) NULL,
	[T_EXEC_NAME] [varchar](49) NULL,
	[T_TRADE_PRICE] [numeric](8, 2) NULL,
	[T_CHRG] [numeric](10, 2) NULL,
	[T_COMM] [numeric](10, 2) NULL,
	[T_TAX] [numeric](10, 2) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[TradeType](
	[TT_ID] [varchar](3) NULL,
	[TT_NAME] [varchar](12) NULL,
	[TT_IS_SELL] [numeric](1, 0) NULL,
	[TT_IS_MRKT] [numeric](1, 0) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Source].[WatchHistory](
	[W_C_ID] [numeric](11, 0) NULL,
	[W_S_SYMB] [varchar](15) NULL,
	[W_DTS] [datetime] NULL,
	[W_ACTION] [varchar](4) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchDate](
	[BatchDate] [date] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CashTransaction](
	[CT_CA_ID] [numeric](11, 0) NULL,
	[CT_DTS] [datetime] NULL,
	[CT_AMT] [numeric](10, 2) NULL,
	[CT_NAME] [varchar](100) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerMgmt](
	[ActionType] [nvarchar](255) NULL,
	[ActionTS] [nvarchar](255) NULL,
	[C_ID] [int] NULL,
	[C_TAX_ID] [nvarchar](255) NULL,
	[C_GNDR] [nvarchar](255) NULL,
	[C_TIER] [nvarchar](255) NULL,
	[C_DOB] [nvarchar](255) NULL,
	[C_L_NAME] [nvarchar](255) NULL,
	[C_F_NAME] [nvarchar](255) NULL,
	[C_M_NAME] [nvarchar](255) NULL,
	[C_ADLINE1] [nvarchar](255) NULL,
	[C_ADLINE2] [nvarchar](255) NULL,
	[C_ZIPCODE] [nvarchar](255) NULL,
	[C_CITY] [nvarchar](255) NULL,
	[C_STATE_PROV] [nvarchar](255) NULL,
	[C_CTRY] [nvarchar](255) NULL,
	[C_PRIM_EMAIL] [nvarchar](255) NULL,
	[C_ALT_EMAIL] [nvarchar](255) NULL,
	[C_PHONE_1_CTRY_CODE] [nvarchar](255) NULL,
	[C_PHONE_1_AREA_CODE] [nvarchar](255) NULL,
	[C_PHONE_1_LOCAL] [nvarchar](255) NULL,
	[C_PHONE_1_EXT] [nvarchar](255) NULL,
	[C_PHONE_2_CTRY_CODE] [nvarchar](255) NULL,
	[C_PHONE_2_AREA_CODE] [nvarchar](255) NULL,
	[C_PHONE_2_LOCAL] [nvarchar](255) NULL,
	[C_PHONE_2_EXT] [nvarchar](255) NULL,
	[C_PHONE_3_CTRY_CODE] [nvarchar](255) NULL,
	[C_PHONE_3_AREA_CODE] [nvarchar](255) NULL,
	[C_PHONE_3_LOCAL] [nvarchar](255) NULL,
	[C_PHONE_3_EXT] [nvarchar](255) NULL,
	[C_LCL_TX_ID] [nvarchar](255) NULL,
	[C_NAT_TX_ID] [nvarchar](255) NULL,
	[CA_ID] [int] NULL,
	[CA_TAX_ST] [nvarchar](255) NULL,
	[CA_B_ID] [nvarchar](255) NULL,
	[CA_NAME] [nvarchar](255) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyMarket](
	[DM_DATE] [date] NULL,
	[DM_S_SYMB] [varchar](15) NULL,
	[DM_CLOSE] [numeric](8, 2) NULL,
	[DM_HIGH] [numeric](8, 2) NULL,
	[DM_LOW] [numeric](8, 2) NULL,
	[DM_VOL] [numeric](12, 0) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Date](
	[SK_DateID] [numeric](11, 0) NULL,
	[DateValue] [varchar](20) NULL,
	[DateDesc] [varchar](20) NULL,
	[CalendarYearID] [numeric](4, 0) NULL,
	[CalendarYearDesc] [varchar](20) NULL,
	[CalendarQtrID] [numeric](5, 0) NULL,
	[CalendarQtrDesc] [varchar](20) NULL,
	[CalendarMonthID] [numeric](6, 0) NULL,
	[CalendarMonthDesc] [varchar](20) NULL,
	[CalendarWeekID] [numeric](6, 0) NULL,
	[CalendarWeekDesc] [varchar](20) NULL,
	[DayOfWeekNum] [numeric](1, 0) NULL,
	[DayOfWeekDesc] [varchar](10) NULL,
	[FiscalYearID] [numeric](4, 0) NULL,
	[FiscalYearDesc] [varchar](20) NULL,
	[FiscalQtrID] [numeric](5, 0) NULL,
	[FiscalQtrDesc] [varchar](20) NULL,
	[HolidayFlag] [nvarchar](5) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Finwire](
	[Record] [nvarchar](999) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoldingHistory](
	[HH_H_T_ID] [numeric](15, 0) NULL,
	[HH_T_ID] [numeric](15, 0) NULL,
	[HH_BEFORE_QTY] [numeric](6, 0) NULL,
	[HH_AFTER_QTY] [numeric](6, 0) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR](
	[EmployeeID] [numeric](11, 0) NULL,
	[ManagerID] [numeric](11, 0) NULL,
	[EmployeeFirstName] [varchar](30) NULL,
	[EmployeeLastName] [varchar](30) NULL,
	[EmployeeMI] [varchar](1) NULL,
	[EmployeeJobCode] [numeric](3, 0) NULL,
	[EmployeeBranch] [varchar](30) NULL,
	[EmployeeOffice] [varchar](10) NULL,
	[EmployeePhone] [varchar](14) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Industry](
	[IN_ID] [varchar](2) NULL,
	[IN_NAME] [varchar](50) NULL,
	[IN_SC_ID] [varchar](4) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prospect](
	[AgencyID] [varchar](30) NULL,
	[LastName] [varchar](30) NULL,
	[FirstName] [varchar](30) NULL,
	[MiddleInitial] [varchar](1) NULL,
	[Gender] [varchar](1) NULL,
	[AddressLine1] [varchar](80) NULL,
	[AddressLine2] [varchar](80) NULL,
	[PostalCode] [varchar](12) NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](20) NULL,
	[Country] [varchar](24) NULL,
	[Phone] [varchar](30) NULL,
	[Income] [numeric](9, 0) NULL,
	[NumberCars] [numeric](2, 0) NULL,
	[NumberChildren] [numeric](2, 0) NULL,
	[MaritalStatus] [varchar](1) NULL,
	[Age] [numeric](3, 0) NULL,
	[CreditRating] [numeric](4, 0) NULL,
	[OwnOrRentFlag] [varchar](1) NULL,
	[Employer] [varchar](30) NULL,
	[NumberCreditCards] [numeric](2, 0) NULL,
	[NetWorth] [numeric](12, 0) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StatusType](
	[ST_ID] [varchar](4) NULL,
	[ST_NAME] [varchar](10) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxRate](
	[TX_ID] [varchar](4) NULL,
	[TX_NAME] [varchar](50) NULL,
	[TX_RATE] [numeric](6, 5) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Time](
	[SK_TimeID] [numeric](11, 0) NULL,
	[TimeValue] [varchar](20) NULL,
	[HourID] [numeric](2, 0) NULL,
	[HourDesc] [varchar](20) NULL,
	[MinuteID] [numeric](2, 0) NULL,
	[MinuteDesc] [varchar](20) NULL,
	[SecondID] [numeric](2, 0) NULL,
	[SecondDesc] [varchar](20) NULL,
	[MarketHoursFlag] [nvarchar](5) NULL,
	[OfficeHoursFlag] [nvarchar](5) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TradeHistory](
	[TH_T_ID] [numeric](15, 0) NULL,
	[TH_DTS] [datetime] NULL,
	[TH_ST_ID] [varchar](4) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trade](
	[T_ID] [numeric](15, 0) NULL,
	[T_DTS] [datetime] NULL,
	[T_ST_ID] [varchar](4) NULL,
	[T_TT_ID] [varchar](3) NULL,
	[T_IS_CASH] [nvarchar](5) NULL,
	[T_S_SYMB] [varchar](15) NULL,
	[T_QTY] [numeric](6, 0) NULL,
	[T_BID_PRICE] [numeric](8, 2) NULL,
	[T_CA_ID] [numeric](11, 0) NULL,
	[T_EXEC_NAME] [varchar](49) NULL,
	[T_TRADE_PRICE] [numeric](8, 2) NULL,
	[T_CHRG] [numeric](10, 2) NULL,
	[T_COMM] [numeric](10, 2) NULL,
	[T_TAX] [numeric](10, 2) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TradeType](
	[TT_ID] [varchar](3) NULL,
	[TT_NAME] [varchar](12) NULL,
	[TT_IS_SELL] [numeric](1, 0) NULL,
	[TT_IS_MRKT] [numeric](1, 0) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WatchHistory](
	[W_C_ID] [numeric](11, 0) NULL,
	[W_S_SYMB] [varchar](15) NULL,
	[W_DTS] [datetime] NULL,
	[W_ACTION] [varchar](4) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create view [dbo].[vwAudit] as

select e.tname, eel_count, ssis_count, checksums_equal from 

(select 'BatchDate' tname, count(*) eel_count from dbo.BatchDate
union select 'CashTransaction', count(*) from dbo.CashTransaction
union select 'CustomerMgmt', count(*) from dbo.CustomerMgmt
union select 'DailyMarket', count(*) from dbo.DailyMarket
union select 'Date', count(*) from dbo.Date
union select 'Finwire', count(*) from dbo.Finwire
union select 'HoldingHistory', count(*) from dbo.HoldingHistory
union select 'HR', count(*) from dbo.HR
union select 'Industry', count(*) from dbo.Industry
union select 'Prospect', count(*) from dbo.Prospect
union select 'StatusType', count(*) from dbo.StatusType
union select 'TaxRate', count(*) from dbo.TaxRate
union select 'Time', count(*) from dbo.Time
union select 'TradeHistory', count(*) from dbo.TradeHistory
union select 'Trade', count(*) from dbo.Trade
union select 'TradeType', count(*) from dbo.TradeType
union select 'WatchHistory', count(*) from dbo.WatchHistory) e
inner join 
(select 'BatchDate' tname, count(*) ssis_count from Source.BatchDate
union select 'CashTransaction', count(*) from Source.CashTransaction
union select 'CustomerMgmt', count(*) from Source.CustomerMgmt
union select 'DailyMarket', count(*) from Source.DailyMarket
union select 'Date', count(*) from Source.Date
union select 'Finwire', count(*) from Source.Finwire
union select 'HoldingHistory', count(*) from Source.HoldingHistory
union select 'HR', count(*) from Source.HR
union select 'Industry', count(*) from Source.Industry
union select 'Prospect', count(*) from Source.Prospect
union select 'StatusType', count(*) from Source.StatusType
union select 'TaxRate', count(*) from Source.TaxRate
union select 'Time', count(*) from Source.Time
union select 'TradeHistory', count(*) from Source.TradeHistory
union select 'Trade', count(*) from Source.Trade
union select 'TradeType', count(*) from Source.TradeType
union select 'WatchHistory', count(*) from Source.WatchHistory) s on e.tname = s.tname
inner join
(SELECT 'BatchDate' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[BatchDate]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[BatchDate]) then 1 else 0 end checksums_equal
union SELECT 'CashTransaction' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[CashTransaction]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[CashTransaction]) then 1 else 0 end checksums_equal
union SELECT 'CustomerMgmt' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[CustomerMgmt]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[CustomerMgmt]) then 1 else 0 end checksums_equal
union SELECT 'DailyMarket' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[DailyMarket]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[DailyMarket]) then 1 else 0 end checksums_equal
union SELECT 'Date' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[Date]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[Date]) then 1 else 0 end checksums_equal
union SELECT 'Finwire' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[Finwire]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[Finwire]) then 1 else 0 end checksums_equal
union SELECT 'HoldingHistory' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[HoldingHistory]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[HoldingHistory]) then 1 else 0 end checksums_equal
union SELECT 'HR' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[HR]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[HR]) then 1 else 0 end checksums_equal
union SELECT 'Industry' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[Industry]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[Industry]) then 1 else 0 end checksums_equal
union SELECT 'Prospect' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[Prospect]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[Prospect]) then 1 else 0 end checksums_equal
union SELECT 'StatusType' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[StatusType]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[StatusType]) then 1 else 0 end checksums_equal
union SELECT 'TaxRate' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[TaxRate]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[TaxRate]) then 1 else 0 end checksums_equal
union SELECT 'Time' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[Time]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[Time]) then 1 else 0 end checksums_equal
union SELECT 'Trade' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[Trade]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[Trade]) then 1 else 0 end checksums_equal
union SELECT 'TradeHistory' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[TradeHistory]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[TradeHistory]) then 1 else 0 end checksums_equal
union SELECT 'TradeType' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[TradeType]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[TradeType]) then 1 else 0 end checksums_equal
union SELECT 'WatchHistory' tname, case when (select checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].[Source].[WatchHistory]) = (SELECT checksum_agg(CHECKSUM(*)) FROM [TPC_DI_DB].dbo.[WatchHistory]) then 1 else 0 end checksums_equal
) c on c.tname = e.tname
GO

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

USE TPC_DI_DB;
GO

-- TPC DI Staging Area

CREATE SCHEMA Source;
GO

--CREATE TABLE Source.Account (
--	-- CDC_FLAG VARCHAR(1),
--	-- CDC_DSN NUMERIC(12),
--	CA_ID NUMERIC(11),
--	CA_B_ID NUMERIC(11),
--	CA_C_ID NUMERIC(11),
--	CA_NAME VARCHAR(50),
--	CA_TAX_ST NUMERIC(1),
--	CA_ST_ID VARCHAR(4)
--)

CREATE TABLE Source.BatchDate (
	BatchDate DATE
)

CREATE TABLE Source.CashTransaction (
	-- CDC_FLAG VARCHAR(1),
	-- CDC_DSN NUMERIC(12),
	CT_CA_ID NUMERIC(11),
	CT_DTS DATETIME,
	CT_AMT NUMERIC(10,2),
	CT_NAME VARCHAR(100)
)

--CREATE TABLE Source.Customer (
--	-- CDC_FLAG VARCHAR(1),
--	-- CDC_DSN NUMERIC(12),
--	C_ID NUMERIC(11),
--	C_TAX_ID VARCHAR(20),
--	C_ST_ID VARCHAR(4),
--	C_L_NAME VARCHAR(25),
--	C_F_NAME VARCHAR(20),
--	C_M_NAME VARCHAR(1),
--	C_GNDR VARCHAR(1),
--	C_TIER NUMERIC(1),
--	C_DOB DATE,
--	C_ADLINE1 VARCHAR(80),
--	C_ADLINE2 VARCHAR(80),
--	C_ZIPCODE VARCHAR(12),
--	C_CITY VARCHAR(25),
--	C_STATE_PROV VARCHAR(20),
--	C_CTRY VARCHAR(24),
--	C_CTRY_1 VARCHAR(3),
--	C_AREA_1 VARCHAR(3),
--	C_LOCAL_1 VARCHAR(10),
--	C_EXT_1 VARCHAR(5),
--	C_CTRY_2 VARCHAR(3),
--	C_AREA_2 VARCHAR(3),
--	C_LOCAL_2 VARCHAR(10),
--	C_EXT_2 VARCHAR(5),
--	C_CTRY_3 VARCHAR(3),
--	C_AREA_3 VARCHAR(3),
--	C_LOCAL_3 VARCHAR(10),
--	C_EXT_3 VARCHAR(5),
--	C_EMAIL_1 VARCHAR(50),
--	C_EMAIL_2 VARCHAR(50),
--	C_LCL_TX_ID VARCHAR(4),
--	C_NAT_TX_ID VARCHAR(4)
--)

--CREATE TABLE Source.ActionXML (
--	ActionType NVARCHAR(9),
--	ActionTS NVARCHAR(256),
--	Action_Id NVARCHAR(256),
--)

--CREATE TABLE Source.CustomerXML (
--	C_ID NUMERIC(11),
--	C_TAX_ID NVARCHAR(20),
--	C_GNDR NVARCHAR(1),
--	C_TIER NVARCHAR(256), -- Should be NUMERIC(1)
--	C_DOB DATE,
--    Customer_Id NVARCHAR(256),
--    Action_Id NVARCHAR(256),
--)

--CREATE TABLE Source.NameXML (
--	C_L_NAME NVARCHAR(25),
--	C_F_NAME NVARCHAR(20),
--	C_M_NAME NVARCHAR(1),
--	Customer_Id NVARCHAR(256),
--)

--CREATE TABLE Source.AddressXML (
--	C_ADLINE1 NVARCHAR(80),
--	C_ADLINE2 NVARCHAR(80),
--	C_ZIPCODE NVARCHAR(12),
--	C_CITY NVARCHAR(25),
--	C_STATE_PROV NVARCHAR(20),
--	C_CTRY NVARCHAR(24),
--	Customer_Id NVARCHAR(256),
--)

--CREATE TABLE Source.ContactInfoXML (
--	C_PRIM_EMAIL NVARCHAR(50),
--	C_ALT_EMAIL NVARCHAR(50),
--	Customer_Id NVARCHAR(256),
--	ContactInfo_Id NVARCHAR(256),
--)

--CREATE TABLE Source.C_PHONE_1_XML (
--	C_CTRY_CODE NVARCHAR(3),
--	C_AREA_CODE NVARCHAR(3),
--	C_LOCAL NVARCHAR(10),
--	C_EXT NVARCHAR(5) ,
--	ContactInfo_Id NVARCHAR(256),
--)

--CREATE TABLE Source.C_PHONE_2_XML (
--	C_CTRY_CODE NVARCHAR(3),
--	C_AREA_CODE NVARCHAR(3),
--	C_LOCAL NVARCHAR(10),
--	C_EXT NVARCHAR(5),
--	ContactInfo_Id NVARCHAR(256),
--)

--CREATE TABLE Source.C_PHONE_3_XML (
--	C_CTRY_CODE NVARCHAR(3),
--	C_AREA_CODE NVARCHAR(3),
--	C_LOCAL NVARCHAR(10),
--	C_EXT NVARCHAR(5),
--	ContactInfo_Id NVARCHAR(256),
--)

--CREATE TABLE Source.TaxInfoXML (
--	C_LCL_TX_ID NVARCHAR(4),
--	C_NAT_TX_ID NVARCHAR(4),
--    Customer_Id NVARCHAR(256),
--)

--CREATE TABLE Source.AccountXML (
--	CA_ID NUMERIC(11),
--	CA_TAX_ST NUMERIC(1),
--	CA_B_ID NUMERIC(11),
--	CA_NAME NVARCHAR(50),
--    Customer_Id NVARCHAR(256),
--)

CREATE TABLE Source.CustomerMgmt (
    -- Fields from ActionXML
    ActionType NVARCHAR(255),
    [ActionTS] NVARCHAR(255) NULL,
    --Action_Id NVARCHAR(255),

    -- Fields from CustomerXML
    C_ID int,
    C_TAX_ID NVARCHAR(255),
    C_GNDR NVARCHAR(255),
    C_TIER NVARCHAR(255), -- Adjusted to NUMERIC(1)
    C_DOB NVARCHAR(255),
    --Customer_Id NVARCHAR(255),

    -- Fields from NameXML
    C_L_NAME NVARCHAR(255),
    C_F_NAME NVARCHAR(255),
    C_M_NAME NVARCHAR(255),

    -- Fields from AddressXML
    C_ADLINE1 NVARCHAR(255),
    C_ADLINE2 NVARCHAR(255),
    C_ZIPCODE NVARCHAR(255),
    C_CITY NVARCHAR(255),
    C_STATE_PROV NVARCHAR(255),
    C_CTRY NVARCHAR(255),

    -- Fields from ContactInfoXML
    C_PRIM_EMAIL NVARCHAR(255),
    C_ALT_EMAIL NVARCHAR(255),
    --ContactInfo_Id NVARCHAR(255),

    -- Fields from C_PHONE_1_XML
    C_PHONE_1_CTRY_CODE NVARCHAR(255),
    C_PHONE_1_AREA_CODE NVARCHAR(255),
    C_PHONE_1_LOCAL NVARCHAR(255),
    C_PHONE_1_EXT NVARCHAR(255),

    -- Fields from C_PHONE_2_XML
    C_PHONE_2_CTRY_CODE NVARCHAR(255),
    C_PHONE_2_AREA_CODE NVARCHAR(255),
    C_PHONE_2_LOCAL NVARCHAR(255),
    C_PHONE_2_EXT NVARCHAR(255),

    -- Fields from C_PHONE_3_XML
    C_PHONE_3_CTRY_CODE NVARCHAR(255),
    C_PHONE_3_AREA_CODE NVARCHAR(255),
    C_PHONE_3_LOCAL NVARCHAR(255),
    C_PHONE_3_EXT NVARCHAR(255),

    -- Fields from TaxInfoXML
    C_LCL_TX_ID NVARCHAR(255),
    C_NAT_TX_ID NVARCHAR(255),

    -- Fields from AccountXML
    CA_ID int,
    CA_TAX_ST NVARCHAR(255),
    CA_B_ID NVARCHAR(255),
    CA_NAME NVARCHAR(255)
);

CREATE TABLE Source.DailyMarket (
    -- CDC_FLAG VARCHAR(1),
    -- CDC_DSN NUMERIC(12),
    DM_DATE DATE,
    DM_S_SYMB VARCHAR(15),
    DM_CLOSE NUMERIC(8,2),
    DM_HIGH NUMERIC(8,2),
    DM_LOW NUMERIC(8,2),
    DM_VOL NUMERIC(12),
);

CREATE TABLE Source.Date (
    SK_DateID NUMERIC(11),
    DateValue VARCHAR(20),
    DateDesc VARCHAR(20),
    CalendarYearID NUMERIC(4),
    CalendarYearDesc VARCHAR(20),
    CalendarQtrID NUMERIC(5),
    CalendarQtrDesc VARCHAR(20),
    CalendarMonthID NUMERIC(6),
    CalendarMonthDesc VARCHAR(20),
    CalendarWeekID NUMERIC(6),
    CalendarWeekDesc VARCHAR(20),
    DayOfWeekNum NUMERIC(1),
    DayOfWeekDesc VARCHAR(10),
    FiscalYearID NUMERIC(4),
    FiscalYearDesc VARCHAR(20),
    FiscalQtrID NUMERIC(5),
    FiscalQtrDesc VARCHAR(20),
    HolidayFlag NVARCHAR(5), -- This is supposed to be a '0' or '1' but it is 'true' or 'false'
)


CREATE TABLE Source.Finwire (
    --PTS NVARCHAR(15),
    --RecType NVARCHAR(3),
    Record NVARCHAR(999)
);

--CREATE TABLE Source.FinwireCMP (
--    PTS NVARCHAR(256),
--    RecType NVARCHAR(256),
--    CompanyName NVARCHAR(256),
--    CIK NVARCHAR(256),
--    Status NVARCHAR(256),
--    IndustryID NVARCHAR(256),
--    SPrating NVARCHAR(256),
--    FoundingDate NVARCHAR(256),
--    AddrLine1 NVARCHAR(256),
--    AddrLine2 NVARCHAR(256),
--    PostalCode NVARCHAR(256),
--    City NVARCHAR(256),
--    StateProvince NVARCHAR(256),
--    Country NVARCHAR(256),
--    CEOname NVARCHAR(256),
--    Description NVARCHAR(256),
--);

--CREATE TABLE Source.FinwireSEC (
--    PTS NVARCHAR(256),
--    RecType NVARCHAR(256),
--    Symbol NVARCHAR(256),
--    IssueType NVARCHAR(256),
--    Status NVARCHAR(256),
--    Name NVARCHAR(256),
--    ExID NVARCHAR(256),
--    ShOut NVARCHAR(256),
--    FirstTradeDate NVARCHAR(256),
--    FirstTradeExchg NVARCHAR(256),
--    Dividend NVARCHAR(256),
--    CoNameOrCIK NVARCHAR(256),
--);

--CREATE TABLE Source.FinwireFIN (
--    PTS NVARCHAR(256),
--    RecType NVARCHAR(256),
--    Year NVARCHAR(256),
--    Quarter NVARCHAR(256),
--    QtrStartDate NVARCHAR(256),
--    PostingDate NVARCHAR(256),
--    Revenue NVARCHAR(256),
--    Earnings NVARCHAR(256),
--    EPS NVARCHAR(256),
--    DilutedEPS NVARCHAR(256),
--    Margin NVARCHAR(256),
--    Inventory NVARCHAR(256),
--    Assets NVARCHAR(256),
--    Liabilities NVARCHAR(256),
--    ShOut NVARCHAR(256),
--    DilutedShOut NVARCHAR(256),
--    CoNameOrCIK NVARCHAR(256),
--);

CREATE TABLE Source.HoldingHistory (
    -- CDC_FLAG VARCHAR(1),
    -- CDC_DSN NUMERIC(12),
    HH_H_T_ID NUMERIC(15),
    HH_T_ID NUMERIC(15),
    HH_BEFORE_QTY NUMERIC(6),
    HH_AFTER_QTY NUMERIC(6),
);

CREATE TABLE Source.HR (
    EmployeeID NUMERIC(11),
    ManagerID NUMERIC(11),
    EmployeeFirstName VARCHAR(30),
    EmployeeLastName VARCHAR(30),
    EmployeeMI VARCHAR(1),
    EmployeeJobCode NUMERIC(3),
    EmployeeBranch VARCHAR(30),
    EmployeeOffice VARCHAR(10),
    EmployeePhone VARCHAR(14),
);

CREATE TABLE Source.Industry (
    IN_ID VARCHAR(2),
    IN_NAME VARCHAR(50),
    IN_SC_ID VARCHAR(4),
);

CREATE TABLE Source.Prospect (
    AgencyID VARCHAR(30),
    LastName VARCHAR(30),
    FirstName VARCHAR(30),
    MiddleInitial VARCHAR(1),
    Gender VARCHAR(1),
    AddressLine1 VARCHAR(80),
    AddressLine2 VARCHAR(80),
    PostalCode VARCHAR(12),
    City VARCHAR(25),
    State VARCHAR(20),
    Country VARCHAR(24),
    Phone VARCHAR(30),
    Income NUMERIC(9),
    NumberCars NUMERIC(2),
    NumberChildren NUMERIC(2),
    MaritalStatus VARCHAR(1),
    Age NUMERIC(3),
    CreditRating NUMERIC(4),
    OwnOrRentFlag VARCHAR(1),
    Employer VARCHAR(30),
    NumberCreditCards NUMERIC(2),
    NetWorth NUMERIC(12)
);


CREATE TABLE Source.StatusType (
    ST_ID VARCHAR(4),
    ST_NAME VARCHAR(10),
);


CREATE TABLE Source.TaxRate (
    TX_ID VARCHAR(4),
    TX_NAME VARCHAR(50),
    TX_RATE NUMERIC(6,5),
);

CREATE TABLE Source.Time (
    SK_TimeID NUMERIC(11),
    TimeValue VARCHAR(20),
    HourID NUMERIC(2),
    HourDesc VARCHAR(20),
    MinuteID NUMERIC(2),
    MinuteDesc VARCHAR(20),
    SecondID NUMERIC(2),
    SecondDesc VARCHAR(20),
    MarketHoursFlag NVARCHAR(5), -- This is supposed to be a '0' or '1' but it is 'true' or 'false'
    OfficeHoursFlag NVARCHAR(5), -- This is supposed to be a '0' or '1' but it is 'true' or 'false'
);

CREATE TABLE Source.TradeHistory (
    TH_T_ID NUMERIC(15),
    TH_DTS DATETIME,
    TH_ST_ID VARCHAR(4),
);

CREATE TABLE Source.Trade (
    -- CDC_FLAG VARCHAR(1),
    -- CDC_DSN NUMERIC(12),
    T_ID NUMERIC(15),
    T_DTS DATETIME,
    T_ST_ID VARCHAR(4),
    T_TT_ID VARCHAR(3),
    T_IS_CASH NVARCHAR(5), -- This is supposed to be a '0' or '1' but it is 'true' or 'false'
    T_S_SYMB VARCHAR(15),
    T_QTY NUMERIC(6),
    T_BID_PRICE NUMERIC(8,2),
    T_CA_ID NUMERIC(11),
    T_EXEC_NAME VARCHAR(49),
    T_TRADE_PRICE NUMERIC(8,2),
    T_CHRG NUMERIC(10,2),
    T_COMM NUMERIC(10,2),
    T_TAX NUMERIC(10,2),
);

CREATE TABLE Source.TradeType (
    TT_ID VARCHAR(3),
    TT_NAME VARCHAR(12),
    TT_IS_SELL NUMERIC(1),
    TT_IS_MRKT NUMERIC(1)
);


CREATE TABLE Source.WatchHistory (
    -- CDC_FLAG VARCHAR(1),
    -- CDC_DSN NUMERIC(12),
    W_C_ID NUMERIC(11),
    W_S_SYMB VARCHAR(15),
    W_DTS DATETIME,
    W_ACTION VARCHAR(4)
);

--CREATE TABLE Source.AuditFiles (
--    DataSet VARCHAR(20),
--    BatchID NUMERIC(5),
--    Date DATE,
--    Attribute VARCHAR(50),
--    Value NUMERIC(15),
--    DValue NUMERIC(15,5)
--);


-- TPC DI Data Warehouse

-- Original SQL Script pulled from TPC-DI Project completed by:
-- Gonçalo Moreira, Nazrin Najafzade, Rémy Detobel, Shafagh Kashef
-- https://github.com/detobel36/tpc-di/blob/master/createTables.sql

-- Code has been reviewed and checked against TPC-DI_SPEC_v1.1.0.pdf

-- Meta Types are not being used (e.g. SK_T is a NUM(11). NUM does not exist in SQL server, use VARCHAR()?)
-- why is there space between column name and type for status an accountDesc?
-- is creating including the restrictions (e.g. VARCHAR(50) or NOT NULL) the referential integrity
--  we were talking about potentially not including?
-- is it just sloppy scripting to have Not NULL vs NOT NULL?
-- numeric(5) vs integer vs VARCHAR(5) etc.

--CREATE TABLE DimBroker  (
--    SK_BrokerID  INTEGER NOT NULL IDENTITY (1,1) PRIMARY KEY,
--    BrokerID  INTEGER NOT NULL,
--    ManagerID  INTEGER,
--    FirstName       VARCHAR(50) NOT NULL,
--    LastName       VARCHAR(50) NOT NULL,
--    MiddleInitial       VARCHAR(1),
--    Branch       VARCHAR(50),
--    Office       VARCHAR(50),
--    Phone       VARCHAR(14),
--    IsCurrent BIT NOT NULL,
--    BatchID INTEGER NOT NULL,
--    EffectiveDate date NOT NULL,
--    EndDate date NOT NULL                                                 
--);

--CREATE TABLE DimCompany (
--    SK_CompanyID INTEGER NOT NULL IDENTITY (1,1) PRIMARY KEY, 
--    CompanyID INTEGER NOT NULL,
--    Status VARCHAR(10) Not NULL, 
--    Name VARCHAR(60) Not NULL,
--    Industry VARCHAR(50) Not NULL,
--    SPrating VARCHAR(4),
--    isLowGrade BIT,
--    CEO VARCHAR(100) Not NULL,
--    AddressLine1 VARCHAR(80),
--    AddressLine2 VARCHAR(80),
--    PostalCode VARCHAR(12) Not NULL,
--    City VARCHAR(25) Not NULL,
--    StateProv VARCHAR(20) Not NULL,
--    Country VARCHAR(24),
--    Description VARCHAR(150) Not NULL,
--    FoundingDate DATE,
--    IsCurrent BIT Not NULL,
--    BatchID numeric(5) Not NULL,
--    EffectiveDate DATE Not NULL,
--    EndDate DATE Not NULL
--);

--CREATE TABLE DimCustomer  (
--    SK_CustomerID  INTEGER NOT NULL IDENTITY (1,1) PRIMARY KEY,
--    CustomerID INTEGER NOT NULL,
--    TaxID VARCHAR(20) NOT NULL,
--    Status VARCHAR(10) NOT NULL,
--    LastName VARCHAR(30) NOT NULL,
--    FirstName VARCHAR(30) NOT NULL,
--    MiddleInitial VARCHAR(1),
--    Gender VARCHAR(1),
--    Tier Integer,
--    DOB date NOT NULL,
--    AddressLine1  varchar(80) NOT NULL,
--    AddressLine2  varchar(80),
--    PostalCode    VARCHAR(12) NOT NULL,
--    City   VARCHAR(25) NOT NULL,
--    StateProv     VARCHAR(20) NOT NULL,
--    Country       VARCHAR(24),
--    Phone1 VARCHAR(30),
--    Phone2 VARCHAR(30),
--    Phone3 VARCHAR(30),
--    Email1 VARCHAR(50),
--    Email2 VARCHAR(50),
--    NationalTaxRateDesc  varchar(50),
--    NationalTaxRate      numeric(6,5),
--    LocalTaxRateDesc     varchar(50),
--    LocalTaxRate  numeric(6,5),
--    AgencyID      VARCHAR(30),
--    CreditRating integer,
--    NetWorth      numeric(10),
--    MarketingNameplate varchar(100),
--    IsCurrent BIT NOT NULL,
--    BatchID INTEGER NOT NULL,
--    EffectiveDate date NOT NULL,
--    EndDate date NOT NULL
--);

--CREATE TABLE DimAccount  (
--    SK_AccountID  INTEGER NOT NULL IDENTITY (1,1) PRIMARY KEY,
--    AccountID  INTEGER NOT NULL,
--    SK_BrokerID  INTEGER NOT NULL REFERENCES DimBroker (SK_BrokerID),
--    SK_CustomerID  INTEGER NOT NULL REFERENCES DimCustomer (SK_CustomerID),
--    Status       VARCHAR(10) NOT NULL,
--    AccountDesc       varchar(50),
--    TaxStatus  INTEGER NOT NULL CHECK (TaxStatus = 0 OR TaxStatus = 1 OR TaxStatus = 2),
--    IsCurrent BIT NOT NULL,
--    BatchID INTEGER NOT NULL,
--    EffectiveDate date NOT NULL,
--    EndDate date NOT NULL
--);

--CREATE TABLE DimDate (
--    SK_DateID INTEGER Not NULL PRIMARY KEY,
--    DateValue DATE Not NULL,
--    DateDesc VARCHAR(20) Not NULL,
--    CalendarYearID numeric(4) Not NULL,
--    CalendarYearDesc VARCHAR(20) Not NULL,
--    CalendarQtrID numeric(5) Not NULL,
--    CalendarQtrDesc VARCHAR(20) Not NULL,
--    CalendarMonthID numeric(6) Not NULL,
--    CalendarMonthDesc VARCHAR(20) Not NULL,
--    CalendarWeekID numeric(6) Not NULL,
--    CalendarWeekDesc VARCHAR(20) Not NULL,
--    DayOfWeeknumeric numeric(1) Not NULL,
--    DayOfWeekDesc VARCHAR(10) Not NULL,
--    FiscalYearID numeric(4) Not NULL,
--    FiscalYearDesc VARCHAR(20) Not NULL,
--    FiscalQtrID numeric(5) Not NULL,
--    FiscalQtrDesc VARCHAR(20) Not NULL,
--    HolidayFlag BIT
--);

--CREATE TABLE DimSecurity(
--    SK_SecurityID INTEGER Not NULL IDENTITY (1,1) PRIMARY KEY,
--    Symbol VARCHAR(15) Not NULL,
--    Issue VARCHAR(6) Not NULL,
--    Status VARCHAR(10) Not NULL,
--    Name VARCHAR(70) Not NULL,
--    ExchangeID VARCHAR(6) Not NULL,
--    SK_CompanyID INTEGER Not NULL REFERENCES DimCompany (SK_CompanyID),
--    SharesOutstanding INTEGER Not NULL,
--    FirstTrade DATE Not NULL,
--    FirstTradeOnExchange DATE Not NULL,
--    Dividend numeric(10,2) Not NULL,
--    IsCurrent BIT Not NULL,
--    BatchID numeric(5) Not NULL,
--    EffectiveDate DATE Not NULL,
--    EndDate DATE Not NULL
--);

--CREATE TABLE DimTime (
--    SK_TimeID INTEGER Not NULL PRIMARY KEY,
--    TimeValue TIME Not NULL,
--    HourID numeric(2) Not NULL,
--    HourDesc VARCHAR(20) Not NULL,
--    MinuteID numeric(2) Not NULL,
--    MinuteDesc VARCHAR(20) Not NULL,
--    SecondID numeric(2) Not NULL,
--    SecondDesc VARCHAR(20) Not NULL,
--    MarketHoursFlag BIT,
--    OfficeHoursFlag BIT
--);

--CREATE TABLE DimTrade (
--    TradeID INTEGER Not NULL,
--    SK_BrokerID INTEGER REFERENCES DimBroker (SK_BrokerID),
--    SK_CreateDateID INTEGER REFERENCES DimDate (SK_DateID),
--    SK_CreateTimeID INTEGER REFERENCES DimTime (SK_TimeID),
--    SK_CloseDateID INTEGER REFERENCES DimDate (SK_DateID),
--    SK_CloseTimeID INTEGER REFERENCES DimTime (SK_TimeID),
--    Status VARCHAR(10) Not NULL,
--    DT_Type VARCHAR(12) Not NULL,
--    CashFlag BIT Not NULL,
--    SK_SecurityID INTEGER Not NULL REFERENCES DimSecurity (SK_SecurityID),
--    SK_CompanyID INTEGER Not NULL REFERENCES DimCompany (SK_CompanyID),
--    Quantity numeric(6,0) Not NULL,
--    BidPrice numeric(8,2) Not NULL,
--    SK_CustomerID INTEGER Not NULL REFERENCES DimCustomer (SK_CustomerID),
--    SK_AccountID INTEGER Not NULL REFERENCES DimAccount (SK_AccountID),
--    ExecutedBy VARCHAR(64) Not NULL,
--    TradePrice numeric(8,2),
--    Fee numeric(10,2),
--    Commission numeric(10,2),
--    Tax numeric(10,2),
--    BatchID numeric(5) Not Null
--);

--CREATE TABLE DImessages (
--    MessageDateAndTime TIMESTAMP Not NULL,
--    BatchID numeric(5) Not NULL,
--    MessageSource VARCHAR(30),
--    MessageText VARCHAR(50) Not NULL,
--    MessageType VARCHAR(12) Not NULL,
--    MessageData VARCHAR(100)
--);

--CREATE TABLE FactCashBalances (
--    SK_CustomerID INTEGER Not Null REFERENCES DimCustomer (SK_CustomerID),
--    SK_AccountID INTEGER Not Null REFERENCES DimAccount (SK_AccountID),
--    SK_DateID INTEGER Not Null REFERENCES DimDate (SK_DateID),
--    Cash numeric(15,2) Not Null,
--    BatchID numeric(5)
--);

--CREATE TABLE FactHoldings (
--    TradeID INTEGER Not NULL,
--    CurrentTradeID INTEGER Not Null,
--    SK_CustomerID INTEGER Not NULL REFERENCES DimCustomer (SK_CustomerID),
--    SK_AccountID INTEGER Not NULL REFERENCES DimAccount (SK_AccountID),
--    SK_SecurityID INTEGER Not NULL REFERENCES DimSecurity (SK_SecurityID),
--    SK_CompanyID INTEGER Not NULL REFERENCES DimCompany (SK_CompanyID),
--    SK_DateID INTEGER NULL REFERENCES DimDate (SK_DateID),
--    SK_TimeID INTEGER NULL REFERENCES DimTime (SK_TimeID),
--    CurrentPrice numeric(8,2) CHECK (CurrentPrice > 0) ,
--    CurrentHolding numeric(6) Not NULL,
--    BatchID numeric(5)
--);

--CREATE TABLE FactMarketHistory (   
--    SK_SecurityID INTEGER Not Null REFERENCES DimSecurity (SK_SecurityID),
--    SK_CompanyID INTEGER Not Null REFERENCES DimCompany (SK_CompanyID),
--    SK_DateID INTEGER Not Null REFERENCES DimDate (SK_DateID),
--    PERatio numeric(10,2),
--    Yield numeric(5,2) Not Null,
--    FiftyTwoWeekHigh numeric(8,2) Not Null,
--    SK_FiftyTwoWeekHighDate INTEGER Not Null,
--    FiftyTwoWeekLow numeric(8,2) Not Null,
--    SK_FiftyTwoWeekLowDate INTEGER Not Null,
--    ClosePrice numeric(8,2) Not Null,
--    DayHigh numeric(8,2) Not Null,
--    DayLow numeric(8,2) Not Null,
--    Volume numeric(12) Not Null,
--    BatchID numeric(5)
--);

--CREATE TABLE FactWatches (
--    SK_CustomerID INTEGER Not NULL REFERENCES DimCustomer (SK_CustomerID),
--    SK_SecurityID INTEGER Not NULL REFERENCES DimSecurity (SK_SecurityID),
--    SK_DateID_DatePlaced INTEGER Not NULL REFERENCES DimDate (SK_DateID),
--    SK_DateID_DateRemoved INTEGER REFERENCES DimDate (SK_DateID),
--    BatchID numeric(5) Not Null 
--);

--CREATE TABLE Industry (
--    IN_ID VARCHAR(2) Not NULL,
--    IN_NAME VARCHAR(50) Not NULL,
--    IN_SC_ID VARCHAR(4) Not NULL
--);

--CREATE TABLE Financial (
--    SK_CompanyID INTEGER Not NULL REFERENCES DimCompany (SK_CompanyID),
--    FI_YEAR numeric(4) Not NULL,
--    FI_QTR numeric(1) Not NULL,
--    FI_QTR_START_DATE DATE Not NULL,
--    FI_REVENUE numeric(15,2) Not NULL,
--    FI_NET_EARN numeric(15,2) Not NULL,
--    FI_BASIC_EPS numeric(10,2) Not NULL,
--    FI_DILUT_EPS numeric(10,2) Not NULL,
--    FI_MARGIN numeric(10,2) Not NULL,
--    FI_INVENTORY numeric(15,2) Not NULL,
--    FI_ASSETS numeric(15,2) Not NULL,
--    FI_LIABILITY numeric(15,2) Not NULL,
--    FI_OUT_BASIC numeric(12) Not NULL,
--    FI_OUT_DILUT numeric(12) Not NULL
--);

--CREATE TABLE Prospect (
--    AgencyID VARCHAR(30) NOT NULL UNIQUE,  
--    SK_RecordDateID INTEGER NOT NULL, 
--    SK_UpdateDateID INTEGER NOT NULL REFERENCES DimDate (SK_DateID),
--    BatchID numeric(5) NOT NULL,
--    IsCustomer BIT NOT NULL,
--    LastName VARCHAR(30) NOT NULL,
--    FirstName VARCHAR(30) NOT NULL,
--    MiddleInitial VARCHAR(1),
--    Gender VARCHAR(1),
--    AddressLine1 VARCHAR(80),
--    AddressLine2 VARCHAR(80),
--    PostalCode VARCHAR(12),
--    City VARCHAR(25) NOT NULL,
--    State VARCHAR(20) NOT NULL,
--    Country VARCHAR(24),
--    Phone VARCHAR(30), 
--    Income numeric(9),
--    numberCars numeric(2), 
--    numberChildren numeric(2), 
--    MaritalStatus VARCHAR(1), 
--    Age numeric(3),
--    CreditRating numeric(4),
--    OwnOrRentFlag VARCHAR(1), 
--    Employer VARCHAR(30),
--    numberCreditCards numeric(2), 
--    NetWorth numeric(12),
--    MarketingNameplate VARCHAR(100)
--);

--CREATE TABLE StatusType (
--    ST_ID VARCHAR(4) Not NULL,
--    ST_NAME VARCHAR(10) Not NULL
--);

--CREATE TABLE TaxRate (
--    TX_ID VARCHAR(4) Not NULL,
--    TX_NAME VARCHAR(50) Not NULL,
--    TX_RATE numeric(6,5) Not NULL
--);

--CREATE TABLE TradeType (
--    TT_ID VARCHAR(3) Not NULL,
--    TT_NAME VARCHAR(12) Not NULL,
--    TT_IS_SELL numeric(1) Not NULL,
--    TT_IS_MRKT numeric(1) Not NULL
--);

--CREATE TABLE AuditTable (
--    DataSet VARCHAR(20) Not Null,
--    BatchID numeric(5),
--    AT_Date DATE,
--    AT_Attribute VARCHAR(50),
--    AT_Value numeric(15),
--    DValue numeric(15,5)
--);

--CREATE INDEX PIndex ON DimTrade (TradeID);


CREATE TABLE dbo.BatchDate (
	BatchDate DATE
)

CREATE TABLE dbo.CashTransaction (
	-- CDC_FLAG VARCHAR(1),
	-- CDC_DSN NUMERIC(12),
	CT_CA_ID NUMERIC(11),
	CT_DTS DATETIME,
	CT_AMT NUMERIC(10,2),
	CT_NAME VARCHAR(100)
)



CREATE TABLE dbo.CustomerMgmt (
    -- Fields from ActionXML
    ActionType NVARCHAR(255),
    [ActionTS] NVARCHAR(255) NULL,
    --Action_Id NVARCHAR(255),

    -- Fields from CustomerXML
    C_ID int,
    C_TAX_ID NVARCHAR(255),
    C_GNDR NVARCHAR(255),
    C_TIER NVARCHAR(255), -- Adjusted to NUMERIC(1)
    C_DOB NVARCHAR(255),
    --Customer_Id NVARCHAR(255),

    -- Fields from NameXML
    C_L_NAME NVARCHAR(255),
    C_F_NAME NVARCHAR(255),
    C_M_NAME NVARCHAR(255),

    -- Fields from AddressXML
    C_ADLINE1 NVARCHAR(255),
    C_ADLINE2 NVARCHAR(255),
    C_ZIPCODE NVARCHAR(255),
    C_CITY NVARCHAR(255),
    C_STATE_PROV NVARCHAR(255),
    C_CTRY NVARCHAR(255),

    -- Fields from ContactInfoXML
    C_PRIM_EMAIL NVARCHAR(255),
    C_ALT_EMAIL NVARCHAR(255),
    --ContactInfo_Id NVARCHAR(255),

    -- Fields from C_PHONE_1_XML
    C_PHONE_1_CTRY_CODE NVARCHAR(255),
    C_PHONE_1_AREA_CODE NVARCHAR(255),
    C_PHONE_1_LOCAL NVARCHAR(255),
    C_PHONE_1_EXT NVARCHAR(255),

    -- Fields from C_PHONE_2_XML
    C_PHONE_2_CTRY_CODE NVARCHAR(255),
    C_PHONE_2_AREA_CODE NVARCHAR(255),
    C_PHONE_2_LOCAL NVARCHAR(255),
    C_PHONE_2_EXT NVARCHAR(255),

    -- Fields from C_PHONE_3_XML
    C_PHONE_3_CTRY_CODE NVARCHAR(255),
    C_PHONE_3_AREA_CODE NVARCHAR(255),
    C_PHONE_3_LOCAL NVARCHAR(255),
    C_PHONE_3_EXT NVARCHAR(255),

    -- Fields from TaxInfoXML
    C_LCL_TX_ID NVARCHAR(255),
    C_NAT_TX_ID NVARCHAR(255),

    -- Fields from AccountXML
    CA_ID int,
    CA_TAX_ST NVARCHAR(255),
    CA_B_ID NVARCHAR(255),
    CA_NAME NVARCHAR(255)
);

CREATE TABLE dbo.DailyMarket (
    -- CDC_FLAG VARCHAR(1),
    -- CDC_DSN NUMERIC(12),
    DM_DATE DATE,
    DM_S_SYMB VARCHAR(15),
    DM_CLOSE NUMERIC(8,2),
    DM_HIGH NUMERIC(8,2),
    DM_LOW NUMERIC(8,2),
    DM_VOL NUMERIC(12),
);

CREATE TABLE dbo.Date (
    SK_DateID NUMERIC(11),
    DateValue VARCHAR(20),
    DateDesc VARCHAR(20),
    CalendarYearID NUMERIC(4),
    CalendarYearDesc VARCHAR(20),
    CalendarQtrID NUMERIC(5),
    CalendarQtrDesc VARCHAR(20),
    CalendarMonthID NUMERIC(6),
    CalendarMonthDesc VARCHAR(20),
    CalendarWeekID NUMERIC(6),
    CalendarWeekDesc VARCHAR(20),
    DayOfWeekNum NUMERIC(1),
    DayOfWeekDesc VARCHAR(10),
    FiscalYearID NUMERIC(4),
    FiscalYearDesc VARCHAR(20),
    FiscalQtrID NUMERIC(5),
    FiscalQtrDesc VARCHAR(20),
    HolidayFlag NVARCHAR(5), -- This is supposed to be a '0' or '1' but it is 'true' or 'false'
)


CREATE TABLE dbo.Finwire (
    --PTS NVARCHAR(15),
    --RecType NVARCHAR(3),
    Record NVARCHAR(999)
);


CREATE TABLE dbo.HoldingHistory (
    -- CDC_FLAG VARCHAR(1),
    -- CDC_DSN NUMERIC(12),
    HH_H_T_ID NUMERIC(15),
    HH_T_ID NUMERIC(15),
    HH_BEFORE_QTY NUMERIC(6),
    HH_AFTER_QTY NUMERIC(6),
);

CREATE TABLE dbo.HR (
    EmployeeID NUMERIC(11),
    ManagerID NUMERIC(11),
    EmployeeFirstName VARCHAR(30),
    EmployeeLastName VARCHAR(30),
    EmployeeMI VARCHAR(1),
    EmployeeJobCode NUMERIC(3),
    EmployeeBranch VARCHAR(30),
    EmployeeOffice VARCHAR(10),
    EmployeePhone VARCHAR(14),
);

CREATE TABLE dbo.Industry (
    IN_ID VARCHAR(2),
    IN_NAME VARCHAR(50),
    IN_SC_ID VARCHAR(4),
);

CREATE TABLE dbo.Prospect (
    AgencyID VARCHAR(30),
    LastName VARCHAR(30),
    FirstName VARCHAR(30),
    MiddleInitial VARCHAR(1),
    Gender VARCHAR(1),
    AddressLine1 VARCHAR(80),
    AddressLine2 VARCHAR(80),
    PostalCode VARCHAR(12),
    City VARCHAR(25),
    State VARCHAR(20),
    Country VARCHAR(24),
    Phone VARCHAR(30),
    Income NUMERIC(9),
    NumberCars NUMERIC(2),
    NumberChildren NUMERIC(2),
    MaritalStatus VARCHAR(1),
    Age NUMERIC(3),
    CreditRating NUMERIC(4),
    OwnOrRentFlag VARCHAR(1),
    Employer VARCHAR(30),
    NumberCreditCards NUMERIC(2),
    NetWorth NUMERIC(12)
);


CREATE TABLE dbo.StatusType (
    ST_ID VARCHAR(4),
    ST_NAME VARCHAR(10),
);


CREATE TABLE dbo.TaxRate (
    TX_ID VARCHAR(4),
    TX_NAME VARCHAR(50),
    TX_RATE NUMERIC(6,5),
);

CREATE TABLE dbo.Time (
    SK_TimeID NUMERIC(11),
    TimeValue VARCHAR(20),
    HourID NUMERIC(2),
    HourDesc VARCHAR(20),
    MinuteID NUMERIC(2),
    MinuteDesc VARCHAR(20),
    SecondID NUMERIC(2),
    SecondDesc VARCHAR(20),
    MarketHoursFlag NVARCHAR(5), -- This is supposed to be a '0' or '1' but it is 'true' or 'false'
    OfficeHoursFlag NVARCHAR(5), -- This is supposed to be a '0' or '1' but it is 'true' or 'false'
);

CREATE TABLE dbo.TradeHistory (
    TH_T_ID NUMERIC(15),
    TH_DTS DATETIME,
    TH_ST_ID VARCHAR(4),
);

CREATE TABLE dbo.Trade (
    -- CDC_FLAG VARCHAR(1),
    -- CDC_DSN NUMERIC(12),
    T_ID NUMERIC(15),
    T_DTS DATETIME,
    T_ST_ID VARCHAR(4),
    T_TT_ID VARCHAR(3),
    T_IS_CASH NVARCHAR(5), -- This is supposed to be a '0' or '1' but it is 'true' or 'false'
    T_S_SYMB VARCHAR(15),
    T_QTY NUMERIC(6),
    T_BID_PRICE NUMERIC(8,2),
    T_CA_ID NUMERIC(11),
    T_EXEC_NAME VARCHAR(49),
    T_TRADE_PRICE NUMERIC(8,2),
    T_CHRG NUMERIC(10,2),
    T_COMM NUMERIC(10,2),
    T_TAX NUMERIC(10,2),
);

CREATE TABLE dbo.TradeType (
    TT_ID VARCHAR(3),
    TT_NAME VARCHAR(12),
    TT_IS_SELL NUMERIC(1),
    TT_IS_MRKT NUMERIC(1)
);


CREATE TABLE dbo.WatchHistory (
    -- CDC_FLAG VARCHAR(1),
    -- CDC_DSN NUMERIC(12),
    W_C_ID NUMERIC(11),
    W_S_SYMB VARCHAR(15),
    W_DTS DATETIME,
    W_ACTION VARCHAR(4)
);
go

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



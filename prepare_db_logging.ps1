sqlcmd -S localhost\ss2022 -i $PSScriptRoot\DDL_TPC_DI_Logging.sql
eel execute $PSScriptRoot\ingest-file-summary-eel\
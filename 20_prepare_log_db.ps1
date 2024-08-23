param (
    [string]$sql_instance = "localhost"
)

echo "Create database for logging"
sqlcmd -S $sql_instance -i $PSScriptRoot\DDL_TPC_DI_Logging.sql
echo "Use eel to save source scale factor file summaries to logging database"
eel execute $PSScriptRoot\ingest-file-summary-eel\
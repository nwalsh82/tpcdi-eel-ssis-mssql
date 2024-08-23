param (
    [string]$sql_instance = "localhost",
    [int[]]$scaleFactors = @(3),
    [int]$runs = 1
)

foreach ($scaleFactor in $scaleFactors) {
    .\tpcdi-eel-ssis-mssql\10_prepare_source.ps1 $scaleFactor
}
.\tpcdi-eel-ssis-mssql\20_prepare_log_db.ps1 $sql_server_2022_path
.\tpcdi-eel-ssis-mssql\30_execute_experiments.ps1 $sql_server_2022_path $scaleFactors $runs
param (
    [string]$sql_instance = "localhost",
    [int[]]$scaleFactors = @(3),
    [int]$runs = 1
)

foreach ($scaleFactor in $scaleFactors) {
    Write-Host "Processing $scaleFactor"
    
    for ($i = 1; $i -le $runs; $i++) {
        
        echo "Begin scale factor $scaleFactor, run $i"
        
        echo "Drop and create the database"
        sqlcmd -S $sql_instance -i $PSScriptRoot\DDL_TPC_DI_DB.sql

        echo "Start log for SSIS"
        $sql = "INSERT INTO [TPC_DI_Logging].[dbo].[Logging] VALUES ( 'SSIS', GETDATE(), 'Start',  '$scaleFactor', '$i' );"
        sqlcmd -S $sql_instance -Q $sql
        
        echo "Execute SSIS ingestion"
        & "C:\Program Files\Microsoft SQL Server\160\DTS\Binn\DTExec.exe" /F .\SF$scaleFactor\ssis\ingest.dtsx /Rep E

        echo "End log for SSIS"
        $sql = "INSERT INTO [TPC_DI_Logging].[dbo].[Logging] VALUES ( 'SSIS', GETDATE(), 'End',  '$scaleFactor', '$i' );"
        sqlcmd -S $sql_instance -Q $sql

        echo "Start log for eel"
        $sql = "INSERT INTO [TPC_DI_Logging].[dbo].[Logging] VALUES ( 'eel', GETDATE(), 'Start',  '$scaleFactor', '$i' );"
        sqlcmd -S $sql_instance -Q $sql

        echo "Execute eel ingestion"
        eel execute .\SF$scaleFactor\eel

        echo "End log for eel"
        $sql = "INSERT INTO [TPC_DI_Logging].[dbo].[Logging] VALUES ( 'eel', GETDATE(), 'End',  '$scaleFactor', '$i' );"
        sqlcmd -S $sql_instance -Q $sql

        echo "Save audits to logging db"
        $sql = "insert into [TPC_DI_Logging].dbo.AuditDetailed
        SELECT 'audit detailed', '$scaleFactor', '$i', [tname]
        , [eel_count]
        , [ssis_count]
        , [checksums_equal]
        FROM [TPC_DI_DB].[dbo].[vwAudit]"
        sqlcmd -S $sql_instance -Q $sql
        
        $sql = "insert into [TPC_DI_Logging].dbo.Audit
        SELECT 'audit','$scaleFactor', '$i', case when sum([checksums_equal]-1) = 0 then (1) else (0) end
        FROM [TPC_DI_Logging].[dbo].[AuditDetailed]
        where [ScaleFactor] = '$scaleFactor' and [RunID] = $i"
        sqlcmd -S $sql_instance -Q $sql
    }
}
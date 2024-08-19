# Define a list of scalefactor names
$scaleFactors = @(3)

# Define the number of times to perform an action for each scalefactor
$runs = 1

# Loop over each scalefactor in the list
foreach ($scaleFactor in $scaleFactors) {
    Write-Host "Processing $scaleFactor"
    
    # Loop over the runs
    for ($i = 1; $i -le $runs; $i++) {
        Write-Host "  Action $i for $scaleFactor"
        # Drop and create the database
        sqlcmd -S localhost\ss2022 -i $PSScriptRoot\DDL_TPC_DI_DB.sql

        # start log for SSIS
        $sql = "INSERT INTO [TPC_DI_Logging].[dbo].[Logging] VALUES ( 'SSIS', GETDATE(), 'Start',  '$scaleFactor', '$i' );"
        sqlcmd -S localhost\ss2022 -Q $sql
        
        # execute SSIS ingestion
        & "C:\Program Files\Microsoft SQL Server\160\DTS\Binn\DTExec.exe" /F .\SF$scaleFactor\ssis\ingest.dtsx /Rep E

        # end log for SSIS
        $sql = "INSERT INTO [TPC_DI_Logging].[dbo].[Logging] VALUES ( 'SSIS', GETDATE(), 'End',  '$scaleFactor', '$i' );"
        sqlcmd -S localhost\ss2022 -Q $sql

        # start log for eel
        $sql = "INSERT INTO [TPC_DI_Logging].[dbo].[Logging] VALUES ( 'eel', GETDATE(), 'Start',  '$scaleFactor', '$i' );"
        sqlcmd -S localhost\ss2022 -Q $sql

        # execute eel ingestion
        eel execute .\SF$scaleFactor\eel

        # end log for eel
        $sql = "INSERT INTO [TPC_DI_Logging].[dbo].[Logging] VALUES ( 'eel', GETDATE(), 'End',  '$scaleFactor', '$i' );"
        sqlcmd -S localhost\ss2022 -Q $sql

        # save audits to logging db
        $sql = "insert into [TPC_DI_Logging].dbo.AuditDetailed
        SELECT 'audit detailed', '$scaleFactor', '$i', [tname]
        , [eel_count]
        , [ssis_count]
        , [checksums_equal]
        FROM [TPC_DI_DB].[dbo].[vwAudit]"
        sqlcmd -S localhost\ss2022 -Q $sql
        
        $sql = "insert into [TPC_DI_Logging].dbo.Audit
        SELECT 'audit','$scaleFactor', '$i', case when sum([checksums_equal]-1) = 0 then (1) else (0) end
        FROM [TPC_DI_Logging].[dbo].[AuditDetailed]
        where [ScaleFactor] = '$scaleFactor' and [RunID] = $i"
        sqlcmd -S localhost\ss2022 -Q $sql
    }
}
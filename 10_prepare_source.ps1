param (
    [int]$scaleFactor
)
$scriptsDir = ".\tpcdi-eel-ssis-mssql"
$sfBaseDir = ".\SF$scaleFactor"
$batchDir = "$sfBaseDir\Batch1"
$finwireDir = "$batchDir\_FINWIRE"
$eelDir = "$sfBaseDir\eel"
$ssisDir = "$sfBaseDir\ssis"
$meltanoDir = "$sfBaseDir\meltano"
$ssisPackage = "$ssisDir\ingest.dtsx"
$summaryDir = "$scriptsDir\ingest-file-summary-eel"
$summaryFile = "$summaryDir\$scaleFactor.csv"

cd Tools
java -jar DIGen.jar -sf $scaleFactor -o ..\$sfBaseDir
cd ..

md $finwireDir
md $eelDir
md $ssisDir
md $meltanoDir

# audit files not used
rm "$batchDir\*_audit.csv"

# Move FINWIRE files and concatenate to FINWIRE.fwf
mv "$batchDir\FINWIRE*" $finwireDir
cat "$finwireDir\*" > "$batchDir\FINWIRE.fwf"

# Copy eel files
cp "$scriptsDir\ingest-tpcdi-eel\*.*" $eelDir

# Copy meltano file
cp "$scriptsDir\ingest-tpcdi-eel\meltano.yml" $meltanoDir

# Setup meltano project
meltano init meltano --no-usage-stats
cd $meltanoDir
meltano add extractor tap-spreadsheets-anywhere
meltano add loader target-mssql
# Modify target-mssql connector.py to remove username and password (enables Windows authentication)
sed -i '/username=/s/^/#/; /password=/s/^/#/' .\.meltano\loaders\target-mssql\venv\Lib\site-packages\target_mssql\connector.py
copy $scriptsDir\meltano.yml .
meltano run tap-spreadsheets-anywhere target-mssql
cd $scriptsDir


# Copy SSIS package
cp "$scriptsDir\ssis_ingest.dtsx" $ssisPackage
# Modify parameters in SSIS package
xml ed -L -N dts="www.microsoft.com/SqlServer/Dts" -u "//dts:PackageParameter[@DTS:ObjectName='ScaleFactor']/dts:Property[@DTS:Name='ParameterValue']" -v "$scaleFactor" $ssisPackage
xml ed -L -N dts="www.microsoft.com/SqlServer/Dts" -u "//dts:PackageParameter[@DTS:ObjectName='BasePath']/dts:Property[@DTS:Name='ParameterValue']" -v "$pwd\" $ssisPackage

# Measure total size and send to summary file
PowerShell -Command "Get-ChildItem -File $batchDir | Measure-Object -Property Length -Sum" > $summaryFile
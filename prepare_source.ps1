param (
    [int]$scaleFactor
)
$scriptsDir = ".\tpcdi-eel-ssis-mssql"
$sfBaseDir = ".\SF$scaleFactor"
$batchDir = "$sfBaseDir\Batch1"
$finwireDir = "$batchDir\_FINWIRE"
$eelDir = "$sfBaseDir\eel"
$ssisDir = "$sfBaseDir\ssis"
$ssisPackage = "$ssisDir\ingest.dtsx"
$summaryDir = "$scriptsDir\ingest-file-summary-eel"
$summaryFile = "$summaryDir\$scaleFactor.csv"

cd Tools
java -jar DIGen.jar -sf $scaleFactor -o ..\$sfBaseDir
cd ..

md $finwireDir
md $eelDir
md $ssisDir

# audit files not used
rm "$batchDir\*_audit.csv"

# Move FINWIRE files and concatenate to FINWIRE.fwf
mv "$batchDir\FINWIRE*" $finwireDir
cat "$finwireDir\*" > "$batchDir\FINWIRE.fwf"

# Copy eel files
cp "$scriptsDir\ingest-tpcdi-eel\*.*" $eelDir

# Copy SSIS package
cp "$scriptsDir\ssis_ingest.dtsx" $ssisPackage
xml ed -L -N dts="www.microsoft.com/SqlServer/Dts" -u "//dts:PackageParameter[@DTS:ObjectName='ScaleFactor']/dts:Property[@DTS:Name='ParameterValue']" -v "$scaleFactor" $ssisPackage
xml ed -L -N dts="www.microsoft.com/SqlServer/Dts" -u "//dts:PackageParameter[@DTS:ObjectName='BasePath']/dts:Property[@DTS:Name='ParameterValue']" -v "$pwd\" $ssisPackage

# Measure total size and send to summary file
PowerShell -Command "Get-ChildItem -File $batchDir | Measure-Object -Property Length -Sum" > $summaryFile
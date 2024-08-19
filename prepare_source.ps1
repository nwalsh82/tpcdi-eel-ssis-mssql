param (
    [int]$scaleFactor
)
$baseDir = ".\SF$scaleFactor"
$batchDir = "$baseDir\Batch1"
$finwireDir = "$batchDir\_FINWIRE"
$eelDir = "$baseDir\eel"
$summaryDir = ".\summary"
$summaryFile = "$summaryDir\$scaleFactor.csv"

cd Tools
java -jar DIGen.jar -sf $scaleFactor -o ..\$baseDir
cd ..

md $finwireDir
md $eelDir

# audit files not used
rm "$batchDir\*_audit.csv"

# Move FINWIRE files and concatenate to FINWIRE.fwf
mv "$batchDir\FINWIRE*" $finwireDir
cat "$finwireDir\*" > "$batchDir\FINWIRE.fwf"

# Copy eel files
cp "D:\Sync\repos\eel-Dis\tpcdi\eel\*.*" $eelDir

# Measure total size and send to summary file
PowerShell -Command "Get-ChildItem -File $batchDir | Measure-Object -Property Length -Sum" > $summaryFile
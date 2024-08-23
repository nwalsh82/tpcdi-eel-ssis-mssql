rm d:\ds\tpcdi-eel-ssis-mssql.zip
# this file is used to prepare the materials
zip -r d:\ds\tpcdi-eel-ssis-mssql.zip . -x end2end.ps1 README.md

cd d:/
# UNCOMMENT IF RE-RUNNING
Remove-Item -Path ".\tpcdi\" -Recurse -Force

# ABSOLUTE PATH OF DOWNLOADED TPC-DI HERE:
$tpcdi_zip = "D:\ds\670A9CFA-BC2E-4D43-9801-77011F8843B5-TPC-DI-Tool.zip"
# ABSOLUTE PATH OF MATERIALS tpcdi_eel_ssis_mssql.zip HERE:
$tpcdi_eel_ssis_mssql_zip = "D:\ds\tpcdi-eel-ssis-mssql.zip"
# PATH TO SQL SERVER 2022 INSTALLATION HERE, normally localhost or locahost\instance_name
$sql_server_2022_path = "localhost:51063"

# Define list of scalefactors
$scaleFactors = @(3, 9, 27, 81)
# Define the number of runs for each scalefactor
$runs = 4

mkdir tpcdi
cd tpcdi

unzip -q $tpcdi_eel_ssis_mssql_zip -d tpcdi-eel-ssis-mssql
unzip -q $tpcdi_zip

.\tpcdi-eel-ssis-mssql\00_prepare_and_execute.ps1 $sql_server_2022_path $scaleFactors $runs
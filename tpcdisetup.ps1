cd d:/
Remove-Item -Path ".\tpcdi\" -Recurse -Force

# ABSOLUTE PATH OF DOWNLOADED TPC-DI HERE:
$tpcdi_zip_dir = "D:\ds\670A9CFA-BC2E-4D43-9801-77011F8843B5-TPC-DI-Tool.zip"
mkdir tpcdi
cd tpcdi
cp D:\Sync\repos\tpcdi-eel-ssis-mssql\ . -r
unzip -q $tpcdi_zip_dir
# create prepare_source.ps1 script to process the source data by scale factor
.\tpcdi-eel-ssis-mssql\prepare_source.ps1 3
.\tpcdi-eel-ssis-mssql\prepare_source.ps1 9
.\tpcdi-eel-ssis-mssql\prepare_source.ps1 27


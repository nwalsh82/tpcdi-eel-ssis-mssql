cd d:/ #rem
Remove-Item -Path ".\tpcdi\" -Recurse -Force > $null 2>&1 #rem

# ABSOLUTE PATH OF DOWNLOADED TPC-DI HERE:
$tpcdi_zip_dir = "D:\ds\670A9CFA-BC2E-4D43-9801-77011F8843B5-TPC-DI-Tool.zip"
mkdir tpcdi
cd tpcdi
md summary
cp "D:\Sync\repos\eel-Dis\tpcdi\summary\__.eel.yml" .\summary
unzip -q $tpcdi_zip_dir
# create prepare_source.ps1 script to process the source data by scale factor
.\prepare_source.ps1 3
.\prepare_source.ps1 9
.\prepare_source.ps1 27
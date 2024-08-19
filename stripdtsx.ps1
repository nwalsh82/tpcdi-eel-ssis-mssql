# this script removes the DesignTimeProperties and PipelineLayout elements from a SSIS package XML file
[xml]$xml = Get-Content "d:\\sync\\repos\\ssis-tpc-di\\ssis-tpc-di\\Benchmark 1.dtsx"

# Define the namespace manager
$namespaceManager = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$namespaceManager.AddNamespace("DTS", "www.microsoft.com/SqlServer/Dts")

# Remove DesignTimeProperties
$xml.SelectNodes("//DTS:DesignTimeProperties", $namespaceManager) | ForEach-Object { $_.ParentNode.RemoveChild($_) }

# Remove PipelineLayout
$xml.SelectNodes("//DTS:PipelineLayout", $namespaceManager) | ForEach-Object { $_.ParentNode.RemoveChild($_) }

# Save the modified XML
$xml.Save("d:\\sync\\repos\\ssis-tpc-di\\ssis-tpc-di\\Benchmark_mod.dtsx")
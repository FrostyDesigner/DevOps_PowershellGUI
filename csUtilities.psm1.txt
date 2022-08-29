# Import PowerShell CmdLet script into Module
# Create a module and add PowerShell scripts into it using the $psScriptRoot automatic variable.

. $psScriptRoot\udf_GetFiles.ps1
. $psScriptRoot\udf_CountTransactions.ps1
. $psScriptRoot\udf_smoosh.ps1
. $psScriptRoot\udf_CreateFolders.ps1
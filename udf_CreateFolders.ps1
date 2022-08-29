<#
.SYNOPSIS
Creates folders in 6 locations across 2 servers, checks status, returns text update.

.DESCRIPTION
Creates folders in 6 locations across 2 servers, checks status, returns text update.

.EXAMPLE
Invoke-udf_CreateFolders

.NOTES
Function will ask for user input of client name.
#>

Function Invoke-udf_CreateFolders {
    BEGIN {      
        # $name = Read-Host 'What is the client name?'
    }
    PROCESS {
        mkdir \\sharename\TargetDirectory1\$name
        mkdir \\sharename\TargetDirectory2\$name
        mkdir \\sharename\TargetDirectory3\$name
        mkdir \\sharename\TargetDirectory4\$name
        mkdir \\sharename\TargetDirectory5\$name
        mkdir \\sharename\TargetDirectory6\$name
        if(Test-Path -Path \\sharename\TargetDirectory1\$name) {
            $dropProd = 'TargetDirectory1'
            $dropProdPath = "\\sharename\TargetDirectory1\$name"
        }else {
            $dropProdPath = "TargetDirectory1 Folder does not exist!!"
        }
        if(Test-Path -Path \\sharename\CSIApplications\TargetDirectory2\$name) {
            $archiveProd = "TargetDirectory2"
            $archiveProdPath = "\\sharename\CSIApplications\TargetDirectory2\$name"
        }else {
            $archiveProdPath = "TargetDirectory2 Folder does not exist!!"
        }
        if(Test-Path -Path \\sharename\TargetDirectory3\$name) {
            $deliveryProd = "TargetDirectory3"
            $deliveryProdPath = "\\sharename\TargetDirectory3\$name"
        }else {
            $deliveryProdPath = "TargetDirectory3 Folder does not exist!!"
        }
        if(Test-Path -Path \\sharename\TargetDirectory4\$name) {
            $dropTest = "TargetDirectory4"
            $dropTestPath = "\\sharename\TargetDirectory4\$name"	
        }else {
           $dropTestPath = "TargetDirectory4 Folder does not exist!!"
        }
        if(Test-Path -Path \\sharename\TargetDirectory5\$name) {
            $archiveTest = "TargetDirect5ory"
            $archiveTestPath = "\\sharename\TargetDirectory5\$name"
        }else {
           $archiveTestPath = "TargetDirectory5 Folder does not exist!!"
        }
        if(Test-Path -Path \\sharename\TargetDirectory6\$name) {
            $deliveryTest = "TargetDirectory6"
            $deliveryTestPath =  "\\sharename\TargetDirectory6\$name"
        }else {
           $deliveryTestPath = "TargetDirectory6 Folder does not exist!!"
        }
    }        
    END {
            $qText = "$dropProd
$dropProdPath
$archiveProd 
$archiveProdPath 
$deliveryProd 
$deliveryProdPath 
$dropTest 
$dropTestPath 
$archiveTest 
$archiveTestPath 
$deliveryTest
$deliveryTestPath"
            Set-Clipboard -Value $qText

            [System.Windows.MessageBox]::Show($qText, "The following query has been copied to the clipboard")
        }
    }

#region Execution examples

#endregion




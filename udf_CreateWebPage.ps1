<#
.SYNOPSIS
Provides client information based on the provided data.
.DESCRIPTION
Provides client information based on the provided data.

Step 1 is to rename the parameters to match your script

.PARAMETER root_id
root id of account
#>

#CSS codes
$header = @"
<style>

    h1 {
        font-family: Arial, Helvetica, sans-serif;
        color: #e68a00;
        font-size: 28px;
    }    
    h2 {
        font-family: Arial, Helvetica, sans-serif;
        color: #000099;
        font-size: 16px;
    } 
   table {
		font-size: 12px;
		border: 0px; 
		font-family: Arial, Helvetica, sans-serif;
	} 	
    td {
		padding: 4px;
		margin: 0px;
		border: 0;
	}	
    th {
        background: #395870;
        background: linear-gradient(#49708f, #293f50);
        color: #fff;
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 15px;
        vertical-align: middle;
	}
    tbody tr:nth-child(even) {
        background: #f0f0f2;
    }
    #CreationDate {
        font-family: Arial, Helvetica, sans-serif;
        color: #ff3300;
        font-size: 12px;
    }
    .StopStatus {
        color: #ff0000;
    }
    .RunningStatus {
        color: #008000;
    }
</style>
"@

Function Invoke-udf_CreateWebPage {  

    BEGIN {

        Import-Module "C:\Users\ps.user12\Documents\CustomPowershell\csUtilities.psm1.txt" -force 
    }
    PROCESS { 
        if ($gridView.IsPresent) {
        #get the SLU count by division by month for the last 90 days
        $TransactionCount = Invoke-udf_CountTransactions | ConvertTo-Html -Property TransactionID,ProductID,ReferenceOrderID,ReferenceOrderLineID,TransactionDate,TransactionType,Quantity,ActualCost,ModifiedDate -Fragment -PreContent "<h2>Transaction Count by Division Last 180 Days</h2>"

        $ph_smoosh = "<h1>$root_id smoosh</h1>"
        #The command below will combine all the information gathered into a single HTML report
        $Report = ConvertTo-HTML -Body "$TransactionCount" -Head $header -Title "Transaction Report" -PostContent "<p id='CreationDate'>Creation Date: $(Get-Date)</p>"
        #declare file full path
        $outputFullPath = "D:\Temp\CustomerSupport\$($root_id)_wd_smoosh.html"
        #The command below will generate the report to an HTML file
        $Report | Out-File $outputFullPath

        # open the following items
        Invoke-Item "D:\Temp\CustomerSupport"
        Invoke-Item $outputFullPath
        # Invoke-Item $report_user_FullPath
        # Invoke-Item $report_batch_config_FullPath
        # Invoke-Item $report_usage_counts_FullPath
        }   
    }        
    END { 
        Write-Output "Complete"
        Write-Output "Documents created at 'D:\Temp\CustomerSupport'."
    }
    }

#region Execution examples

#endregion
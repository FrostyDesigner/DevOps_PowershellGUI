<#
.SYNOPSIS
Finds trigger files based on the client_id. Searches all triggers in the target directory Customer.Master folders.

.DESCRIPTION
Finds trigger files based on the client_id. Searches all triggers in the target directory Customer.Master folders.

.PARAMETER clientID
client GUID

.PARAMETER rootID
client GUID
#>

Function Invoke-udf_GetFiles {

    BEGIN {

        $Path = "\\Sharename\Deploy\TargetFolder"
        $PathArray = @()        

        $tbl = New-Object System.Data.DataTable "TriggerFiles"
        $col1 = New-Object System.Data.DataColumn ClientId
        $col2 = New-Object System.Data.DataColumn DirectoryName
        $col3 = New-Object System.Data.DataColumn BaseName
        $col4 = New-Object System.Data.DataColumn FullName
        $col5 = New-Object System.Data.DataColumn ThreshholdOverride
        $col6 = New-Object System.Data.DataColumn CountryDq
        $col7 = New-Object System.Data.DataColumn Lists
        $tbl.Columns.Add($col1)
        $tbl.Columns.Add($col2)
        $tbl.Columns.Add($col3)
        $tbl.Columns.Add($col4)
        $tbl.Columns.Add($col5)
        $tbl.Columns.Add($col6)
        $tbl.Columns.Add($col7)

    }
    PROCESS {    

        if ($PSCmdlet.ParameterSetName -eq "ClientID") {
            # This code snippet gets all the files in $Path that end in ".trm".
            Get-ChildItem $Path -Filter "*.xml" -Recurse |
            Where-Object { $_.Attributes -ne "Directory"} |
            ForEach-Object {
                If (Get-Content $_.FullName | Select-String -Pattern $client_ID) {
                    # $PathArray += $_.FullName
                    $PathArray += $_
                }
            }

            $PathArray | 
            ForEach-Object {
                $row = $tbl.NewRow()
                $row.ClientId = $client_ID
                $row.DirectoryName = $_.DirectoryName
                $row.BaseName = $_.BaseName
                $row.FullName = $_.FullName
                $rtd = ReadTrigger($_.Fullname)
                $row.ThreshholdOverride = $rtd.thOverride
                $row.CountryDq = $rtd.countryDq
                $row.Lists = $rtd.listData
                $tbl.Rows.Add($row)
            }
        }
        if ($PSCmdlet.ParameterSetName -eq "RootId") {   
            $fish = Invoke-wdClient_GetDivisionIds -root_id $root_id | Select-Object -ExpandProperty client_id
            foreach ($item in $fish) {
                # This code snippet gets all the files in $Path that end in ".trm".
                Get-ChildItem $Path -Filter "*.xml" -Recurse |
                Where-Object { $_.Attributes -ne "Directory"} |
                ForEach-Object {
                    If (Get-Content $_.FullName | Select-String -Pattern $item) {
                        $PathArray += $_
                    }
                }

                $PathArray | 
                ForEach-Object {
                    $row = $tbl.NewRow()
                    $row.ClientId = $item
                    $row.DirectoryName = $_.DirectoryName
                    $row.BaseName = $_.BaseName
                    $row.FullName = $_.FullName
                    
                    $rtd = ReadTrigger($_.Fullname)
                    $row.ThreshholdOverride = $rtd.thOverride
                    $row.CountryDq = $rtd.countryDq
                    $row.Lists = $rtd.listData
                    $tbl.Rows.Add($row)
                }
            }
        }


        # $tbl
    }        
    END {            
        if ($queryView.IsPresent) {
            [System.Windows.MessageBox]::Show("There is no SQL query for this mode.")
        }  
        if ($report.IsPresent) {        
            # $tbl | Out-GridView           
            $tbl         
        }  
        if ($gridView.IsPresent) {
            $tbl | Out-GridView            
        }        
        if ($csvExport.IsPresent) {
            $tbl | Export-CSV "C:\Users\Public\Documents\$(get-date -f yyyy-MM-dd)_Export.csv" -NoTypeInformation  
        }        
        if ($dropTrigger.IsPresent) {
            $tbl | Out-GridView -Title "Select Trigger to Drop" -PassThru | Select-Object -ExpandProperty Fullname | Copy-Item -Destination "\\Sharename\Deploy\List.Updates\Customer.Master\Queued_Test"
        }        
        if ($openTrigger.IsPresent) {
            $tbl | Out-GridView -Title "Select Trigger to Open" -PassThru | Select-Object -ExpandProperty Fullname | Invoke-Item
        }  
    }
    }

    #Invoke-wdCDM_GetTriggers -client_ID 6793



function ReadTrigger {
    param (    
        $xmlFilePath
    )

    # $xmlFilePath = "C:\Users\ps.user12\Desktop\CustMast_Client-EBAY_7.trm"

    $value = "" | Select-Object -Property thOverride, countryDq, listData

    [xml]$xmlData = Get-Content -Path $xmlFilePath

    $value.thOverride = $xmlData.Ticket.ThresholdOverride

    $value.countryDq = $xmlData.Ticket.CountryDisqualification

    $clientIds = $xmlData.Ticket.ClientIDs.Client
    foreach ($item in $clientIds)
    {
        $clientId = $item.InnerText
    }

    $clientLists = $xmlData.Ticket.Lists.DataList
    $listArray = @()
    foreach ($item in $clientLists)
    {
        $listArray += $item.InnerText
    }

    $sb = [System.Text.StringBuilder]::new()
    foreach ($item in $listArray)
    {
        [void]$sb.Append( "$item, " )
    }
    $listData = $sb.ToString()
    $listData = $listData.Substring(0,$sb.Length - 2)
    $value.listData = $listData

    Return $value    
}


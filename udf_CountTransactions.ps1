<#
.SYNOPSIS
Returns total count of transactions based on the client_id.

.DESCRIPTION
Returns total count of transactions based on the client_id.
#>

Function Invoke-udf_CountTransactions {

    BEGIN {        
        $Query = "
        USE AdventureWorks2017
        SELECT TOP (1000) [TransactionID]
        ,[ProductID]
        ,[ReferenceOrderID]
        ,[ReferenceOrderLineID]
        ,[TransactionDate]
        ,[TransactionType]
        ,[Quantity]
        ,[ActualCost]
        ,[ModifiedDate]
        FROM [AdventureWorks2017].[Production].[TransactionHistory]
        "

        $connString = "data source=DESKTOP-GPVK3T9;Initial catalog=WDBatch;Integrated Security=True;"
        $SqlConnection = new-object System.Data.SqlClient.SqlConnection
        $SqlConnection.ConnectionString = $connString
        $SqlCommand = $SqlConnection.CreateCommand()
        $SqlCommand.CommandText = $Query
        $DataAdapter = new-object System.Data.SqlClient.SqlDataAdapter $SqlCommand
        $dataset = new-object System.Data.Dataset           
    }
    PROCESS {
            $DataAdapter.Fill($dataset)
            $Results = $dataset.Tables[0]
            $Results | Out-GridView -Title "SLU Count Export"
        }
    }         
    END { 
        Write-Output "Complete."
    }
    
    
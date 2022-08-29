Add-Type -AssemblyName PresentationFramework

$currentUser = [System.Environment]::UserName

Import-Module "C:\Users\currentUser\Documents\CustomPowershell\PowershellGUI\csUtilities.psm1" -Force
$xamlFile = "C:\Users\currentUser\Documents\CustomPowershell\PowershellGUI\DevOpsPalette.xaml"


$inputXAML = Get-Content $xamlFile -Raw
$inputXAML = $inputXAML -replace 'mc:Ignorable="d"','' -replace "x:N", "N" -replace '^<Win.*','<Window'
[XML]$XAML = $inputXAML

$reader = New-Object System.Xml.XmlNodeReader $XAML

try {
    $psform = [Windows.Markup.XamlReader]::Load($reader)
}
catch {
    Write-Host $_.Exception
    throw
}


$XAML.SelectNodes("//*[@Name]") | ForEach-Object {
    try {
        Set-Variable -Name "var_$($_.Name)" -Value $psform.FindName($_.Name) -ErrorAction Stop
    }
    catch {
        Write-Host $_.Exception
        throw
    }
}

Get-Variable var_*

$customerSupportPSCommand

function GetUserInput {

    $userInput = $var_txtInput.Text

    $valueTres = $userInput 

    return $valueTres
}

function calculation {
    param ($value)
    "Please wait. Working on calculation..."
    $value += 73
    return $value
}

$var_btnGetFiles.Add_Click(
    {
        [System.Windows.MessageBox]::Show("Invoke-udf_GetFiles")
        Invoke-Expression -Command "Invoke-udf_GetFiles"
    }
)

$var_btnCountTransactions.Add_Click(
    {     
        [System.Windows.MessageBox]::Show("Invoke-udf_CountTransactions")
        Invoke-Expression -Command "Invoke-udf_CountTransactions"
    }
)

$var_btnCreateWebPage.Add_Click(
    {     
        [System.Windows.MessageBox]::Show("Invoke-udf_CreateWebPage")
        Invoke-Expression -Command "Invoke-udf_CreateWebPage"
    }
)

$var_btnCreateFolders.Add_Click(
    {     
        [System.Windows.MessageBox]::Show("btnCreateFolders")
        Invoke-Expression -Command "Invoke-udf_CreateFolders"
    }
)

$psform.ShowDialog()
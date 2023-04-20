
Function Get-Reason {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
	Param(
		[Parameter(
            Mandatory=$True,
            ParameterSetName="1-Input",
            Position=1,
            HelpMessage="You can enter a pattern that contains alphabet characters, space, dash, and/or periods as long as it is at least one character and does not start, end, or consist only of space, dash, or periods."
        )]
        [ValidatePattern('^(?![ .-])[a-zA-Z .-]{1,100}(?<![ .-])$')]
		[string]$Reason
	)
    Begin {
        # Variables
        $Log = '{0}\Log.csv' -f $env:TEMP
    }
    Process {
        $Columns = [PSCustomObject]@{
            Computer = $env:COMPUTERNAME
            Account  = $env:USERNAME
            Time     = (Get-Date).ToString('yyyyMMdd_HHmm')
            Reason   = $Reason
        }
        Write-Output -InputObject $Columns | Export-Csv -Path $Log -NoTypeInformation -Verbose -Append
    }
    End {
        [System.GC]::Collect()
    }
}

Function Invoke-Popup {
    [CmdletBinding()]
    param(
    	[Parameter(
            Mandatory=$True,
            ValueFromPipeline
        )]
        [string]$Message
    )
    Process {
        Add-Type -AssemblyName PresentationCore, PresentationFramework
        $ButtonType = [System.Windows.MessageBoxButton]::YesNoCancel
        $MessageIcon = [System.Windows.MessageBoxImage]::Error
        $MessageTitle = "Confirm Deletion"
        $Result = [System.Windows.MessageBox]::Show($Message,$MessageTitle,$ButtonType, $MessageIcon)
        Update-MxLog
    }
}

Function Update-MxLog {
    Remove-Variable -Name Reason, Prompt, Result, Message -Verbose -Force -ErrorAction Ignore
    $Prompt = Show-Command -Name Get-Reason -PassThru -NoCommonParameter -ErrorPopup
    
    Try { 
        Invoke-Expression -Command $Prompt
    }
    Catch{
        $Message = Write-Output -InputObject $_.Exception.Message
        $Message | Invoke-Popup
    }
}

$Error.Clear(); Clear-Host
Update-MxLog
Import-Csv -Path "$env:TEMP\Log.csv" | Out-GridView -Title 'The results'

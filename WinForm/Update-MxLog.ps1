<#
    Reference:
        * https://learn.microsoft.com/en-us/powershell/scripting/samples/creating-a-custom-input-box?view=powershell-7.2
        * https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-powershell-1.0/ff730941(v=technet.10)?redirectedfrom=MSDN
#>

# Reset variable
Remove-Variable -Name reason -Verbose -Force -ErrorAction SilentlyContinue
        
Add-Type -AssemblyName 'System.Windows.Forms', 'System.Drawing' -Verbose

########
# FORM #
########
$BTN_OK = New-Object -TypeName System.Windows.Forms.Button
$BTN_OK.Location = New-Object -TypeName System.Drawing.Point(75,120)
$BTN_OK.Size = New-Object -TypeName System.Drawing.Size(75,23)
$BTN_OK.Text = 'OK'
$BTN_OK.DialogResult = [System.Windows.Forms.DialogResult]::OK

$BTN_CANCEL = New-Object -TypeName System.Windows.Forms.Button
$BTN_CANCEL.Location = New-Object -TypeName System.Drawing.Point(150,120)
$BTN_CANCEL.Size = New-Object System.Drawing.Size(75,23)
$BTN_CANCEL.Text = 'Cancel'
$BTN_CANCEL.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

$LBL_REASON = New-Object -TypeName System.Windows.Forms.Label
$LBL_REASON.Location = New-Object -TypeName System.Drawing.Point(10,20)
$LBL_REASON.Size = New-Object -TypeName System.Drawing.Size(280,20)
$LBL_REASON.Text = 'What is your reason for administrative login?'

$TB_Field1 = New-Object -TypeName System.Windows.Forms.TextBox
$TB_Field1.Location = New-Object -TypeName System.Drawing.Point(10,40)
$TB_Field1.Size = New-Object -TypeName System.Drawing.Size(260,20)

$Form = New-Object -TypeName System.Windows.Forms.Form
$Form.Text = 'Maintenance Log Entry'
$Form.Size = New-Object -TypeName System.Drawing.Size(300,200)
$Form.StartPosition = 'CenterScreen'
$Form.AcceptButton = $BTN_OK
$Form.CancelButton = $BTN_Cancel

$ALL_OBJ = @(
    $BTN_OK
    $BTN_CANCEL
    $LBL_REASON
    $TB_Field1
)
$Form.Controls.AddRange($ALL_OBJ)
$form.TopMost = $true

$result = $Form.ShowDialog()

If ($result -eq [System.Windows.Forms.DialogResult]::OK){
    $reason = $TB_Field1.Text
    $reason
}

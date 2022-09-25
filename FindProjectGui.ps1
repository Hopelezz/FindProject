
# TODO: Add Try Catch.
# TODO: Add list Limit
# TODO: Hide Terminal on Load
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

function Show-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()

    # Hide = 0,
    # ShowNormal = 1,
    # ShowMinimized = 2,
    # ShowMaximized = 3,
    # Maximize = 3,
    # ShowNormalNoActivate = 4,
    # Show = 5,
    # Minimize = 6,
    # ShowMinNoActivate = 7,
    # ShowNoActivate = 8,
    # Restore = 9,
    # ShowDefault = 10,
    # ForceMinimized = 11

    [Console.Window]::ShowWindow($consolePtr, 4)
}

function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}

# Create a gui that will allow the user to select a file and then copy that file to a new location based on user input. Then delete the file from the current location
Add-Type -AssemblyName System.Windows.Forms

function Search-Project {
    # Defines Default Project Path
    $contract = "E:\CodeBase\"
    
    # Get Input for query from QueryTextBox
    $projectName = $SearchBox.text
    IF ($projectName.Length -lt 3) {} ELSE {
        # Filters for F folders only
        $filter = "F"+"*"+$projectName+"*"

        # Get Items
        $items = Get-ChildItem -Recurse -filter $filter -Directory -Path $contract -Depth 1 

        # show results to listbox
        foreach( $item in $items){
            $ListBox.Items.Add($item.FullName)
        }
        
        # Start Command for selected item
        if ($GuiForm -eq [System.Windows.Forms.DialogResult]::OK -and $ListBox.SelectedIndex) {
            Start-Process  $ListBox.SelectedItem
        }
    }
}

# Defines the form elements
$FormObject = [System.Windows.Forms.Form]
$ButtonObject = [System.Windows.Forms.Button]
$LabelObject = [System.Windows.Forms.Label]
$TextBoxObject = [System.Windows.Forms.TextBox]
$ListBoxObject = [System.Windows.Forms.ListBox]

# Create Base Form
$GuiForm = New-Object $FormObject
    $GuiForm.ClientSize = New-Object System.Drawing.Size(500, 300)
    $GuiForm.Text = "Search Project Application"
    $GuiForm.StartPosition = "CenterScreen"
    $GuiForm.BackColor = "White"
    Hide-Console

# Label for input Box
$QueryLabel = New-Object $LabelObject
    $QueryLabel.Text = "Enter Project Name or Number."
    $QueryLabel.AutoSize = $true
    $QueryLabel.Location = New-Object System.Drawing.Point(20, 20)
    $QueryLabel.Font = 'Arial, 13, style=Bold'

# Create an input box for the user to enter the project name or number
$SearchBox = New-Object $TextBoxObject
    $SearchBox.Location = New-Object System.Drawing.Point(20, 50)
    $SearchBox.Size = New-Object System.Drawing.Size(460, 20)
    $SearchBox.Font = 'Arial, 10, style=Bold'
    $SearchBox.Anchor = [System.Windows.Forms.AnchorStyles]::Left -bor
    [System.Windows.Forms.AnchorStyles]::Right -bor
    [System.Windows.Forms.AnchorStyles]::Top

# Create a button to search for the project
$SearchButton = New-Object $ButtonObject
    $SearchButton.Text = "Search"
    $SearchButton.Location = New-Object System.Drawing.Point(20, 80)
    $SearchButton.AutoSize = $true

# If button is clicked, run the function to search for text in the QueryTextBox
    $SearchButton.add_Click({
        Search-Project -ProjectName $SearchBox.Text
    })

    $SearchBox.Add_KeyDown({
        if ($_.KeyCode -eq "Enter") {
            #logic
            $SearchButton.PerformClick()
        }
    })

# Return the results to a listbox
$ListBox = New-Object $ListBoxObject
    $ListBox.Location = New-Object System.Drawing.Point(20, 120)
    $ListBox.Size = New-Object System.Drawing.Size(460, 150)
    $ListBox.Font = 'Arial, 10'
    $ListBox.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
    [System.Windows.Forms.AnchorStyles]::Left -bor
    [System.Windows.Forms.AnchorStyles]::Right -bor
    [System.Windows.Forms.AnchorStyles]::Top
    $ListBox.add_Click({
        Start-Process  $ListBox.SelectedItem
    })

$ClearButton = New-Object $ButtonObject
    $ClearButton.Location = New-Object System.Drawing.Point(100, 80)
    $ClearButton.AutoSize = $true
    $ClearButton.Text = 'Clear'
    $ClearButton.add_Click({$ListBox.Items.Clear();})

$OpenButton = New-Object $ButtonObject
    $OpenButton.Location = New-Object System.Drawing.Point(180, 80)
    $OpenButton.AutoSize = $true
    $OpenButton.Text = 'Open'
    $OpenButton.add_Click({Start-Process  $ListBox.SelectedItem})
    
$GuiForm.Controls.Add($QueryLabel)
$GuiForm.Controls.Add($SearchBox)
$GuiForm.Controls.Add($SearchButton)
$GuiForm.Controls.Add($ListBox)
$GuiForm.Controls.Add($ClearButton)
$GuiForm.Controls.Add($OpenButton)

# Display the form
$GuiForm.ShowDialog()

# Cleans up the form
$GuiForm.Dispose()
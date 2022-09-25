# TODO: Add list Limit

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

# Function Show-Console is only used on Error.
function Show-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 4)
    # A list of functions to control the console window
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
}

function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #Set consolePtr to 0 to hide the console window
    [Console.Window]::ShowWindow($consolePtr, 0)
}

# Create a gui that will allow the user to select a file and then copy that file to a new location based on user input. Then delete the file from the current location
Add-Type -AssemblyName System.Windows.Forms

# Try to run Search-Project
try
{
    function Search-Project {
        # Defines Default Project Path
        $defaultPath = "E:\CodeBase\"  # Change to local folder
        
        # Get Input for query from QueryTextBox
        $projectName = $SearchBox.text
        if ($projectName.Length -lt 3) {
            # Show Warning label
            $WarningLabel.Text = "Input must contain at least 3 characters"
            $WarningLabel.Visible = $true
        } else {
            # Filters inside F folders only
            # $filter = "F"+"*"+$projectName+"*"

            $filter = $projectName+"*"
    
            # Get Items
            $items = Get-ChildItem -Recurse -filter $filter -Directory -Path $defaultPath -Depth 1 
            
            
            $items | Sort-Object -Property Name | ForEach-Object {
                $ListBox.Items.Add($_.FullName)
            }

            # Sort ListBox alphanumerically
            $ListBox.Sorted = $true

            # If no items are found, show warning label
            if ($ListBox.Items.Count -eq 0) {
                $WarningLabel.Text = "No folders found"
                $WarningLabel.Visible = $true
            } else {
                $WarningLabel.Visible = $false
            }
            
            # Start Command for selected item
            if ($GuiForm -eq [System.Windows.Forms.DialogResult]::OK -and $ListBox.SelectedIndex) {
                Start-Process  $ListBox.SelectedItem
            }
        }
    }
}
catch {
    # If Search-Project fails, then show the console and display the error
    Show-Console
    Write-Error $_.Exception
    Read-Host
}

# Defines the form element variables
$FormObject = [System.Windows.Forms.Form]
$ButtonObject = [System.Windows.Forms.Button]
$LabelObject = [System.Windows.Forms.Label]
$TextBoxObject = [System.Windows.Forms.TextBox]
$ListBoxObject = [System.Windows.Forms.ListBox]

# Creates Base Form
$GuiForm = New-Object $FormObject
    $GuiForm.ClientSize = New-Object System.Drawing.Size(700, 300)
    $GuiForm.Text = "Find Project"
    $GuiForm.StartPosition = "CenterScreen"
    $GuiForm.BackColor = "White"

# Function call to hide console when ran
    Hide-Console

# Label for input Box
$SearchLabel = New-Object $LabelObject
    $SearchLabel.Text = "Enter Project Name or Number."
    $SearchLabel.AutoSize = $true
    $SearchLabel.Location = New-Object System.Drawing.Point(20, 10)
    $SearchLabel.Font = 'Arial, 13, style=Bold'

# Create an input box for the user to enter the project name or number
$SearchBox = New-Object $TextBoxObject
    $SearchBox.Location = New-Object System.Drawing.Point(20, 40)
    $SearchBox.Size = New-Object System.Drawing.Size(660, 20)
    $SearchBox.Font = 'Arial, 13'
    # Anchors the input box to the bottom, Left, & Right border
    $SearchBox.Anchor = [System.Windows.Forms.AnchorStyles]::Left -bor
    [System.Windows.Forms.AnchorStyles]::Right -bor
    [System.Windows.Forms.AnchorStyles]::Top

$WarningLabel = New-Object $LabelObject
    $WarningLabel.Text = ""
    $WarningLabel.AutoSize = $true
    $WarningLabel.Location = New-Object System.Drawing.Point(20, 70)
    $WarningLabel.Font = 'Arial, 10, style=Bold'
    $WarningLabel.ForeColor = 'Red'
    # Hide Warning label by default
    $WarningLabel.Visible = $false

# Create a button to search for the project
$SearchButton = New-Object $ButtonObject
    $SearchButton.Text = "Search"
    $SearchButton.Location = New-Object System.Drawing.Point(20, 90)
    $SearchButton.AutoSize = $true
    # If button is clicked, run the function to search for text in the QueryTextBox
    $SearchButton.add_Click({
        $ListBox.Items.Clear();
        Search-Project -ProjectName $SearchBox.Text
    })
    # if enter is pressed, click the search button
    $SearchBox.Add_KeyDown({
        if ($_.KeyCode -eq "Enter") {
            $SearchButton.PerformClick()
        }
    })

$ClearButton = New-Object $ButtonObject
    $ClearButton.Location = New-Object System.Drawing.Point(100, 90)
    $ClearButton.AutoSize = $true
    $ClearButton.Text = 'Clear'
    # If button is clicked, clear the WarningLabel, SearchBox, and ListBox
    $ClearButton.add_Click({
        $ListBox.Items.Clear();
        $SearchBox.Text = ""
        $WarningLabel.Visible = $false
    })
  
# Return the results to a listbox
$ListBox = New-Object $ListBoxObject
    $ListBox.Location = New-Object System.Drawing.Point(20, 120)
    $ListBox.Size = New-Object System.Drawing.Size(660, 150)
    $ListBox.Font = 'Arial, 10'
    $ListBox.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
    [System.Windows.Forms.AnchorStyles]::Left -bor
    [System.Windows.Forms.AnchorStyles]::Right -bor
    [System.Windows.Forms.AnchorStyles]::Top
    # Double click to open the selected item
    $ListBox.add_DoubleClick({
        Start-Process  $ListBox.SelectedItem
    })
    # Enter to open the selected item
    $ListBox.add_KeyDown({
        if ($_.KeyCode -eq "Enter") {
            Start-Process  $ListBox.SelectedItem
        }
    })

# Add all the elements to the form
$GuiForm.Controls.Add($SearchLabel)
$GuiForm.Controls.Add($SearchBox)
$GuiForm.Controls.Add($WarningLabel)
$GuiForm.Controls.Add($SearchButton)
$GuiForm.Controls.Add($ClearButton)
$GuiForm.Controls.Add($ListBox)

# Display the form
$GuiForm.ShowDialog()

# Cleans up the form
$GuiForm.Dispose()
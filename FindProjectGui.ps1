# Change these to match your environment
# Defines Default Folder Path
$dirPath = "E:\" 
# Defines Visual Studio Path
$VSPath = "C:\Users\panze\AppData\Local\Programs\Microsoft VS Code\Code.exe" 

# Adds console controls to the script
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
# Adds a Form to the Console Window
Add-Type -AssemblyName System.Windows.Forms
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Defines the Functionality of the Code.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
FUNCTION Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #Set consolePtr to 0 to hide the console window
    [Console.Window]::ShowWindow($consolePtr, 0)
}
FUNCTION Show-Console # Function Show-Console is only used on Error.
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
FUNCTION Search-Project {
    $projectName = $SearchBox.text # Get Input for query from SearchBox
    IF($projectName.Length -lt 3) {
        # Display Warning label
        $WarningLabel.Text = "Input must contain at least 3 characters"
        $WarningLabel.Visible = $true
    } ELSE {
        #Filter for folders and add to listbox
        $filter = "*"+$projectName+"*"
        $items = Get-ChildItem -Recurse -filter $filter -Directory -Path $dirPath -Depth 2
        $items | ForEach-Object {
            $ListBox.Items.Add($_.FullName)
        }
        # Sort ListBox alphanumerically
        $ListBox.Sorted = $true
        # If no items are found, show warning label
        IF($ListBox.Items.Count -eq 0) {
            $WarningLabel.Text = "No folders found"
            $WarningLabel.Visible = $true
        } ELSE {
            $WarningLabel.Visible = $false
        }
    }
}

# function Search-Tree {
# TODO: Add a function to Search Tree.txt instead of Get-ChildItem
# }

# Function will once a day check tree structure of the directory
# function FindTree {
#     $date = Get-Date -Format "yyyy-MM-dd"
#     $treePath = $dirPath + "Tree.txt"
#     IF(Test-Path $treePath) {
#         $fileDate = Get-Date (Get-Item $treePath).LastWriteTime -Format "yyyy-MM-dd"
#         IF($fileDate -ne $date) {
#             Get-ChildItem -Path $dirPath -Recurse -Directory | Select-Object FullName | Out-File $treePath
#         }
#     } ELSE {
#         Get-ChildItem -Path $dirPath -Recurse -Directory | Select-Object FullName | Out-File $treePath
#     }
# }
# 
# FindTree # Call FindTree function


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# The following code is used to create a GUI for the script.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Defines the form element variables
$FormObject = [System.Windows.Forms.Form]
$ButtonObject = [System.Windows.Forms.Button]
$LabelObject = [System.Windows.Forms.Label]
$TextBoxObject = [System.Windows.Forms.TextBox]
$ListBoxObject = [System.Windows.Forms.ListBox]
$ContextMenuObject = [System.Windows.Forms.ContextMenu]
$MenuItemObject = [System.Windows.Forms.MenuItem]

# Creates Base Form
$GuiForm = New-Object $FormObject
    $GuiForm.ClientSize = New-Object System.Drawing.Size(700, 300)
    $GuiForm.Text = "Find Folder"
    $GuiForm.StartPosition = "CenterScreen"
    $GuiForm.BackColor = "White"

# Function call to hide console when ran
Hide-Console

# Sets the Favicon using a icon thats converted to base64.
# Due to the character length of the icon, is stored in a seperate txt file.
$text = Get-Content -Path: .\icon.txt -Raw
$iconBase64 = $text
    $iconBytes       = [Convert]::FromBase64String($iconBase64)
    # initialize a Memory stream holding the bytes
    $stream = [System.IO.MemoryStream]::new($iconBytes, 0, $iconBytes.Length)
    $GuiForm.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))
    
# Label for input Box
$SearchLabel = New-Object $LabelObject
    $SearchLabel.Text = "Enter Folder Name:"
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
        TRY {
            Search-Project -ProjectName $SearchBox.Text
        } CATCH {
            # If Search-Project fails, then show the console and display the error
            Show-Console
            Write-Error $_.Exception
            Read-Host
        }
    })
    # if enter is pressed, click the search button
    $SearchBox.Add_KeyDown({
        TRY {
            IF($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {
                $SearchButton.PerformClick()
            }
            # If CTRL+Enter is pressed set dirPath to C:\ and click the search button
            IF($_.KeyCode -eq "Enter" -and $_.Control) {
                $dirPath = "C:\"
                $SearchButton.PerformClick()
            }
        } CATCH {
            # If Search-Project fails, then show the console and display the error
            Show-Console
            Write-Error $_.Exception
            Read-Host
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
        TRY {
            Start-Process  $ListBox.SelectedItem
        } CATCH {
            # If Start-Process fails, then show the console and display the error
            Show-Console
            Write-Error $_.Exception
            Read-Host
        }
    })
    # Enter to open the selected item
    $ListBox.add_KeyDown({
        IF($_.KeyCode -eq "Enter") {
            TRY {
                Start-Process  $ListBox.SelectedItem
            } CATCH {
                # If Start-Process fails, then show the console and display the error
                Show-Console
                Write-Error $_.Exception
                Read-Host
            }
        }
    })
    # Rightclick menu to select item and open context menu 
    $ListBox.add_MouseDown({
        IF($_.Button -eq "Right") {
            $ListBox.SelectedIndex = $ListBox.IndexFromPoint($_.Location)
            IF($ListBox.SelectedIndex -ne -1){
                # Define the Menu Objects
                $contextmenuService = New-Object $ContextMenuObject
                $OpenWithVSCode = New-Object $MenuItemObject
                $OpenWithVSCode.Text = "Open With VSCode"
                $OpenToFolder = New-Object $MenuItemObject
                $OpenToFolder.Text = "Open To Folder"
                # Defines the Context menu within the listbox
                $ListBox.ContextMenu = $contextmenuService
                # Add Items to the Context Menu
                $contextmenuService.MenuItems.Add($OpenWithVSCode)  # Add the VSCode menu item
                $contextmenuService.MenuItems.Add('-') # Adds a seperator
                $contextmenuService.MenuItems.Add($OpenToFolder) # Add the Folder Properties menu item
            } ELSEIF($ListBox.SelectedIndex -eq -1) {
                $ListBox.ContextMenu = $null    # If no item is selected, then remove the context menu
            }
            # If VSCode is selected, then open the selected item in VSCode
            $OpenWithVSCode.add_Click({
                TRY{
                    # Need to 
                    Start-Process -FilePath $VSPath $ListBox.SelectedItem
                } CATCH {
                    # If Start-Process fails, then show the console and display the error
                    Show-Console
                    Write-Error $_.Exception
                    Read-Host
                }
            })
            # If Folder Properties is selected, then open the selectedItem Folder Properties
            $OpenToFolder.add_Click({
                TRY {
                    $FolderPath = $ListBox.SelectedItem
                    Start-Process -FilePath explorer.exe "/select, $FolderPath"
                   } CATCH {
                    # If Start-Process fails, then show the console and display the error
                    Show-Console
                    Write-Error $_.Exception
                    Read-Host
                }
            })
        }
    })

# Adds all the elements to the form
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
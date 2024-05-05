# Author: Mark Spratt
# Date: 2024-05-05
# Description: A simple file and folder search tool using PowerShell and WinForms

# Import necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$font = New-Object System.Drawing.Font("Microsoft Sans Serif", 10, [System.Drawing.FontStyle]::Regular)

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Seeker"
$form.Size = New-Object System.Drawing.Size(600, 350)
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")
$form.Icon = $icon
# Create padding on form
$form.Padding = New-Object System.Windows.Forms.Padding(5)

# Create a grid layout
$layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.Dock = [System.Windows.Forms.DockStyle]::Fill
    $layout.ColumnCount = 1
    $layout.RowCount = 2
    $layout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100))) | Out-Null
    $layout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 30))) | Out-Null

    # Create a status bar
$statusBar = New-Object System.Windows.Forms.StatusStrip
    $statusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
    $statusLabel.Text = "All systems go!"
    $statusBar.Items.Add($statusLabel) | Out-Null

# Create a tab control
$tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Dock = [System.Windows.Forms.DockStyle]::Fill

# [=========== Search Tab ===========]

# Create the Search tab
$searchTab = New-Object System.Windows.Forms.TabPage
    $searchTab.Text = "Search"

    # Create controls for search tab
    $searchTextBox = New-Object System.Windows.Forms.TextBox
    $searchTextBox.Location = New-Object System.Drawing.Point(10, 15)
    $searchTextBox.Size = New-Object System.Drawing.Size(400, 25)
    $searchTextBox.Font = $font

    $searchButton = New-Object System.Windows.Forms.Button
    $searchButton.Location = New-Object System.Drawing.Point(420, 15)
    $searchButton.Size = New-Object System.Drawing.Size(80, 25)
    $searchButton.Text = "Search"

    $resultsListBox = New-Object System.Windows.Forms.ListBox
    $resultsListBox.Location = New-Object System.Drawing.Point(10, 45)
    $resultsListBox.Size = New-Object System.Drawing.Size(660, 220)
    $resultsListBox.Width = $searchTab.Width - 20
    $resultsListBox.Height = $searchTab.Height - 45
    
    $resultsListBox.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor 
    [System.Windows.Forms.AnchorStyles]::Bottom -bor 
    [System.Windows.Forms.AnchorStyles]::Left -bor 
    [System.Windows.Forms.AnchorStyles]::Right
    $resultsListBox.Font = $font

$searchTab.Controls.AddRange(@($searchTextBox, $searchButton, $resultsListBox))

# [=========== Settings Tab ===========]

# Create the Settings tab
$settingsTab = New-Object System.Windows.Forms.TabPage
$settingsTab.Text = "Settings"
$settingsTab.Padding = New-Object System.Windows.Forms.Padding(10)

    # Create controls for settings tab
    $defaultPathLabel = New-Object System.Windows.Forms.Label
    $defaultPathLabel.Text = "Default Path:"
    $defaultPathLabel.Size = New-Object System.Drawing.Size(100, 25)
    $defaultPathLabel.Location = New-Object System.Drawing.Point(10, 10)

    $defaultPathTextBox = New-Object System.Windows.Forms.TextBox
    $defaultPathTextBox.Size = New-Object System.Drawing.Size(300, 25)
    $defaultPathTextBox.Location = New-Object System.Drawing.Point(110, 10)
    $defaultPathTextBox.Font = $font

    $defaultPathButton = New-Object System.Windows.Forms.Button
    $defaultPathButton.Text = "..."
    $defaultPathButton.Size = New-Object System.Drawing.Size(30, 25)
    $defaultPathButton.Location = New-Object System.Drawing.Point(520, 10)
    $defaultPathButton.Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        $folderBrowser.Description = "Select default path"
        if ($folderBrowser.ShowDialog() -eq "OK") {
            # Save selected path as default path
            $defaultPathTextBox.Text = $folderBrowser.SelectedPath
        }
        $folderBrowser.Dispose()  # Dispose of the dialog after use
    })
    
    $ctrlPathLabel = New-Object System.Windows.Forms.Label
    $ctrlPathLabel.Text = "CTRL Path:"
    $ctrlPathLabel.Size = New-Object System.Drawing.Size(100, 25)
    $ctrlPathLabel.Location = New-Object System.Drawing.Point(10, 40)

    $ctrlPathTextBox = New-Object System.Windows.Forms.TextBox
    $ctrlPathTextBox.Size = New-Object System.Drawing.Size(300, 25)
    $ctrlPathTextBox.Location = New-Object System.Drawing.Point(110, 40)
    $ctrlPathTextBox.Font = $font

    $ctrlPathButton = New-Object System.Windows.Forms.Button
    $ctrlPathButton.Text = "..."
    $ctrlPathButton.Size = New-Object System.Drawing.Size(30, 25)
    $ctrlPathButton.Location = New-Object System.Drawing.Point(520, 40)
    $ctrlPathButton.Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        $folderBrowser.Description = "Select ctrl path"
        if ($folderBrowser.ShowDialog() -eq "OK") {
            # Save selected path as CTRL path
            $ctrlPathTextBox.Text = $folderBrowser.SelectedPath
        }
        $folderBrowser.Dispose()  # Dispose of the dialog after use
    })

    $shiftPathLabel = New-Object System.Windows.Forms.Label
    $shiftPathLabel.Text = "SHIFT Path:"
    $shiftPathLabel.Size = New-Object System.Drawing.Size(100, 25)
    $shiftPathLabel.Location = New-Object System.Drawing.Point(10, 70)

    $shiftPathTextBox = New-Object System.Windows.Forms.TextBox
    $shiftPathTextBox.Size = New-Object System.Drawing.Size(300, 25)
    $shiftPathTextBox.Location = New-Object System.Drawing.Point(110, 70)
    $shiftPathTextBox.Font = $font

    $shiftPathButton = New-Object System.Windows.Forms.Button
    $shiftPathButton.Text = "..."
    $shiftPathButton.Size = New-Object System.Drawing.Size(30, 25)
    $shiftPathButton.Location = New-Object System.Drawing.Point(520, 70)
    $shiftPathButton.Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        $folderBrowser.Description = "Select shift path"
        if ($folderBrowser.ShowDialog() -eq "OK") {
            # Save selected path as SHIFT path
            $shiftPathTextBox.Text = $folderBrowser.SelectedPath
        }
    })

    $searchTypeComboBox = New-Object System.Windows.Forms.ComboBox
    $searchTypeComboBox.Size = New-Object System.Drawing.Size(150, 25)
    $searchTypeComboBox.Location = New-Object System.Drawing.Point(10, 100)
    $searchTypeComboBox.Items.AddRange(@("Folder", "File"))
    # If folder is not selected clear file Type
    $searchTypeComboBox.Add_SelectedIndexChanged({
        if ($searchTypeComboBox.SelectedItem -eq "Folder") {
            $fileTypeComboBox.SelectedIndex = -1
        }
    })
    $searchTypeComboBox.Add_SelectedIndexChanged({
        if ($searchTypeComboBox.SelectedItem -eq "File") {
            $fileTypeComboBox.Enabled = $true
            # default to All files
            $fileTypeComboBox.SelectedIndex = 0
        }
        else {
            $fileTypeComboBox.Enabled = $false
        }
    })
    $fileTypeComboBox = New-Object System.Windows.Forms.ComboBox
    $fileTypeComboBox.Size = New-Object System.Drawing.Size(150, 25)
    $fileTypeComboBox.Location = New-Object System.Drawing.Point(180, 100)
    $fileTypeComboBox.Enabled = $false
    $fileTypes = @{
        "All files" = ".*"
        "Images" = ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".tif"
        "Audio" = ".mp3", ".wav", ".flac", ".aac"
        "Video" = ".mp4", ".avi", ".mkv", ".mov", ".wmv", ".mpeg", ".flv"
        "Documents" = ".docx", ".xlsx", ".pptx", ".pdf", ".txt", ".rtf"
        "Spreadsheets" = ".xlsx", ".xls", ".csv"
        "Presentations" = ".pptx", ".ppt"
        "Microsoft Office" = ".docx", ".doc", ".xlsx", ".xls", ".pptx", ".ppt"
        "PDF" = ".pdf"
        "Text" = ".txt", ".rtf"
        "Code" = ".py", ".js", ".html", ".css", ".cpp", ".java", ".c", ".cs", ".php", ".sql", ".xml", ".json", ".ps1"
        "Archives" = ".zip", ".rar", ".7z", ".tar", ".gz", ".bz2"
        "Executable files" = ".exe", ".msi", ".bat", ".sh"
        "Fonts" = ".ttf", ".otf", ".fon", ".woff", ".woff2"
        "CAD files" = ".dwg", ".dxf"
        "GIS files" = ".shp", ".kml", ".kmz"
        "Backup files" = ".bak", ".backup", ".zip", ".tar.gz"
        "Configuration files" = ".conf", ".config", ".ini", ".cfg"
        "Database files" = ".db", ".sqlite", ".dbf"
        "Virtual Machine files" = ".vdi", ".vmdk"
        "Email files" = ".eml", ".msg"
        "Web files" = ".html", ".css", ".js", ".php", ".asp"
        "Log files" = ".log"
        "System files" = ".dll", ".sys"
        "Disk images" = ".iso", ".img"
        "Encrypted files" = ".pgp", ".asc"
        "Temporary files" = ".tmp", ".temp"
        "Torrent files" = ".torrent"
        "Comic files" = ".cbr", ".cbz"
        "Ebook files" = ".epub", ".mobi", ".azw"
    }
    $fileTypeComboBox.Items.AddRange(@( $fileTypes.Keys | Sort-Object))

    # Variable to store the previous selected file type to prevent displaying the same message multiple times
    $previousSelectedFileType = $null
    $fileTypeComboBox.Add_SelectedIndexChanged({
        $selectedFileType = $fileTypeComboBox.SelectedItem
        if ($selectedFileType -ne $null) {
            $selectedFileTypeString = $selectedFileType.ToString()
            $selectedFileExtensions = $fileTypes[$selectedFileTypeString]
            
            # Check if the selected file type is different from the previous one
            if ($selectedFileTypeString -ne $previousSelectedFileType) {
                UpdateStatus("Selected file type: $($selectedFileTypeString) ($($selectedFileExtensions -join ', '))")
                
                # Update the previous selected file type
                $previousSelectedFileType = $selectedFileTypeString
            }
        }
    })

    $saveSettingsButton = New-Object System.Windows.Forms.Button
    $saveSettingsButton.Text = "Save Settings"
    $saveSettingsButton.Size = New-Object System.Drawing.Size(150, 25)
    $saveSettingsButton.Location = New-Object System.Drawing.Point(10, 130)

$settingsTab.Controls.AddRange(@(
    $defaultPathLabel, 
    $defaultPathTextBox, 
    $defaultPathButton, 
    $ctrlPathLabel, 
    $ctrlPathTextBox, 
    $ctrlPathButton, 
    $shiftPathLabel, 
    $shiftPathTextBox, 
    $shiftPathButton, 
    $searchTypeComboBox, 
    $fileTypeComboBox, 
    $saveSettingsButton
))

# Add tabs to the tab control
$tabControl.TabPages.AddRange(@($searchTab, $settingsTab))

# Add tab control to layout
$layout.Controls.Add($tabControl)
$layout.Controls.Add($statusBar)

# Add layout to the form
$form.Controls.Add($layout)

# Function to handle save settings button click
$saveSettingsButton.Add_Click({
    $settings = @{
        DefaultPath = if ($defaultPathTextBox) { $defaultPathTextBox.Text } else { "" }
        CtrlPath = if ($ctrlPathTextBox) { $ctrlPathTextBox.Text } else { "" }
        ShiftPath = if ($shiftPathTextBox) { $shiftPathTextBox.Text } else { "" }
        SearchType = if ($searchTypeComboBox -and $searchTypeComboBox.SelectedItem) { $searchTypeComboBox.SelectedItem.ToString() } else { "" }
        FileType = if ($fileTypeComboBox -and $fileTypeComboBox.SelectedItem) { $fileTypeComboBox.SelectedItem.ToString() } else { "" }
    }

    $settingsJson = $settings | ConvertTo-Json
    $settingsFilePath = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "SearchSettings.json")
    $settingsJson | Out-File -FilePath $settingsFilePath
    UpdateStatus("Settings saved to $settingsFilePath")
})

# Load settings when the form loads
$form.Add_Load({
    $settingsFilePath = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "SearchSettings.json")
    if (Test-Path $settingsFilePath) {
        $settingsJson = Get-Content -Path $settingsFilePath -Raw | ConvertFrom-Json
        $defaultPathTextBox.Text = $settingsJson.DefaultPath
        $ctrlPathTextBox.Text = $settingsJson.CtrlPath
        $shiftPathTextBox.Text = $settingsJson.ShiftPath
        $searchTypeComboBox.SelectedItem = $settingsJson.SearchType
        $fileTypeComboBox.SelectedItem = $settingsJson.FileType
        # Clear the file type combo box if search type is Folder
        if ($settingsJson.SearchType -eq "Folder") {
            $fileTypeComboBox.SelectedIndex = -1
        }
        if ($settingsJson.SearchType -eq "File") {
            $fileTypeComboBox.Enabled = $true
            
        }
    }
})

# Function to handle key press events
$searchTextBox.Add_KeyDown({
    $e = $args[1]
        # Check if Ctrl+Enter is pressed
        if ($e.Control -and $e.KeyCode -eq 'Enter') {
            # Call Search function with the ctrlPathTextBox.Text
            Search -path $ctrlPathTextBox.Text 
            UpdateStatus("Searching path: " + $ctrlPathTextBox.Text)
        }
        # Check if Shift+Enter is pressed
        elseif ($e.Shift -and $e.KeyCode -eq 'Enter') {
            # Call Search function with the shiftPathTextBox.Text
            Search -path $shiftPathTextBox.Text
            UpdateStatus("Searching path: " + $shiftPathTextBox.Text)
        }
        # Check if Enter is pressed without any modifier keys
        elseif ($e.KeyCode -eq 'Enter') {
            # Call Search function with the defaultPathTextBox.Text
            Search -path $defaultPathTextBox.Text
            UpdateStatus("Searching path: " + $defaultPathTextBox.Text)
        }
})

$searchButton.Add_Click({
    # Call Search function with the default path
    Search -path $defaultPathTextBox.Text
})
# Function to update status bar text
function UpdateStatus([string]$text) {
    $statusLabel.Text = $text
}

function Search {
    param(
        [string]$path
    )
    # Clear existing items
    $resultsListBox.Items.Clear()
    try {
        $searchText = $searchTextBox.Text
        $searchType = $searchTypeComboBox.SelectedItem.ToString()

        # Check if search type is Folder
        if ($searchType -eq "Folder") {
            $fileTypeSelected = $null  # Set fileTypeSelected to null
        }
        else {
            # Check if "All files" is selected
            if ($fileTypeComboBox.SelectedItem -eq "All files") {
                $fileTypeSelected = $null  # Don't filter by file type
            }
            else {
                $fileTypeSelected = $fileTypes[$fileTypeComboBox.SelectedItem.ToString()]
            }
        }

        Write-Host "Search Text: $searchText"
        Write-Host "Search Type: $searchType"
        
        if ($searchText.Length -lt 3) {
            UpdateStatus("Input must contain at least 3 characters.")
        }
        else {
            if ($searchType -eq "Folder") {
                Get-ChildItem -Path $path -Directory -Recurse -Depth 1 | Where-Object { $_.Name -like "*$searchText*" } | ForEach-Object {
                    $num_files = (Get-ChildItem -Path $_.FullName -File -Recurse).Count
                    $resultsListBox.Items.Add($_.FullName)
                    UpdateStatus("Searching... ($num_files)")
                }
            }
            elseif ($searchType -eq "File") {
                if ($fileTypeSelected -eq $null) {
                    Get-ChildItem -Path $path -File -Recurse | Where-Object { $_.Name -like "*$searchText*" } | ForEach-Object {
                        $resultsListBox.Items.Add($_.FullName)
                        Write-Host $_.FullName
                    }
                }
                else {
                    Get-ChildItem -Path $path -File -Recurse | Where-Object { $_.Name -like "*$searchText*" -and $fileTypeSelected -contains $_.Extension } | ForEach-Object {
                        $resultsListBox.Items.Add($_.FullName)
                        Write-Host $_.FullName
                    }
                }
            }
        }
        # Search Complete
        UpdateStatus("Search Complete. Found: $($resultsListBox.Items.Count) items.")
    }
    catch {
        Write-Host "An error occurred: $_"
    }
}




# Function to handle double click on results listbox
$resultsListBox.Add_DoubleClick({
    $selectedIndex = $resultsListBox.SelectedIndex
    if ($selectedIndex -ge 0) {
        $selectedItem = $resultsListBox.SelectedItem.ToString()
        if (Test-Path $selectedItem -PathType Container) {
            # Open folder
            Invoke-Item $selectedItem
        }
        elseif (Test-Path $selectedItem -PathType Leaf) {
            # Open file
            Invoke-Item $selectedItem
        }
    }
})

# Show the form
$form.ShowDialog() | Out-Null

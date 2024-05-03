# Import necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Seeker"
$form.Size = New-Object System.Drawing.Size(800, 600)

# Create a tab control to switch between Search and Settings
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(780, 550)
$tabControl.Location = New-Object System.Drawing.Point(10, 10)

# Create the Search tab
$searchTab = New-Object System.Windows.Forms.TabPage
$searchTab.Text = "Search"

# Create search text box
$searchTextBox = New-Object System.Windows.Forms.TextBox
$searchTextBox.Size = New-Object System.Drawing.Size(400, 25)
$searchTextBox.Location = New-Object System.Drawing.Point(10, 10)

# Create search button
$searchButton = New-Object System.Windows.Forms.Button
$searchButton.Text = "Search"
$searchButton.Size = New-Object System.Drawing.Size(80, 25)
$searchButton.Location = New-Object System.Drawing.Point(420, 10)

# Create results list box
$resultsListBox = New-Object System.Windows.Forms.ListBox
$resultsListBox.Size = New-Object System.Drawing.Size(760, 480)
$resultsListBox.Location = New-Object System.Drawing.Point(10, 45)

# Add controls to the Search tab
$searchTab.Controls.Add($searchTextBox)
$searchTab.Controls.Add($searchButton)
$searchTab.Controls.Add($resultsListBox)

# Create the Settings tab
$settingsTab = New-Object System.Windows.Forms.TabPage
$settingsTab.Text = "Settings"

# Create text box and label for default path
$defaultPathLabel = New-Object System.Windows.Forms.Label
$defaultPathLabel.Text = "Default Path:"
$defaultPathLabel.Size = New-Object System.Drawing.Size(100, 25)
$defaultPathLabel.Location = New-Object System.Drawing.Point(10, 10)

$defaultPathTextBox = New-Object System.Windows.Forms.TextBox
$defaultPathTextBox.Size = New-Object System.Drawing.Size(300, 25)
$defaultPathTextBox.Location = New-Object System.Drawing.Point(110, 10)

$defaultPathButton = New-Object System.Windows.Forms.Button
$defaultPathButton.Text = "Browse"
$defaultPathButton.Size = New-Object System.Drawing.Size(80, 25)
$defaultPathButton.Location = New-Object System.Drawing.Point(420, 10)

$defaultPathButton.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select default path"
    if ($folderBrowser.ShowDialog() -eq "OK") {
        # Save selected path as default path
        $defaultPathTextBox.Text = $folderBrowser.SelectedPath
    }
    $folderBrowser.Dispose()  # Dispose of the dialog after use
})

# Add controls to the Settings tab
$settingsTab.Controls.Add($defaultPathLabel)
$settingsTab.Controls.Add($defaultPathTextBox)
$settingsTab.Controls.Add($defaultPathButton)

# Create text box and label for CTRL path
$ctrlPathLabel = New-Object System.Windows.Forms.Label
$ctrlPathLabel.Text = "CTRL Path:"
$ctrlPathLabel.Size = New-Object System.Drawing.Size(100, 25)
$ctrlPathLabel.Location = New-Object System.Drawing.Point(10, 40)

$ctrlPathTextBox = New-Object System.Windows.Forms.TextBox
$ctrlPathTextBox.Size = New-Object System.Drawing.Size(300, 25)
$ctrlPathTextBox.Location = New-Object System.Drawing.Point(110, 40)

$ctrlPathButton = New-Object System.Windows.Forms.Button
$ctrlPathButton.Text = "Browse"
$ctrlPathButton.Size = New-Object System.Drawing.Size(80, 25)
$ctrlPathButton.Location = New-Object System.Drawing.Point(420, 40)

$ctrlPathButton.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select ctrl path"
    if ($folderBrowser.ShowDialog() -eq "OK") {
        # Save selected path as CTRL path
        $ctrlPathTextBox.Text = $folderBrowser.SelectedPath
    }
    $folderBrowser.Dispose()  # Dispose of the dialog after use
})

# Add controls to the Settings tab
$settingsTab.Controls.Add($ctrlPathLabel)
$settingsTab.Controls.Add($ctrlPathTextBox)
$settingsTab.Controls.Add($ctrlPathButton)

# Create text box and label for SHIFT path
$shiftPathLabel = New-Object System.Windows.Forms.Label
$shiftPathLabel.Text = "SHIFT Path:"
$shiftPathLabel.Size = New-Object System.Drawing.Size(100, 25)
$shiftPathLabel.Location = New-Object System.Drawing.Point(10, 70)

$shiftPathTextBox = New-Object System.Windows.Forms.TextBox
$shiftPathTextBox.Size = New-Object System.Drawing.Size(300, 25)
$shiftPathTextBox.Location = New-Object System.Drawing.Point(110, 70)

$shiftPathButton = New-Object System.Windows.Forms.Button
$shiftPathButton.Text = "Browse"
$shiftPathButton.Size = New-Object System.Drawing.Size(80, 25)
$shiftPathButton.Location = New-Object System.Drawing.Point(420, 70)

$shiftPathButton.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select shift path"
    if ($folderBrowser.ShowDialog() -eq "OK") {
        # Save selected path as SHIFT path
        $shiftPathTextBox.Text = $folderBrowser.SelectedPath
    }
})

# Add controls to the Settings tab
$settingsTab.Controls.Add($shiftPathLabel)
$settingsTab.Controls.Add($shiftPathTextBox)
$settingsTab.Controls.Add($shiftPathButton)


$searchTypeComboBox = New-Object System.Windows.Forms.ComboBox
$searchTypeComboBox.Size = New-Object System.Drawing.Size(150, 25)
$searchTypeComboBox.Location = New-Object System.Drawing.Point(10, 100)
$searchTypeComboBox.Items.AddRange(@("Folder", "File"))

$saveSettingsButton = New-Object System.Windows.Forms.Button
$saveSettingsButton.Text = "Save Settings"
$saveSettingsButton.Size = New-Object System.Drawing.Size(150, 25)
$saveSettingsButton.Location = New-Object System.Drawing.Point(10, 130)

# Add controls to the Settings tab
$settingsTab.Controls.Add($defaultPathTextBox)
$settingsTab.Controls.Add($defaultPathButton)
$settingsTab.Controls.Add($ctrlPathTextBox)
$settingsTab.Controls.Add($ctrlPathButton)
$settingsTab.Controls.Add($shiftPathTextBox)
$settingsTab.Controls.Add($shiftPathButton)
$settingsTab.Controls.Add($searchTypeComboBox)
$settingsTab.Controls.Add($saveSettingsButton)

# Define tab control
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Width = $form.Width - 20
$tabControl.Height = $form.Height - 40
$tabControl.Location = New-Object System.Drawing.Point(5, 5)
$tabControl.TabPages.Add($searchTab)
$tabControl.TabPages.Add($settingsTab)

# Add tab control to form
$form.Controls.Add($tabControl)


# Function to handle save settings button click
$saveSettingsButton.Add_Click({
    $settings = @{
        DefaultPath = if ($defaultPathTextBox) { $defaultPathTextBox.Text } else { "" }
        CtrlPath = if ($ctrlPathTextBox) { $ctrlPathTextBox.Text } else { "" }
        ShiftPath = if ($shiftPathTextBox) { $shiftPathTextBox.Text } else { "" }
        SearchType = if ($searchTypeComboBox -and $searchTypeComboBox.SelectedItem) { $searchTypeComboBox.SelectedItem.ToString() } else { "" }
    }

    $settingsJson = $settings | ConvertTo-Json
    $settingsFilePath = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "SearchSettings.json")
    $settingsJson | Out-File -FilePath $settingsFilePath
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
    }
})

# Function to handle key down event
$form.Add_KeyDown({
    param([System.Windows.Forms.KeyEventArgs]$e)
    
    if ($e.KeyCode -eq 'Enter') {
        if ($e.Control) {
            # Perform search using CTRL path keybind
            Search -Path $ctrlPathTextBox.Text
        }
        elseif ($e.Shift) {
            # Perform search using SHIFT path keybind
            Search -Path $shiftPathTextBox.Text
        }
        else {
            # Perform search using default path
            Search -Path $defaultPathTextBox.Text
        }
    }
})

$searchButton.Add_Click({
    Search -Path $defaultPathTextBox.Text -searchTextBox $searchTextBox -searchTypeComboBox $searchTypeComboBox
})


function Search {
    param(
        [string]$path,
        [System.Windows.Forms.TextBox]$searchTextBox,
        [System.Windows.Forms.ComboBox]$searchTypeComboBox
    )
    Write-Host $path
    Write-Host $searchTextBox
    Write-Host $searchTypeComboBox
    try {
        $searchText = $searchTextBox.Text
        $searchType = $searchTypeComboBox.SelectedItem.ToString()
        if ($searchText.Length -lt 3) {
            $WarningLabel.Text = "Input must contain at least 3 characters."
            $WarningLabel.Visible = $true
        }
        else {
            # Clear existing items
            $resultsListBox.Items.Clear()
            if ($searchType -eq "Folder") {
                # Search current directory
                Get-ChildItem -Path $path -Directory -Recurse -Depth 1 | Where-Object { $_.Name -like "*$searchText*" } | ForEach-Object {
                    $resultsListBox.Items.Add($_.FullName)
                }
            }
            elseif ($searchType -eq "File") {
                # Search current directory for files
                Get-ChildItem -Path $path -File -Recurse | Where-Object { $_.Name -like "*$searchText*" } | ForEach-Object {
                    [void]$resultsListBox.Items.Add($_.FullName)
                }
            }
        }
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

# Show form
$form.ShowDialog() | Out-Null

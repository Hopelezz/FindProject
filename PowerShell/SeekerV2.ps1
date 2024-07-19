Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

#Generate Favicon.ico
# Replace this with your actual icon path.
# Make sure the icon exists and is accessible.
$icon = "C:\path\to\your\icon.ico"
$iconPath = "$env:APPDATA\Seeker\favicon.ico"
if (-not (Test-Path -Path $iconPath)) {
    Copy-Item -Path $icon -Destination $iconPath
}

$statusMessages = @(
    "Ready for a file-finding adventure?",
    "Let's find those files!",
    "Let's play hide and seek with your files!",
    "Time to uncover your digital universe!",
    "Let's get this party started!",
    "Who needs a treasure map?",
    "Lights, camera, action!",
    "Your mission: find those files!",
    "Let's hunt some digital gold!",
    "Get your searching hats on!",
    "Let's turn chaos into bliss!",
    "Welcome aboard the file-finding express!",
    "Clear eyes, full hard drives!",
    "Your files called. Let's find them!",
    "Sherlock who? Let's do this!",
    "Ready, set, search!",
    "Fear not, we'll guide you through!",
    "Let's unleash the power of organization!",
    "Forecast: scattered files, chance of organization!",
    "Don your explorer's hat!",
    "Operation: Find & Restore, commence!",
    "Get ready for file-finding fireworks!",
    "Time to tame the wild beast of your file system!",
    "Unlock the hidden potential of your files!",
    "Prepare for file-finding fireworks!",
    "Let's turn chaos into clarity!",
    "Adventure awaits at every click!",
    "Dive headfirst into the digital rabbit hole!",
    "Hold onto your hats, folks!",
    "Files await their moment in the spotlight!",
    "Let's sprinkle some magic dust on your files!",
    "Navigate the twists and turns of your file maze!",
    "Show those folders who's boss!",
    "We're marching into battle against disorganization!",
    "We're on a mission to conquer clutter!",
    "Let's dive into the digital unknown!",
    "Clear the runway for a file-finding adventure!",
    "Files, here we come!",
    "Venture into the digital wilderness!",
    "Get ready for a file-finding extravaganza!",
    "Sprinkle some organization fairy dust!",
    "Rev up for a file-finding marathon!",
    "Dive deep into the digital depths!",
    "Solve the mystery of the missing files!",
    "Embark on a wild ride through your directories!",
    "Crack open those virtual vaults!",
    "Witness the magic of organization!",
    "Activate the file-finding frenzy!",
    "Let's dig into your digital treasure trove!",
    "Ready to wrangle those wandering files?",
    "Cue the drumroll! Let's find those files!",
    "Prepare to conquer your digital chaos!",
    "Time to bring order to the digital mayhem!",
    "Let's turn your file jungle into a file paradise!",
    "On your mark, get set, organize!",
    "Grab your virtual flashlight! We're exploring your files!",
    "Let's navigate the labyrinth of your folders!",
    "Blast off into the realm of organized files!",
    "Unveil the hidden gems buried in your folders!",
    "Prepare for a digital scavenger hunt!",
    "Ready to untangle the web of files?",
    "Let's be the heroes your files deserve!",
    "Welcome to the land of file-finding wonders!",
    "Brace yourself for a file-finding odyssey!",
    "Let's sprinkle some organization magic!",
    "Get your file-finding engines revved!",
    "Onward, to the land of organized bliss!",
    "Charting a course through your file galaxy!",
    "Let's embark on a journey to file serenity!",
    "Dive into the sea of your digital documents!",
    "Let's give your files the spotlight they deserve!",
    "Buckle up for a rollercoaster ride through your files!",
    "Ready to bring order to the file chaos?",
    "Prepare for file-finding greatness!",
    "Let's dust off those neglected files and give them a home!",
    "File-finding mode: activated!",
    "Let's make file-finding an art form!",
    "Your files called, they're ready to be found!",
    "Navigate the file maze with finesse!",
    "We're on a mission to rescue your lost files!",
    "Time to shine a light on your file darkness!",
    "Let's crack the code of your file organization!",
    "Embrace the thrill of the file hunt!",
    "Prepare to witness the magic of file-finding!",
    "Welcome to the file-finding party!",
    "Your files are waiting for their moment in the sun!",
    "Let's tame the file chaos like a digital cowboy!",
    "Clear the clutter, find the files!",
    "We're the file-finding dream team!",
    "Let's turn your file frown upside down!",
    "Ready to decode the language of your files?",
    "Let's play matchmaker with your files and folders!",
    "Unleash the power of your organized files!",
    "Let's uncover the buried treasures in your folders!",
    "Your files are our top priority!",
    "We're on a quest for file-finding glory!",
    "Prepare for a file-finding revolution!",
    "Let's make your file dreams a reality!"
)


$settingsFile = "$env:APPDATA\Seeker\settings.json"
if (-not (Test-Path -Path $settingsFile)) {
    New-Item -ItemType Directory -Path (Split-Path -Path $settingsFile) -Force | Out-Null
}


<#
.SYNOPSIS
Writes a log entry to the seeker.log file.

.DESCRIPTION
The Write-Log function is used to write a log entry to the seeker.log file located in the user's APPDATA directory. The log entry includes a timestamp, log level, and the specified message.

.PARAMETER Message
The message to be logged.

.PARAMETER Level
The log level of the message. Default value is "Info".

.EXAMPLE
Write-Log -Message "This is an informational message."

This example writes an informational message to the log file with the default log level "Info".
#>

function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "Info"
    )
    $logFile = "$env:APPDATA\Seeker\seeker.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Add-Content -Path $logFile -Value $logEntry
}

<#
.SYNOPSIS
Loads the settings from the settings file.

.DESCRIPTION
This function loads the settings from the settings file located at "$env:APPDATA\Seeker\settings.json". If the file exists, it reads the content and converts it from JSON format to a PowerShell object. If the file doesn't exist or the content cannot be converted, it returns a default set of settings.

.PARAMETER None

.OUTPUTS
[PSCustomObject]
Returns a PowerShell custom object representing the loaded settings.

#>

function Load_Settings {
    try {
        $settingsFile = "$env:APPDATA\Seeker\settings.json"
        if (Test-Path $settingsFile) {
            $loadedSettings = Get-Content -Path $settingsFile | ConvertFrom-Json
        } else {
            $loadedSettings = $null
        }

        if ($null -eq $loadedSettings) {
            $loadedSettings = @{
                DefaultPath = "\\jensen-group.intra\jeusdfs01\Engineering\Futurail Design Files\Contracts"
                CtrlPath = ""
                ShiftPath = ""
                AltPath = ""
            }
        }

        return [PSCustomObject]$loadedSettings
    }
    catch {
        Write-Log "Error loading settings: $_" -Level "Error"
        return [PSCustomObject]@{
            DefaultPath = "\\jensen-group.intra\jeusdfs01\Engineering\Futurail Design Files\Contracts"
            CtrlPath = ""
            ShiftPath = ""
            AltPath = ""
        }
    }
}

function Save_Settings {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$settings
    )
    try {
        $settingsFile = "$env:APPDATA\Seeker\settings.json"
        if (-not (Test-Path -Path $settingsFile)) {
            New-Item -ItemType Directory -Path (Split-Path -Path $settingsFile) -Force | Out-Null
        }
        $settings | ConvertTo-Json | Set-Content -Path $settingsFile
        Write-Log "Settings saved successfully. Added settings: $($settings | ConvertTo-Json -Compress)"
    }
    catch {
        Write-Log "Error saving settings: $_" -Level "Error"
        throw
    }
}

function Perform_Search {
    param (
        [string]$searchQuery,
        [string]$searchPath
    )
    Write-Log "Performing search: Query='$searchQuery', Path='$searchPath'"
    try {
        $foundFolders = Get-ChildItem -Path $searchPath -Directory -Recurse -Depth 1 | Where-Object { $_.Name -like "*$searchQuery*" }
        return $foundFolders | ForEach-Object {
            $relativePath = $_.FullName.Replace($searchPath, "").TrimStart('\')
            [PSCustomObject]@{
                FullPath = $_.FullName
                RelativePath = $relativePath
                SearchPath = $searchPath
                ToString = [scriptblock]{ return $this.RelativePath }
            }
        }
    }
    catch {
        Write-Log "Error searching folders: $_" -Level "Error"
        throw
    }
}


function Initialize_Window {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$settings
    )

    [xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Seeker" Height="350" Width="550" WindowStartupLocation="CenterScreen">
    <Window.Icon>
        <ImageSource x:Key="favicon.ico">$iconPath</ImageSource>
    </Window.Icon>
    <Grid>
        <TabControl>
            <TabItem Header="Search">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0" Margin="10">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <TextBox x:Name="SearchBox" Grid.Column="0" VerticalAlignment="Stretch"/>
                        <Button x:Name="SearchButton" Content="Search" Grid.Column="1" Margin="10,0,0,0" VerticalAlignment="Stretch"/>
                    </Grid>
                    <ListBox x:Name="ListBox" Margin="10" Grid.Row="1"/>
                    <StatusBar Grid.Row="2" VerticalAlignment="Bottom" Background="LightGray">
                        <StatusBarItem>
                            <TextBlock x:Name="StatusMessage" VerticalAlignment="Center"/>
                        </StatusBarItem>
                    </StatusBar>
                </Grid>
            </TabItem>
            <TabItem Header="Settings">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <!-- Default Path -->
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="*" />
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <Label Content="Default Path:       " VerticalAlignment="Center" Grid.Column="0" Margin="0,0,5,0"/>
                        <TextBox x:Name="DefaultPath" VerticalAlignment="Center" Grid.Column="1" Margin="0,0,5,0"/>
                        <Button x:Name="DefaultPathButton" Content="..." Grid.Column="2" Width="30" Height="18">
                        <Button.ToolTip>
                                <ToolTip>
                                    <TextBlock Text="Click to select the default search path."/>
                                </ToolTip>
                            </Button.ToolTip>
                        </Button>
                    </Grid>
                    <!-- Ctrl+Enter Path -->
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="*" />
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <Label Content="Ctrl+Enter Path:  " VerticalAlignment="Center" Grid.Column="0" Margin="0,0,5,0"/>
                        <TextBox x:Name="CtrlPath" VerticalAlignment="Center" Grid.Column="1" Margin="0,0,5,0"/>
                        <Button x:Name="CtrlPathButton" Content="..." Grid.Column="2" Width="30" Height="18">
                        <Button.ToolTip>
                                <ToolTip>
                                    <TextBlock Text="Click to select the Ctrl Search Path path."/>
                                </ToolTip>
                            </Button.ToolTip>
                        </Button>
                    </Grid>
                    <!-- Shift+Enter Path -->
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="*" />
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <Label Content="Shift+Enter Path:" VerticalAlignment="Center" Grid.Column="0" Margin="0,0,5,0"/>
                        <TextBox x:Name="ShiftPath" VerticalAlignment="Center" Grid.Column="1" Margin="0,0,5,0"/>
                        <Button x:Name="ShiftPathButton" Content="..." Grid.Column="2" Width="30" Height="18">
                        <Button.ToolTip>
                                <ToolTip>
                                    <TextBlock Text="Click to select the Shift Search Path path."/>
                                </ToolTip>
                            </Button.ToolTip>
                        </Button>
                    </Grid>
                    <!-- Alt+Enter Path -->
                    <Grid Grid.Row="3">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="*" />
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <Label Content="Alt+Enter Path:   " VerticalAlignment="Center" Grid.Column="0" Margin="0,0,5,0"/>
                        <TextBox x:Name="AltPath" VerticalAlignment="Center" Grid.Column="1" Margin="0,0,5,0"/>
                        <Button x:Name="AltPathButton" Content="..." Grid.Column="2" Width="30" Height="18">
                        <Button.ToolTip>
                                <ToolTip>
                                    <TextBlock Text="Click to select the Alt Search Path path."/>
                                </ToolTip>
                            </Button.ToolTip>
                        </Button>
                    </Grid>
                    <!-- Save Button -->
                    <Grid Grid.Row="4">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*" />
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <Button x:Name="SaveSettingsButton" Content="Save Settings" Grid.Column="0" HorizontalAlignment="Stretch" Margin="10"/>
                    </Grid>
                    <!-- Status Message -->
                    <StatusBar Grid.Row="5" VerticalAlignment="Bottom" Background="LightGray">
                        <StatusBarItem>
                            <TextBlock x:Name="StatusMessageSettings" VerticalAlignment="Center"/>
                        </StatusBarItem>
                    </StatusBar>
                </Grid>
            </TabItem>
            <TabItem Header="About">
                <Grid>
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <ListBox Margin="5">
                                <TextBlock Text="Author: Mark Spratt" Margin="5" FontWeight="Bold"/>
                                <TextBlock Text="Email: Mark.Spratt@jensen-group.com"/>
                            </ListBox>
                            <ListBox Margin="5">
                                <TextBlock Text="Revision Log:" Margin="5" FontWeight="Bold"/>    

                                <ListBoxItem Content="v0.1 - Initial release" Margin="1">
                                    <ListBoxItem.ToolTip>
                                        <ToolTip>
                                            <TextBlock Text="Added 18/JUL/24. Thanks for using the scipt!"/>
                                        </ToolTip>
                                    </ListBoxItem.ToolTip>
                                </ListBoxItem>

                                <ListBoxItem Content="v0.2 - Added Keybind path feature" Margin="1">
                                    <ListBoxItem.ToolTip>
                                        <ToolTip>
                                            <TextBlock Text="Added 18/JUL/24 the ability to set custom paths for Ctrl+Enter, Shift+Enter, and Alt+Enter keybinds."/>
                                        </ToolTip>
                                    </ListBoxItem.ToolTip>
                                </ListBoxItem>

                                <ListBoxItem Content="v0.3 - Added Warning Message when searching with 3 or fewer characters" Margin="1">
                                    <ListBoxItem.ToolTip>
                                        <ToolTip>
                                            <TextBlock Text="Added 19/JUL/24"/>
                                        </ToolTip>
                                    </ListBoxItem.ToolTip>
                                </ListBoxItem>

                            </ListBox>

                            <ListBox Margin="5">
                                <TextBlock Text="Known Issues:" Margin="5" FontWeight="Bold"/>
                                <ListBoxItem Content="No known issues at this time." Margin="1"/>
                            </ListBox>

                            <ListBox Margin="5">
                                <TextBlock Text="Road Map:" Margin="5" FontWeight="Bold"/>

                                <ListBoxItem Content="Folder Scan for remote workers" Margin="1">
                                    <ListBoxItem.ToolTip>
                                        <ToolTip>
                                            <TextBlock Text="This will be a checkbox with a label next to it. This will scan the default folder path and save it to a json in %APPDATA%. This will happen once a day. When searching default path the functionality should be the same as normal search."/>
                                        </ToolTip>
                                    </ListBoxItem.ToolTip>
                                </ListBoxItem>
                                
                                <ListBoxItem Content="Ability to search sharepoint folder for Sales" Margin="1"/>
                                <ListBoxItem Content="Folder Preview Pane for Folder details. Such as Creation Date, or Last Modified Date." Margin="1"/>
                                <ListBoxItem Content="Improved search functionality" Margin="1"/>
                                <ListBoxItem Content="Filtering and sorting options for search results" Margin="1"/>
                                <ListBoxItem Content="Ability to define search depth from settings." Margin="1"/>
                                <ListBoxItem Content="Ability to search for files as well as folders." Margin="1"/>
                                <ListBoxItem Content="Reduce the Log file to just a months worth of searches" Margin="1"/>
                            </ListBox> 
                        </StackPanel>
                    </ScrollViewer>
                </Grid>
            </TabItem>
        </TabControl>
    </Grid>
</Window>
"@

    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $window = [System.Windows.Markup.XamlReader]::Load($reader)

    $statusMessage = Get-Random -InputObject $statusMessages
    $window.FindName("StatusMessage").Text = $statusMessage

    $searchButton = $window.FindName("SearchButton")
    $searchButton.Add_Click({
        $searchQuery = $window.FindName("SearchBox").Text
        if ($searchQuery.Length -le 3) {
            $window.FindName("StatusMessage").Foreground = "Red"
            $window.FindName("StatusMessage").Text = "Search query must be more than 3 characters."
            return
        }
        $window.FindName("StatusMessage").Foreground = "Black"
        $searchPath = $settings.DefaultPath
        $results = Perform_Search -searchQuery $searchQuery -searchPath $searchPath
        Update_ListBox -results $results
    })
    
 
    $window.FindName("ListBox").Add_MouseDoubleClick({
        $selectedItem = $window.FindName("ListBox").SelectedItem
        if ($null -ne $selectedItem) {
            $folderPath = $selectedItem.FullPath
            Start-Process "explorer.exe" -ArgumentList $folderPath
            Write-Host "Opening folder: $folderPath"
        }
    })

    $window.FindName("DefaultPathButton").Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        $result = $folderBrowser.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $window.FindName("DefaultPath").Text = $folderBrowser.SelectedPath
        }
    })

    $window.FindName("CtrlPathButton").Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        $result = $folderBrowser.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $window.FindName("CtrlPath").Text = $folderBrowser.SelectedPath
        }
    })

    $window.FindName("ShiftPathButton").Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        $result = $folderBrowser.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $window.FindName("ShiftPath").Text = $folderBrowser.SelectedPath
        }
    })

    $window.FindName("AltPathButton").Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        $result = $folderBrowser.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $window.FindName("AltPath").Text = $folderBrowser.SelectedPath
        }
    })

    $window.FindName("SaveSettingsButton").Add_Click({
        $settings.DefaultPath = $window.FindName("DefaultPath").Text
        $settings.CtrlPath = $window.FindName("CtrlPath").Text
        $settings.ShiftPath = $window.FindName("ShiftPath").Text
        Save_Settings -settings $settings
        $window.FindName("StatusMessageSettings").Text = "Settings saved successfully."
    })

    $window.FindName("SearchBox").Add_KeyDown({
        param($eventSender, $e)
        if ($e.Key -eq 'Enter') {
            $searchPath = $settings.DefaultPath
            if ($e.KeyboardDevice.Modifiers -band [System.Windows.Input.ModifierKeys]::Control) {
                $searchPath = $settings.CtrlPath
            } elseif ($e.KeyboardDevice.Modifiers -band [System.Windows.Input.ModifierKeys]::Shift) {
                $searchPath = $settings.ShiftPath
            }
            $searchQuery = $eventSender.Text
            if ($searchQuery.Length -le 3) {
                $window.FindName("StatusMessage").Foreground = "Red"
                $window.FindName("StatusMessage").Text = "Search query must be more than 3 characters."
                return
            }
            $window.FindName("StatusMessage").Foreground = "Black"
            $results = Perform_Search -searchQuery $searchQuery -searchPath $searchPath
            Update_ListBox -results $results
            $e.Handled = $true
        }
    })

    return $window
}

function Update_ListBox {
    param (
        [Array]$results
    )
    $listBox = $window.FindName("ListBox")
    $listBox.Items.Clear()
    $currentCount = 0 # Initialize the count of discovered results

    $sortedResults = $results | Sort-Object -Property "RelativePath" # Sort the results by relative path

    foreach ($result in $sortedResults) {
        $listBox.Items.Add($result)
        $listBox.DisplayMemberPath = "RelativePath" # Display relative path in the ListBox
        $currentCount++ # Increment the count for each discovered result
        $window.FindName("StatusMessage").Text = "Searching... Found $currentCount folders." # Update the status message with the current count
        
        # Force the UI to update by processing other events
        [System.Windows.Threading.Dispatcher]::CurrentDispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Background, [Action]{$null})
    }
    $window.FindName("StatusMessage").Text = "Search completed. Found $currentCount folders." # Final status message after all results are processed
}

# Main script execution
try {
    Write-Log "Starting application"
    $settings = Load_Settings
    Write-Log "Settings loaded: $($settings | ConvertTo-Json -Compress)"
    
    $window = Initialize_Window -settings $settings
    if ($null -eq $window) {
        throw "Window could not be initialized"
    }
    
    $window.FindName("DefaultPath").Text = $settings.DefaultPath
    $window.FindName("CtrlPath").Text = $settings.CtrlPath
    $window.FindName("ShiftPath").Text = $settings.ShiftPath
    
    Write-Log "Window initialized successfully"
    $window.ShowDialog() | Out-Null
}
catch {
    Write-Log "Error initializing application: $_" -Level "Error"
    [System.Windows.MessageBox]::Show("Error initializing application: $_", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
}

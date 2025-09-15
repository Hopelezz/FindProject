# Creator: Mark Spratt
# Date: 5/SEP/25

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Ensure the Seeker directory exists in APPDATA
$seekerDir = "$env:APPDATA\Seeker"
if (-not (Test-Path -Path $seekerDir)) {
    New-Item -ItemType Directory -Path $seekerDir -ErrorAction Stop
}

# Generate Favicon
try {
    $icon = "\\jensen-group.intra\jeusdfs01\Engineering\Electrical Design Team\Scripts\FindProject\favicon.ico"
    $iconPath = "$seekerDir\favicon.ico"
    if (-not (Test-Path -Path $iconPath)) {
        Copy-Item -Path $icon -Destination $iconPath -ErrorAction Stop
    }
} catch {
    Write-Error "Failed to copy the icon. Error: $_"
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
                DefaultPathDepth = 1
                CtrlPath = ""
                CtrlPathDepth = 1
                ShiftPath = ""
                ShiftPathDepth = 1
                AltPath = ""
                AltPathDepth = 1
                Scan = $false
            }
        }

        return [PSCustomObject]$loadedSettings
    }
    catch {
        Write-Log "Error loading settings: $_" -Level "Error"
        return [PSCustomObject]@{
            DefaultPath = "\\jensen-group.intra\jeusdfs01\Engineering\Futurail Design Files\Contracts"
            DefaultPathDepth = 1
            CtrlPath = ""
            CtrlPathDepth = 1
            ShiftPath = ""
            ShiftPathDepth = 1
            AltPath = ""
            AltPathDepth = 1
            Scan = $false
        }
    }
}


function Save_Settings {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$settings
    )
    try {
        Write-Output "Attempting to save settings: $($settings | ConvertTo-Json -Compress)"
        $settingsFile = "$env:APPDATA\Seeker\settings.json"
        if (-not (Test-Path -Path $settingsFile)) {
            New-Item -ItemType Directory -Path (Split-Path -Path $settingsFile) -Force | Out-Null
        }
        $settings | ConvertTo-Json | Set-Content -Path $settingsFile
        Write-Log "Settings saved successfully. Added settings: $($settings | ConvertTo-Json -Compress)"
    }
    catch {
        Write-Log "Error saving settings: $($_.Exception.Message)" -Level "Error"
        throw
    }
}


function Perform_Search {
    param (
        [string]$searchQuery,
        [string]$searchPath,
        [int]$depth
    )
    Write-Log "Performing search: Query='$searchQuery', Path='$searchPath'. Depth=$depth" 
    $settings = Load_Settings
    $results = [System.Collections.Generic.List[PSObject]]::new() # Use List for better performance

    try {
        if ($settings.Scan -eq $true) {
            # Use  index for ultra-fast search across all paths
            $indexInfo = Initialize-Index
            
            # Check if  index exists
            if (-not (Test-Path $indexInfo.IndexFile)) {
                Write-Log " index file not found: $($indexInfo.IndexFile)" -Level "Error"
                $window.FindName("StatusMessage").Text = " index not found. Please perform an index scan first."
                return @()
            }

            # Load and validate  indexed data
            try {
                $indexData = Get-Content -Path $indexInfo.IndexFile -Raw | ConvertFrom-Json
                if (-not $indexData.Folders -or $indexData.Folders.Count -eq 0) {
                    Write-Log " index file is empty or invalid: $($indexInfo.IndexFile)" -Level "Error"
                    $window.FindName("StatusMessage").Text = " index is empty. Please perform a scan first."
                    return @()
                }
            } catch {
                Write-Log "Error reading or parsing  index file: $_" -Level "Error"
                $window.FindName("StatusMessage").Text = "Error reading  index. Please perform a scan first."
                return @()
            }

            # Filter folders by the specific search path (respecting keybind selection)
            $pathFolders = $indexData.Folders | Where-Object { $_.SearchPath -eq $searchPath }
            
            if ($pathFolders.Count -eq 0) {
                Write-Log "No folders found in index for search path: $searchPath" -Level "Warning"
                $window.FindName("StatusMessage").Text = "No indexed folders found for the selected path. Path may not be indexed."
                return @()
            }

            # Perform ultra-fast search on filtered indexed data
            $searchTerms = $searchQuery.ToLower()
            $searchWords = $searchTerms -split '\s+' | Where-Object { $_.Length -gt 0 }
            
            # Multi-threaded search for large datasets
            if ($pathFolders.Count -gt 5000) {
                # Use runspace for large datasets
                $runspace = [runspacefactory]::CreateRunspace()
                $runspace.Open()
                
                $powershell = [powershell]::Create()
                $powershell.Runspace = $runspace
                
                $scriptBlock = {
                    param($folders, $searchWords, $searchQuery)
                    
                    $matchedFolders = foreach ($folder in $folders) {
                        $matched = $false
                        
                        # Fast string matching using pre-computed search terms
                        foreach ($term in $folder.SearchTerms) {
                            foreach ($word in $searchWords) {
                                if ($term.Contains($word)) {
                                    $matched = $true
                                    break
                                }
                            }
                            if ($matched) { break }
                        }
                        
                        # Additional fuzzy matching for better results
                        if (-not $matched) {
                            if ($folder.Name -like "*$searchQuery*" -or $folder.RelativePath -like "*$searchQuery*") {
                                $matched = $true
                            }
                        }
                        
                        if ($matched) {
                            [PSCustomObject]@{
                                FullPath = $folder.FullPath
                                RelativePath = $folder.RelativePath
                                SearchPath = $folder.SearchPath
                                PathName = $folder.PathName
                                LastModified = $folder.LastModified
                                ToString = [scriptblock]{ return $this.RelativePath }
                            }
                        }
                    }
                    
                    return $matchedFolders
                }
                
                $null = $powershell.AddScript($scriptBlock).AddArgument($pathFolders).AddArgument($searchWords).AddArgument($searchQuery)
                $asyncResult = $powershell.BeginInvoke()
                
                # Update UI while searching
                $pathName = ($pathFolders | Select-Object -First 1).PathName
                $window.FindName("StatusMessage").Text = "Searching $pathName path... ($($pathFolders.Count) folders)"
                
                # Wait for completion with timeout
                $timeout = 30000 # 30 seconds
                if ($asyncResult.AsyncWaitHandle.WaitOne($timeout)) {
                    $searchResults = $powershell.EndInvoke($asyncResult)
                    foreach ($result in $searchResults) {
                        $results.Add($result)
                    }
                } else {
                    Write-Log "Search timed out" -Level "Warning"
                    $window.FindName("StatusMessage").Text = "Search timed out. Try a more specific query."
                }
                
                $powershell.Dispose()
                $runspace.Close()
                
            } else {
                # Standard search for smaller datasets
                foreach ($folder in $pathFolders) {
                    $matched = $false
                    
                    # Fast string matching using pre-computed search terms
                    foreach ($term in $folder.SearchTerms) {
                        foreach ($word in $searchWords) {
                            if ($term.Contains($word)) {
                                $matched = $true
                                break
                            }
                        }
                        if ($matched) { break }
                    }
                    
                    # Additional fuzzy matching for better results
                    if (-not $matched) {
                        if ($folder.Name -like "*$searchQuery*" -or $folder.RelativePath -like "*$searchQuery*") {
                            $matched = $true
                        }
                    }
                    
                    if ($matched) {
                        $results.Add([PSCustomObject]@{
                            FullPath = $folder.FullPath
                            RelativePath = $folder.RelativePath
                            SearchPath = $folder.SearchPath
                            PathName = $folder.PathName
                            LastModified = $folder.LastModified
                            ToString = [scriptblock]{ return $this.RelativePath }
                        })
                    }
                }
            }
            
            Write-Log " index search completed for path: $searchPath. Found $($results.Count) results."
            
        } else {
            # Live search mode (fallback)
            $foundFolders = Get-ChildItem -Path $searchPath -Directory -Recurse -Depth $depth -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$searchQuery*" }
            foreach ($folder in $foundFolders) {
                Write-Host $folder.FullName
                $relativePath = $folder.FullName.Replace($searchPath, "").TrimStart('\')
                $results.Add([PSCustomObject]@{
                    FullPath = $folder.FullName
                    RelativePath = $relativePath
                    SearchPath = $searchPath
                    PathName = "Live Search"
                    LastModified = $folder.LastWriteTime
                    ToString = [scriptblock]{ return $this.RelativePath }
                })
            }
        }

        # Check if results is empty
        if ($results.Count -eq 0) {
            $window.FindName("StatusMessage").Text = "No results found for the search query: $searchQuery"
            return @()
        }

        return $results.ToArray()

    } catch {
        Write-Log "Error searching folders: $_" -Level "Error"
        $window.FindName("StatusMessage").Text = "Error during search. Check logs for details."
        return @()
    }
}


# Smart indexing system inspired by "Everything" app -  Multi-Path Index
function Initialize-Index {
    $indexDir = "$env:APPDATA\Seeker\Index"
    if (-not (Test-Path -Path $indexDir)) {
        New-Item -ItemType Directory -Path $indexDir -Force | Out-Null
    }
    
    # Use  index files for all paths
    $indexFile = "$indexDir\_index.json"
    $metaFile = "$indexDir\_meta.json"
    
    return @{
        IndexFile = $indexFile
        MetaFile = $metaFile
    }
}

function Get-AllConfiguredPaths {
    param (
        [PSCustomObject]$settings
    )
    
    $paths = @()
    
    # Add default path if configured
    if ($settings.DefaultPath -and (Test-Path $settings.DefaultPath)) {
        $paths += @{
            Path = $settings.DefaultPath
            Depth = $settings.DefaultPathDepth
            Name = "Default"
        }
    }
    
    # Add Ctrl path if configured
    if ($settings.CtrlPath -and (Test-Path $settings.CtrlPath)) {
        $paths += @{
            Path = $settings.CtrlPath
            Depth = $settings.CtrlPathDepth
            Name = "Ctrl+Enter"
        }
    }
    
    # Add Shift path if configured
    if ($settings.ShiftPath -and (Test-Path $settings.ShiftPath)) {
        $paths += @{
            Path = $settings.ShiftPath
            Depth = $settings.ShiftPathDepth
            Name = "Shift+Enter"
        }
    }
    
    # Add Alt path if configured
    if ($settings.AltPath -and (Test-Path $settings.AltPath)) {
        $paths += @{
            Path = $settings.AltPath
            Depth = $settings.AltPathDepth
            Name = "Ctrl+Alt+Enter"
        }
    }
    
    return $paths
}

function Start-BackgroundIndexer {
    param (
        [PSCustomObject]$settings,
        [bool]$forceScan = $false
    )
    
    $indexInfo = Initialize-Index
    
    # Check if we need to index
    $needsIndex = $forceScan
    
    if (Test-Path $indexInfo.MetaFile) {
        try {
            $meta = Get-Content -Path $indexInfo.MetaFile | ConvertFrom-Json
            $lastIndexTime = [datetime]::Parse($meta.LastIndexed)
            
            # Index every 6 hours instead of daily for better freshness
            if ([datetime]::Now -gt $lastIndexTime.AddHours(6)) {
                $needsIndex = $true
            }
        } catch {
            $needsIndex = $true
        }
    } else {
        $needsIndex = $true
    }
    
    if ($needsIndex) {
        # Get all configured paths
        $allPaths = Get-AllConfiguredPaths -settings $settings
        
        if ($allPaths.Count -eq 0) {
            Write-Log "No valid paths configured for indexing" -Level "Warning"
            return @{ JobStarted = $false; Message = "No valid paths configured" }
        }
        
        # Start background indexing job for all paths
        $job = Start-Job -ScriptBlock {
            param($allPaths, $indexFile, $metaFile)
            
            try {
                # Use optimized directory enumeration
                $allFolders = [System.Collections.Generic.List[PSObject]]::new()
                
                # Recursive function for efficient directory traversal
                function Get-DirectoriesRecursive {
                    param(
                        [System.IO.DirectoryInfo]$dir,
                        [int]$currentDepth,
                        [int]$maxDepth,
                        [string]$basePath,
                        [string]$pathName
                    )
                    
                    if ($currentDepth -gt $maxDepth) { return }
                    
                    try {
                        foreach ($subDir in $dir.GetDirectories()) {
                            $relativePath = $subDir.FullName.Replace($basePath, "").TrimStart('\')
                            
                            $folderObj = [PSCustomObject]@{
                                Name = $subDir.Name
                                FullPath = $subDir.FullName
                                RelativePath = $relativePath
                                LastModified = $subDir.LastWriteTime
                                SearchPath = $basePath
                                PathName = $pathName
                                # Pre-compute search terms for faster lookup
                                SearchTerms = @(
                                    $subDir.Name.ToLower()
                                    $relativePath.ToLower()
                                    ($subDir.Name -replace '[^a-zA-Z0-9]', '').ToLower()
                                )
                            }
                            
                            $allFolders.Add($folderObj)
                            
                            # Recurse into subdirectories
                            Get-DirectoriesRecursive -dir $subDir -currentDepth ($currentDepth + 1) -maxDepth $maxDepth -basePath $basePath -pathName $pathName
                        }
                    } catch {
                        # Skip inaccessible directories
                        continue
                    }
                }
                
                # Index all configured paths
                foreach ($pathConfig in $allPaths) {
                    $dirInfo = [System.IO.DirectoryInfo]::new($pathConfig.Path)
                    Get-DirectoriesRecursive -dir $dirInfo -currentDepth 0 -maxDepth $pathConfig.Depth -basePath $pathConfig.Path -pathName $pathConfig.Name
                }
                
                # Create optimized  index structure
                $index = @{
                    Folders = $allFolders.ToArray()
                    TotalCount = $allFolders.Count
                    IndexedAt = [datetime]::Now.ToString("o")
                    IndexedPaths = $allPaths
                    PathCount = $allPaths.Count
                }
                
                # Save index with compression
                $jsonContent = $index | ConvertTo-Json -Depth 5 -Compress
                [System.IO.File]::WriteAllText($indexFile, $jsonContent, [System.Text.Encoding]::UTF8)
                
                # Save metadata
                $meta = @{
                    LastIndexed = [datetime]::Now.ToString("o")
                    FolderCount = $allFolders.Count
                    PathCount = $allPaths.Count
                    IndexedPaths = $allPaths
                    IndexSize = (Get-Item $indexFile).Length
                }
                
                $metaContent = $meta | ConvertTo-Json -Compress
                [System.IO.File]::WriteAllText($metaFile, $metaContent, [System.Text.Encoding]::UTF8)
                
                return @{
                    Success = $true
                    FolderCount = $allFolders.Count
                    PathCount = $allPaths.Count
                    Message = " index created successfully"
                }
                
            } catch {
                return @{
                    Success = $false
                    Error = $_.Exception.Message
                }
            }
        } -ArgumentList $allPaths, $indexInfo.IndexFile, $indexInfo.MetaFile
        
        # Store job reference for monitoring
        if (-not $global:IndexingJobs) {
            $global:IndexingJobs = @{}
        }
        $global:IndexingJobs[""] = $job
        
        Write-Log " background indexing started for $($allPaths.Count) paths"
        return @{ JobStarted = $true; JobId = $job.Id; PathCount = $allPaths.Count }
    } else {
        Write-Log " index is current"
        return @{ JobStarted = $false; Message = " index is current" }
    }
}

function Get-IndexStatus {
    $indexInfo = Initialize-Index
    
    if (Test-Path $indexInfo.MetaFile) {
        try {
            $meta = Get-Content -Path $indexInfo.MetaFile | ConvertFrom-Json
            return @{
                IsIndexed = $true
                LastIndexed = [datetime]::Parse($meta.LastIndexed)
                FolderCount = $meta.FolderCount
                PathCount = $meta.PathCount
                IndexSize = $meta.IndexSize
                IndexedPaths = $meta.IndexedPaths
            }
        } catch {
            return @{ IsIndexed = $false }
        }
    } else {
        return @{ IsIndexed = $false }
    }
}

function Perform_Scan {
    param (
        [PSCustomObject]$settings,
        [bool]$forceScan = $false
    )

    Write-Log "Starting  smart indexing for all configured paths"
    
    try {
        # Update UI to show indexing status
        if ($window -and $window.FindName("StatusMessageSettings")) {
            $window.FindName("StatusMessageSettings").Text = "Starting  indexing of all paths..."
        }
        
        # Start  background indexing
        $result = Start-BackgroundIndexer -settings $settings -forceScan $forceScan
        
        if ($result.JobStarted) {
            if ($window -and $window.FindName("StatusMessageSettings")) {
                $window.FindName("StatusMessageSettings").Text = "Background indexing in progress for $($result.PathCount) paths... (Job ID: $($result.JobId))"
            }
            Write-Log " background indexing job started with ID: $($result.JobId) for $($result.PathCount) paths"
        } else {
            if ($window -and $window.FindName("StatusMessageSettings")) {
                $window.FindName("StatusMessageSettings").Text = " index is current. $($result.Message)"
            }
            Write-Log " indexing not needed: $($result.Message)"
        }
        
        # Update last scan date display
        $status = Get-IndexStatus
        if ($status.IsIndexed -and $window -and $window.FindName("LastScanDate")) {
            $formattedDate = $status.LastIndexed.ToString("MM/dd/yy HH:mm")
            $window.FindName("LastScanDate").Content = "Last Indexed: $formattedDate ($($status.FolderCount) folders from $($status.PathCount) paths)"
        }
        
    } catch {
        Write-Log "Error during  smart indexing: $_" -Level "Error"
        if ($window -and $window.FindName("StatusMessageSettings")) {
            $window.FindName("StatusMessageSettings").Text = "Error during  indexing. Check logs for details."
        }
    }
}


function Convert-MarkdownToXaml {
    param (
        [Parameter(Mandatory = $true)]
        [string]$markdownPath
    )

    # Check if markdown file exists
    if (-not (Test-Path $markdownPath)) {
        Write-Log "Markdown file not found: $markdownPath" -Level "Error"
        return $null
    }

    try {
        # Read markdown content
        $markdownContent = Get-Content -Path $markdownPath -Raw

        # Convert markdown to HTML-like structure
        $converted = @"
<FlowDocument xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
              xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <FlowDocument.Resources>
        <Style TargetType="{x:Type Paragraph}">
            <Setter Property="Margin" Value="0,0,0,10"/>
        </Style>
    </FlowDocument.Resources>
"@

        # Split content into lines
        $lines = $markdownContent -split "`n"
        $inList = $false
        $inCodeBlock = $false
        $codeContent = ""

        foreach ($line in $lines) {
            $line = $line.Trim()
            
            # Skip empty lines
            if ([string]::IsNullOrWhiteSpace($line)) { continue }

            # Handle headers
            if ($line -match '^#{1,6}\s+(.+)$') {
                $headerLevel = ($line -split ' ')[0].Length
                $headerText = $matches[1]
                $fontSize = 24 - ($headerLevel * 2)
                $converted += "`n    <Paragraph FontSize=`"$fontSize`" FontWeight=`"Bold`">$headerText</Paragraph>"
                continue
            }

            # Handle code blocks
            if ($line -match '^```') {
                if ($inCodeBlock) {
                    $converted += "`n    <Paragraph FontFamily=`"Consolas`" Background=`"#f0f0f0`" Padding=`"10`">$codeContent</Paragraph>"
                    $inCodeBlock = $false
                    $codeContent = ""
                } else {
                    $inCodeBlock = $true
                }
                continue
            }

            if ($inCodeBlock) {
                $codeContent += [System.Security.SecurityElement]::Escape($line) + "`n"
                continue
            }

            # Handle bullet points
            if ($line -match '^\*\s+(.+)$') {
                if (-not $inList) {
                    $converted += "`n    <List MarkerStyle=`"Disc`">"
                    $inList = $true
                }
                $listText = $matches[1]
                $converted += "`n        <ListItem><Paragraph>$listText</Paragraph></ListItem>"
                continue
            } else {
                if ($inList) {
                    $converted += "`n    </List>"
                    $inList = $false
                }
            }

            # Handle bold text
            $line = $line -replace '\*\*(.+?)\*\*', '<Run FontWeight="Bold">\$1</Run>'

            # Handle italic text
            $line = $line -replace '_(.+?)_', '<Run FontStyle="Italic">\$1</Run>'

            # Handle links
            $line = $line -replace '$(.+?)$$(.+?)$', '<Hyperlink NavigateUri="\$2">\$1</Hyperlink>'

            # Regular paragraph
            $converted += "`n    <Paragraph>$line</Paragraph>"
        }

        if ($inList) {
            $converted += "`n    </List>"
        }

        $converted += "`n</FlowDocument>"

        return $converted
    }
    catch {
        Write-Log "Error converting markdown to XAML: $_" -Level "Error"
        return $null
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
    Title="Seeker" Height="350" Width="700" WindowStartupLocation="CenterScreen">
    <Window.Icon>
        <ImageSource x:Key="favicon.ico">$iconPath</ImageSource>
    </Window.Icon>
    <Grid>
        <TabControl>

<!-- Search Tab -->
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
                            <ColumnDefinition Width="100"/>
                        </Grid.ColumnDefinitions>
                        <TextBox x:Name="SearchBox" Grid.Column="0" VerticalAlignment="Stretch" Height="22"/>
                        <Button x:Name="SearchButton" Content="Search" Grid.Column="1" Margin="10,0,0,0" VerticalAlignment="Stretch" Height="22"/>
                    </Grid>
                    <ListBox x:Name="ListBox" Margin="10" Grid.Row="1"/>

                    <!-- Search Tab StatusBar -->
                    <StatusBar Grid.Row="2" VerticalAlignment="Bottom" Background="LightGray">
                        <StatusBarItem>
                            <TextBlock x:Name="StatusMessage" Text="" VerticalAlignment="Center"/>
                        </StatusBarItem>
                    </StatusBar>
                </Grid>
            </TabItem>

<!-- Settings Tab -->
            <TabItem Header="Settings">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/> <!-- Row for Default Path -->
                        <RowDefinition Height="Auto"/> <!-- Row for Ctrl+Enter Path -->
                        <RowDefinition Height="Auto"/> <!-- Row for Shift+Enter Path -->
                        <RowDefinition Height="Auto"/> <!-- Row for Alt+Enter Path -->
                        <RowDefinition Height="Auto"/> <!-- Row for Scan Checkbox -->
                        <RowDefinition Height="Auto"/> <!-- Row for Save Button -->
                        <RowDefinition Height="*"/>    <!-- Row for Status Message -->
                    </Grid.RowDefinitions>

                    <!-- Default Path -->
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="125"/>
                            <ColumnDefinition Width="*" />
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <Label Content="Default Path:" VerticalAlignment="Center" Grid.Column="0" Margin="0,0,5,0" />
                        <TextBox x:Name="DefaultPath" VerticalAlignment="Center" Grid.Column="1" Margin="0,0,5,0" Height="22"/>
                        <ComboBox x:Name="DefaultPathDepth" Grid.Column="2" Margin="0,0,5,0" VerticalAlignment="Center" ToolTip="Select the search depth for the default path. How many folders deep?">
                        <ComboBoxItem Content="1"/>
                            <ComboBoxItem Content="2"/>
                            <ComboBoxItem Content="3"/>
                            <ComboBoxItem Content="4"/>
                            <ComboBoxItem Content="5"/>
                        </ComboBox>
                        <Button x:Name="DefaultPathButton" Content="..." Grid.Column="3" Width="30" Height="22">
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
                            <ColumnDefinition Width="125"/>
                            <ColumnDefinition Width="*" />
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <Label Content="Ctrl+Enter Path:" VerticalAlignment="Center" Grid.Column="0" Margin="0,0,5,0"/>
                        <TextBox x:Name="CtrlPath" VerticalAlignment="Center" Grid.Column="1" Margin="0,0,5,0" Height="22"/>
                        <ComboBox x:Name="CtrlPathDepth" Grid.Column="2" Margin="0,0,5,0" VerticalAlignment="Center" ToolTip="Select the search depth for the Ctrl path. How many folders deep?">
                            <ComboBoxItem Content="1"/>
                            <ComboBoxItem Content="2"/>
                            <ComboBoxItem Content="3"/>
                            <ComboBoxItem Content="4"/>
                            <ComboBoxItem Content="5"/>
                        </ComboBox>
                        <Button x:Name="CtrlPathButton" Content="..." Grid.Column="3" Width="30" Height="22">
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
                            <ColumnDefinition Width="125"/>
                            <ColumnDefinition Width="*" />
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <Label Content="Shift+Enter Path:" VerticalAlignment="Center" Grid.Column="0" Margin="0,0,5,0"/>
                        <TextBox x:Name="ShiftPath" VerticalAlignment="Center" Grid.Column="1" Margin="0,0,5,0" Height="22"/>
                        <ComboBox x:Name="ShiftPathDepth" Grid.Column="2" Margin="0,0,5,0" VerticalAlignment="Center" ToolTip="Select the search depth for the Shift path. How many folders deep?">
                            <ComboBoxItem Content="1"/>
                            <ComboBoxItem Content="2"/>
                            <ComboBoxItem Content="3"/>
                            <ComboBoxItem Content="4"/>
                            <ComboBoxItem Content="5"/>
                        </ComboBox>
                        <Button x:Name="ShiftPathButton" Content="..." Grid.Column="3" Width="30" Height="22">
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
                            <ColumnDefinition Width="125"/>
                            <ColumnDefinition Width="*" />
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <Label Content="Ctrl+Alt+Enter Path:" VerticalAlignment="Center" Grid.Column="0" Margin="0,0,5,0"/>
                        <TextBox x:Name="AltPath" VerticalAlignment="Center" Grid.Column="1" Margin="0,0,5,0" Height="22"/>
                        <ComboBox x:Name="AltPathDepth" Grid.Column="2" Margin="0,0,5,0" VerticalAlignment="Center" ToolTip="Select the search depth for the Ctrl+Alt path. How many folders deep?">
                            <ComboBoxItem Content="1"/>
                            <ComboBoxItem Content="2"/>
                            <ComboBoxItem Content="3"/>
                            <ComboBoxItem Content="4"/>
                            <ComboBoxItem Content="5"/>
                        </ComboBox>
                        <Button x:Name="AltPathButton" Content="..." Grid.Column="3" Width="30" Height="22">
                            <Button.ToolTip>
                                <ToolTip>
                                    <TextBlock Text="Click to select the Alt Search Path path."/>
                                </ToolTip>
                            </Button.ToolTip>
                        </Button>
                    </Grid>
                    <!-- Scan Checkbox -->
                    <Grid Grid.Row="4">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*" />
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <CheckBox x:Name="ScanCheckbox" Content="Smart Index - Remote" Grid.Column="0" HorizontalAlignment="Left" Margin="5"
                                  ToolTip="Enable or disable smart indexing. When enabled, the application will index all configured paths in the background for ultra-fast searches. Recommended for local drives. May be slower for remote paths."/>
                        <Label x:Name="LastScanDate" Content="Not Indexed" Grid.Column="1" HorizontalAlignment="Right" Margin="0"/>
                        <Button x:Name="ForceScan" Content="Force Index" Grid.Column="2" Width="100" Height="22" HorizontalAlignment="Right" Margin="0,0,5,0">
                            <Button.ToolTip>
                                <ToolTip>
                                    <TextBlock Text="Click to force re-index all configured paths. Creates a  smart index, but searches respect keyboard modifiers (Ctrl, Shift, Alt) to search specific paths."/>
                                </ToolTip>
                            </Button.ToolTip>
                        </Button>
                    </Grid>

                    <!-- Save Button -->
                    <Grid Grid.Row="5">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*" />
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <Button x:Name="SaveSettingsButton" Content="Save Settings" Grid.Column="0" HorizontalAlignment="Stretch" Margin="10" Height="22"/>
                    </Grid>

                    <!-- Settings tab Status Bar -->
                    <StatusBar Grid.Row="6" VerticalAlignment="Bottom" Background="LightGray">
                        <StatusBarItem>
                            <TextBlock x:Name="StatusMessageSettings" Text="" VerticalAlignment="Center"/>
                        </StatusBarItem>
                    </StatusBar>
                </Grid>
            </TabItem>


<!-- About Tab -->
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

                                <ListBoxItem Content="v0.2 - Add Keybind path feature" Margin="1">
                                    <ListBoxItem.ToolTip>
                                        <ToolTip>
                                            <TextBlock Text="Added 18/JUL/24 the ability to set custom paths for Ctrl+Enter, Shift+Enter, and Alt+Enter keybinds."/>
                                        </ToolTip>
                                    </ListBoxItem.ToolTip>
                                </ListBoxItem>

                                <ListBoxItem Content="v0.3 - Add Warning Message when searching with 3 or fewer characters" Margin="1">
                                    <ListBoxItem.ToolTip>
                                        <ToolTip>
                                            <TextBlock Text="Added 19/JUL/24"/>
                                        </ToolTip>
                                    </ListBoxItem.ToolTip>
                                </ListBoxItem>
                                <ListBoxItem Content="v0.4 - Add Scan Checkbox" Margin="1">
                                    <ListBoxItem.ToolTip>
                                        <ToolTip>
                                            <TextBlock Text="Added 22/JUL/24"/>
                                        </ToolTip>
                                    </ListBoxItem.ToolTip>
                                </ListBoxItem>

                                <ListBoxItem Content="v0.5 - Add Force Scan Button" Margin="1">
                                    <ListBoxItem.ToolTip>
                                        <ToolTip>
                                            <TextBlock Text="Added 23/JUL/24/. Last Scanned Data label"/>
                                        </ToolTip>
                                    </ListBoxItem.ToolTip>
                                </ListBoxItem>

                                <ListBoxItem Content="v0.6 - Add Folder Depth integer." Margin="1">
                                    <ListBoxItem.ToolTip>
                                        <ToolTip>
                                            <TextBlock Text="Added 23/JUL/24. Allows user to define the depth at which they search. Will significantly increase search time per value increase." />
                                        </ToolTip>
                                    </ListBoxItem.ToolTip>
                                </ListBoxItem>

                                <ListBoxItem Content="v0.7 - Update Scan. Speed significantly improved." Margin="1">
                                    <ListBoxItem.ToolTip>
                                        <ToolTip>
                                            <TextBlock Text="Added 24/JUL/24. Changed the format of the data being pulled. Reduced from 12mb to 1.9mb for the contract folder"/>
                                        </ToolTip>
                                        </ListBoxItem.ToolTip>
                                </ListBoxItem>
                                <ListBoxItem Content="v0.8 - Improved Scan and Search Algorithm." Margin="1">
                                    <ListBoxItem.ToolTip>
                                        <ToolTip>
                                            <TextBlock Text="Added 30/JAN/25. Improved Scan and Search functions."/>
                                        </ToolTip>
                                        </ListBoxItem.ToolTip>
                                </ListBoxItem>
                                <ListBoxItem Content="v0.9 - Smart Index System (Everything-inspired)" Margin="1">
                                    <ListBoxItem.ToolTip>
                                        <ToolTip>
                                            <TextBlock Text="Added 29/AUG/25. Revolutionary smart indexing system inspired by 'Everything' app. Features:  index of ALL configured paths for efficiency, but searches respect keyboard modifiers (Ctrl, Shift, Alt) to search specific paths. Ultra-fast search (50-200ms), background indexing, multi-threaded processing, and automatic refresh every 6 hours."/>
                                        </ToolTip>
                                        </ListBoxItem.ToolTip>
                                </ListBoxItem>
                            </ListBox>

                            <ListBox Margin="5">
                                <TextBlock Text="Known Issues:" Margin="5" FontWeight="Bold"/>
                                <ListBoxItem Content="When Smart Index is enabled, keyboard modifiers (Ctrl, Shift, Alt) still work to search specific paths from the  index." Margin="1"/>
                                <ListBoxItem Content="Large directory structures (>50k folders across all paths) may take several minutes for initial indexing." Margin="1"/>
                                <ListBoxItem Content="Ensure all paths are accessible before enabling indexing to avoid errors." Margin="1"/>
                            </ListBox>

                            <ListBox Margin="5">
                                <TextBlock Text="Road Map:" Margin="5" FontWeight="Bold"/>
                                <ListBoxItem Content="Extend smart indexing to files (not just folders)" Margin="1"/>
                                <ListBoxItem Content="Incremental index updates for changed folders only" Margin="1"/>
                                <ListBoxItem Content="Real-time file system monitoring with instant updates" Margin="1"/>
                                <ListBoxItem Content="Search history and quick access to recent searches" Margin="1"/>
                                <ListBoxItem Content="Advanced search filters (date, size, type)" Margin="1"/>
                                <ListBoxItem Content="Multiple index profiles for different use cases" Margin="1"/>
                                <ListBoxItem Content="SharePoint integration for Sales team" Margin="1"/>
                                <ListBoxItem Content="Folder preview pane with metadata" Margin="1"/>
                                <ListBoxItem Content="Index compression and further storage optimization" Margin="1"/>
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
        if ($searchQuery.Length -le 2) {
            $window.FindName("StatusMessage").Foreground = "Red"
            $window.FindName("StatusMessage").Text = "Search query must be more than 3 characters."
            return
        }
        $window.FindName("StatusMessage").Foreground = "Black"

        $searchPath = $settings.DefaultPath
        $depth = $settings.DefaultPathDepth

        $results = Perform_Search -searchQuery $searchQuery -searchPath $searchPath -depth $depth
        Update_ListBox -results $results
    })
    
 
    $window.FindName("ListBox").Add_MouseDoubleClick({
        $selectedItem = $window.FindName("ListBox").SelectedItem
        if ($null -ne $selectedItem) {
            $folderPath = $selectedItem.FullPath
            $folderPathRelative = $selectedItem.RelativePath
            Start-Process "explorer.exe" -ArgumentList $folderPath
            $window.FindName("StatusMessage").Text = "Opening folder: $folderPathRelative"
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

    $window.FindName("ScanCheckbox").Add_Checked({
        $settings.Scan = $true
        if ($settings.Scan -eq $true) {
            Perform_Scan -settings $settings -forceScan $false
        }
    })

    $window.FindName("ScanCheckbox").Add_Unchecked({
        $settings.Scan = $false
    })

    # Update  index status display
    $status = Get-IndexStatus
    if ($status.IsIndexed) {
        $formattedDate = $status.LastIndexed.ToString("MM/dd/yy HH:mm")
        $sizeKB = [math]::Round($status.IndexSize / 1024, 1)
        $window.FindName("LastScanDate").Content = "Last Indexed: $formattedDate ($($status.FolderCount) folders from $($status.PathCount) paths, $sizeKB KB)"
    } else {
        $window.FindName("LastScanDate").Content = "Not Indexed"
    }
    
    $window.FindName("ForceScan").Add_Click({
        Perform_Scan -settings $settings -forceScan $true
    })
    
    $window.FindName("SaveSettingsButton").Add_Click({
        # Purge previous save by reinitializing or clearing settings
        if (Test-Path $settingsFile) {
            Remove-Item -Path $settingsFile -Force
        }
        $settings = New-Object PSObject -Property @{
            DefaultPath = ""
            DefaultPathDepth = 1
            CtrlPath = ""
            CtrlPathDepth = 1
            ShiftPath = ""
            ShiftPathDepth = 1
            AltPath = ""
            AltPathDepth = 1
            Scan = $false
        }
    
        # Assign new values from UI
        $settings.DefaultPath = $window.FindName("DefaultPath").Text
        $settings.DefaultPathDepth = $window.FindName("DefaultPathDepth").SelectedIndex + 1
        $settings.CtrlPath = $window.FindName("CtrlPath").Text
        $settings.CtrlPathDepth = $window.FindName("CtrlPathDepth").SelectedIndex + 1
        $settings.ShiftPath = $window.FindName("ShiftPath").Text
        $settings.ShiftPathDepth = $window.FindName("ShiftPathDepth").SelectedIndex + 1
        $settings.AltPath = $window.FindName("AltPath").Text
        $settings.AltPathDepth = $window.FindName("AltPathDepth").SelectedIndex + 1
        $settings.Scan = $window.FindName("ScanCheckbox").IsChecked
    
        # Save the new settings
        Save_Settings -settings $settings
    
        # Update UI to reflect the successful save
        $window.FindName("StatusMessageSettings").Text = "Settings saved successfully. $env:APPDATA\Seeker\settings.json"
    })

    $window.FindName("SearchBox").Add_KeyDown({
        param($eventSender, $e)
    
        # Debug: Output key and modifiers for troubleshooting
        #Write-Host "Key: $($e.Key), Modifiers: $($e.KeyboardDevice.Modifiers)"
    
        if ($e.Key -eq 'Enter') {
            #Clear listbox
            $window.FindName("ListBox").Items.Clear()

            $searchPath = $settings.DefaultPath
            $depth = $settings.DefaultPathDepth
            Write-Host "Default | Path $searchPath | Depth $depth"

            # Check and set search path based on modifiers
            $modifiers = [System.Windows.Input.Keyboard]::Modifiers

            if ($modifiers -band [System.Windows.Input.ModifierKeys]::Alt -and ($modifiers -band [System.Windows.Input.ModifierKeys]::Control))  {
                $searchPath = $settings.AltPath
                $depth = $settings.AltPathDepth
                Write-Host "Alt+Ctrl | Path $searchPath | Depth $depth"

            } elseif ($modifiers -band [System.Windows.Input.ModifierKeys]::Control) {
                $searchPath = $settings.CtrlPath
                $depth = $settings.CtrlPathDepth
                Write-Host "Ctrl | Path $searchPath | Depth $depth"

            } elseif ($modifiers -band [System.Windows.Input.ModifierKeys]::Shift) {
                $searchPath = $settings.ShiftPath
                $depth = $settings.ShiftPathDepth
                Write-Host "Shift | Path $searchPath | Depth $depth"
            }
        
            # Check if searchPath is null or empty and set status message
            if (-not $searchPath) {
                $statusMessage = $window.FindName("StatusMessage")
                $statusMessage.Foreground = "Red"
                $statusMessage.Text = "Please add a search path to the settings."
                return
            }
        
            # Validate the search query
            $searchQuery = $eventSender.Text
            if ($searchQuery.Length -le 2) {
                $statusMessage = $window.FindName("StatusMessage")
                $statusMessage.Foreground = "Red"
                $statusMessage.Text = "Search query must be more than 3 characters."
                return
            }
        
            # Reset status message color
            $window.FindName("StatusMessage").Foreground = "Black"
        
            # Perform search and update ListBox
            $results = Perform_Search -searchQuery $searchQuery -searchPath $searchPath -depth $depth
            Update_ListBox -results $results
        
            $e.Handled = $true
    }})
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

    if ($sortedResults.Count -eq 0) {
        $window.FindName("StatusMessage").Text = "No results found for the search query."
        return
    }
    foreach ($result in $sortedResults) {
        $listBox.Items.Add($result)
        $listBox.DisplayMemberPath = "RelativePath" # Display relative path in the ListBox
        $currentCount++ # Increment the count for each discovered result
        $window.FindName("StatusMessage").Text = "Searching... Found $currentCount folders."
        
        # Force the UI to update by processing other events
        [System.Windows.Threading.Dispatcher]::CurrentDispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Background, [Action]{$null})
    }
    if ($settings.Scan -eq $true){
        $pathDescription = "Smart Index."
    }else {
        $pathDescription = switch ($searchPath) {
            $settings.DefaultPath { "Default Path" }
            $settings.CtrlPath { "Ctrl+Enter Path" }
            $settings.ShiftPath { "Shift+Enter Path" }
            $settings.AltPath { "Ctrl+Alt+Enter Path" }
            else { "an unknown path" }
        }
    }
    
    $window.FindName("StatusMessage").Text = "Search completed. Found $currentCount folders in path - $pathDescription"
}

# Background job monitoring and cleanup for  indexing
function Update-IndexingStatus {
    if (-not $global:IndexingJobs) { return }
    
    $job = $global:IndexingJobs[""]
    
    if ($job -and $job.State -eq 'Completed') {
        try {
            $result = Receive-Job -Job $job
            Remove-Job -Job $job
            $global:IndexingJobs.Remove("")
            
            if ($result.Success) {
                Write-Log " background indexing completed successfully. Indexed $($result.FolderCount) folders from $($result.PathCount) paths."
                if ($window -and $window.FindName("StatusMessageSettings")) {
                    $window.FindName("StatusMessageSettings").Text = " indexing completed! Indexed $($result.FolderCount) folders from $($result.PathCount) paths."
                }
                
                # Update last scan date display
                $status = Get-IndexStatus
                if ($status.IsIndexed -and $window -and $window.FindName("LastScanDate")) {
                    $formattedDate = $status.LastIndexed.ToString("MM/dd/yy HH:mm")
                    $window.FindName("LastScanDate").Content = "Last Indexed: $formattedDate ($($status.FolderCount) folders from $($status.PathCount) paths)"
                }
            } else {
                Write-Log " background indexing failed: $($result.Error)" -Level "Error"
                if ($window -and $window.FindName("StatusMessageSettings")) {
                    $window.FindName("StatusMessageSettings").Text = " indexing failed. Check logs for details."
                }
            }
        } catch {
            Write-Log "Error processing  indexing job result: $_" -Level "Error"
        }
    } elseif ($job -and $job.State -eq 'Failed') {
        Write-Log " background indexing job failed" -Level "Error"
        Remove-Job -Job $job -Force
        $global:IndexingJobs.Remove("")
        
        if ($window -and $window.FindName("StatusMessageSettings")) {
            $window.FindName("StatusMessageSettings").Text = " indexing job failed. Check logs for details."
        }
    }
}

function Start-IndexMonitorTimer {
    # Create a timer to monitor  background indexing jobs
    $timer = New-Object System.Windows.Threading.DispatcherTimer
    $timer.Interval = [TimeSpan]::FromSeconds(2)
    
    $timer.Add_Tick({
        if ($global:IndexingJobs -and $global:IndexingJobs.Count -gt 0) {
            Update-IndexingStatus
        }
    })
    
    $timer.Start()
    return $timer
}

function Stop-IndexingJobs {
    if ($global:IndexingJobs) {
        foreach ($job in $global:IndexingJobs.Values) {
            if ($job.State -eq 'Running') {
                Stop-Job -Job $job -PassThru | Remove-Job -Force
            } else {
                Remove-Job -Job $job -Force
            }
        }
        $global:IndexingJobs.Clear()
    }
}

# Main script execution
try {
    Write-Log "Starting application with smart indexing"
    $settings = Load_Settings
    Write-Log "Settings loaded: $($settings | ConvertTo-Json -Compress)"
    
    $window = Initialize_Window -settings $settings
    if ($null -eq $window) {
        throw "Window could not be initialized"
    }
    
    # Start the index monitoring timer
    $indexTimer = Start-IndexMonitorTimer
    
    # Handle window closing to cleanup background jobs
    $window.Add_Closing({
        Write-Log "Application closing, cleaning up background jobs"
        Stop-IndexingJobs
        if ($indexTimer) {
            $indexTimer.Stop()
        }
    })
    
    $window.FindName("DefaultPath").Text = $settings.DefaultPath
    $window.FindName("DefaultPathDepth").SelectedIndex = $settings.DefaultPathDepth - 1
    $window.FindName("CtrlPath").Text = $settings.CtrlPath
    $window.FindName("CtrlPathDepth").SelectedIndex = $settings.CtrlPathDepth - 1
    $window.FindName("ShiftPath").Text = $settings.ShiftPath
    $window.FindName("ShiftPathDepth").SelectedIndex = $settings.ShiftPathDepth - 1
    $window.FindName("AltPath").Text = $settings.AltPath
    $window.FindName("AltPathDepth").SelectedIndex = $settings.AltPathDepth - 1
    $window.FindName("ScanCheckbox").IsChecked = $settings.Scan
    
    Write-Log "Window initialized successfully with smart indexing support"
    $window.ShowDialog() | Out-Null
}
catch {
    Write-Log "Error initializing application: $_" -Level "Error"
    Stop-IndexingJobs
    [System.Windows.MessageBox]::Show("Error initializing application: $_", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
}

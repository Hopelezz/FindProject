<#
The Original Script is just a command line interface that runs a hashtable of directories and indexes them. 
#>

# This sets the default directory to the one you 
$defaultPath = "E:\CodeBase\"

#Get Input for query
$searchInput = Read-Host -Prompt "Project Name or Number?"

IF ($searchInput.Length -lt 3) {
    # closes the script if the input is less than 3 characters
} ELSE {

    # Filters for F folders only
    $filter = $searchInput+"*"

    # Get Items
    $items = Get-ChildItem -Recurse -filter $filter -Directory -Path $defaultPath -Depth 1 

    #Build Hash Table 
    $hash = @{}
    $index = 1
    foreach( $item in $items)
    {
        $hash.add($index, $item.FullName)
        $index++
    }

    # Sorts Hash Table by index
    $hash.GetEnumerator() | Sort-Object -Property Name 

    #Ask Which Item 
    $inputindex = Read-Host -Prompt "Select Index #"

    $path = $hash.item([int]$inputindex)

    Start-Process $path

}
$SharepointSiteURL = "https://testtenant.sharepoint.com/sites/LargeListTest"
$ListName = "Documents"
$date = (Get-Date).AddMonths(-6)
Connect-PnPOnline -Url $SharepointSiteURL -Interactive
$Context = Get-PnPContext
Write-Host -f Yellow "Sorting List"
$ListItems = Get-PnPListItem -List $ListName -PageSize 2000 | Where-Object { $_.FileSystemObjectType -eq "File" }
Write-Host -f Yellow "Finished Sorting List"
Write-Host -f Yellow "Number of Files in List:"$ListItems.Count
ForEach ($Item in $ListItems) {
    $File = $Item.File
    $Versions = $File.Versions
    $Context.Load($File)
    $Context.Load($Versions)
    $Context.ExecuteQuery()
    Write-host -f Yellow "Checking:"$File.Name
    If ($Versions.Count -gt 0 -and $file.TimeLastModified -lt $date) {
        $Versions.DeleteAll()
        $Context.ExecuteQuery()
        Write-Host -f Green "Cleaning Version History:"$File.Name -
    }
}

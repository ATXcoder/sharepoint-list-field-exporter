function ExportLookups()
{
    Param
        (
             [Parameter(Mandatory=$true, Position=0)]
             [string] $SiteCollection,
             [Parameter(Mandatory=$true, Position=1)]
             [string] $ListName
        )
    cls
    Connect-PnPOnline -Url $SiteCollection -UseWebLogin

    # Get List
    $list = Get-PnPList -Identity $ListName

    # Get Fields in list
    $fields = Get-PnPField -List $list

    $data = @()

    foreach ($field in $fields)
    {
        $_lookupList = "N/A"
        $_lookupField = "N/A"

        # Check if field is a Lookup field
        if($field.FromBaseType -eq $false -and $field.CanBeDeleted -eq $true)
        {
            if($field.TypeAsString -like "Lookup")
            {
                $_lookupList = Get-PnPList -Identity $field.LookupList

                # Make sure lookup list is not empty
                if($_lookupList -eq $null -or $_lookupList -eq '')
                {
                    $_lookupList = "<List Not Found>"
                }

                $_lookupList = $_lookupList.Title
                $_lookupField = $field.lookupField
            }

            $Object = [PSCustomObject]@{
                    'Field Title' = $field.Title
                    'Field Type' = $field.TypeAsString
                    'Lookup List' = $_lookupList
                    'Lookup List ID' = $field.LookupList
                    'Lookup Field' = $_lookupField
                }
            $data += $Object
        }
    }
}
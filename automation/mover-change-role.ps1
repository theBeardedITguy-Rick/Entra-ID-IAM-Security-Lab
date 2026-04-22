# MOVER: Move Carlos Mendez from Ops-Technician to Ops-Manager

param(
    [string]$UserPrincipalName = "carlos.mendez@YOURTENANT.onmicrosoft.com"
)

$user = Get-MgUser -Filter "userPrincipalName eq '$UserPrincipalName'"
$oldGroup = Get-MgGroup -Filter "displayName eq 'Ops-Technician'"
$newGroup = Get-MgGroup -Filter "displayName eq 'Ops-Manager'"

if (-not $user) {
    Write-Error "User not found."
    exit
}

if (-not $oldGroup -or -not $newGroup) {
    Write-Error "Required group not found."
    exit
}

# Add to new group first
New-MgGroupMemberByRef `
    -GroupId $newGroup.Id `
    -BodyParameter @{
        "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$($user.Id)"
    }

# Remove from old group
Remove-MgGroupMemberByRef `
    -GroupId $oldGroup.Id `
    -DirectoryObjectId $user.Id

Write-Host "Moved $UserPrincipalName from Ops-Technician to Ops-Manager."

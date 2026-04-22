# JOINER: Create a new user and add them to the Ops-Technician group
# Update the domain if your tenant uses a different onmicrosoft.com name

param(
    [string]$DisplayName = "Sofia Martinez",
    [string]$MailNickname = "sofia.martinez",
    [string]$UserPrincipalName = "sofia.martinez@YOURTENANT.onmicrosoft.com",
    [string]$TempPassword = "TempPass123!"
)

# Find the target group
$group = Get-MgGroup -Filter "displayName eq 'Ops-Technician'"

if (-not $group) {
    Write-Error "Group 'Ops-Technician' not found."
    exit
}

# Create the user
$user = New-MgUser `
    -AccountEnabled:$true `
    -DisplayName $DisplayName `
    -MailNickname $MailNickname `
    -UserPrincipalName $UserPrincipalName `
    -PasswordProfile @{
        Password = $TempPassword
        ForceChangePasswordNextSignIn = $true
    }

# Add the user to the group
New-MgGroupMemberByRef `
    -GroupId $group.Id `
    -BodyParameter @{
        "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$($user.Id)"
    }

Write-Host "Created user $DisplayName and added them to Ops-Technician."

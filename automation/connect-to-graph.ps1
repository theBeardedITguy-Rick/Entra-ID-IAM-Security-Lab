# Connect to Microsoft Graph for IAM lab automation
# Run this first before using the other scripts

Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All","Directory.ReadWrite.All"

# Optional: show the current context
Get-MgContext

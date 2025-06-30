# Get the currently logged-on user from the console session
$loggedOnUser = (Get-WmiObject -Class Win32_ComputerSystem).UserName

if (-not $loggedOnUser) {
    Write-Output "No user is currently logged in."
    exit 1
}

# Extract just the username (strip DOMAIN\ or COMPUTERNAME\)
$loggedOnUserShort = $loggedOnUser.Split('\')[-1]

# Get the actual localized name of the Administrators group using its well-known SID: S-1-5-32-544
try {
    $adminGroupSID = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
    $adminGroupName = $adminGroupSID.Translate([System.Security.Principal.NTAccount]).Value.Split('\')[-1]
} catch {
    Write-Output "Failed to get localized Administrators group name."
    exit 1
}

# Get members of the localized Administrators group
$adminMembers = net localgroup "$adminGroupName"
$isAdmin = $false
if ($adminMembers -match $loggedOnUserShort) {
    Write-Output "$loggedOnUser IS a member of the local Administrators group ($adminGroupName)."
    $isAdmin = $true
} else {
    Write-Output "$loggedOnUser is NOT a member of the local Administrators group ($adminGroupName)."
    $isAdmin = $false
}

$complianceResult = @{
    "IsAdmin" = $isAdmin
    "Message" = "$loggedOnUser is NOT a member of the local Administrators group ($adminGroupName)."
}

return $complianceResult | ConvertTo-Json -Compress
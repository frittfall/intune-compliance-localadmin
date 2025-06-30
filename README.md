# Local Admin Status Check Script

This PowerShell script determines if the currently logged-on console user is a member of the local Administrators group. It is designed for use in automated compliance and reporting systems like Microsoft Intune.

## Functionality

- User Detection: Identifies the active console user via Win32_ComputerSystem. Exits if no user is logged on.
- Language Independent: Uses the well-known SID S-1-5-32-544 to resolve the name of the local Administrators group. This ensures the script works correctly on all language versions of Windows.
- Membership Check: Uses net localgroup to check if the user account is a member of the group.
- Structured Output: Returns a compressed JSON object as its output, making it easy to parse by management systems.

## Script Output

The script's standard output is a JSON string indicating the result.

## Intended Use: Intune Proactive Remediations

This package is designed as a two-part compliance check for Microsoft Intune.

1. Detection Script (.ps1): The PowerShell script itself. It is run on the client to get the current state.
2. Compliance Rule (.json): The accompanying JSON block defines the "compliant" state. It is not part of the script's execution but is used by the management system to evaluate the script's JSON output.

The provided JSON defines the following rule:

- Setting: It checks the IsAdmin key from the script's output.
- Condition: The device is considered compliant if IsAdmin is false.
- Remediation: If the device is non-compliant (IsAdmin is true), the RemediationStrings provide localized messages for the end-user or IT admin.

## Implementation guide

### Compliance Script

1. [Intune -> Devices -> Compliance -> Scripts](https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/compliance)
2. Add a script for _Windows 10 or later_
3. Name: `Local Admin Status Check`
4. Description: `Checks if the currently logged-on console user is a member of the local Administrators group.`
5. Publisher: `Paul`
6. Paste the detection script into the script editor.
7. Run this script using the logged on credentials: `No`
8. Enforce script signature check: `No`
9. Run script in 64-bit PowerShell host: `Yes`
10. Create the script.

### Compliance policy

1. [Intune -> Devices -> Windows -> Compliance](https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesWindowsMenu/~/compliance)
2. Create a new compliance policy for _Windows 10 or later_
3. Profile type _Windows 10/11 compliance policy_
4. Name: `Compliance - Enforce Standard User Privileges`
5. Description: `Enforces standard user privileges by checking if the currently logged-on console user is a member of the local Administrators group.`
6. Custom Compliance: `Require`
7. Select discovered script: **Local Admin Status Check**
8. Upload the compliance settings JSON file.
9. Assign the policy to the appropriate groups.
10. Review and create the policy.

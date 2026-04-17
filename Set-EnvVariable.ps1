# function to add a new user environmental variable

function Set-EnvVariable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Name,

        [Parameter(Mandatory, ParameterSetName = 'Set')]
        [string]
        $Value,

        [Parameter(ParameterSetName = 'Remove')]
        [switch]
        $Remove,

        [switch]
        $Machine
    )

    if ($Machine) {
        $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if (-not $isAdmin) {
            Write-Error "Setting Machine-scope variables requires administrator privileges."
            return
        }
        $scope = 'Machine'
    } else {
        $scope = 'User'
    }

    if ($Remove) {
        Write-Output "Removing persistent variable `"$Name`" from the $scope scope. Note: new powershell session required to reflect changes!"
        [Environment]::SetEnvironmentVariable($Name, $null, $scope)
    } else {
        Write-Output "Setting persistent variable `"$Name`" with value `"$Value`" in the $scope scope. Note: new powershell session required to reference!"
        [Environment]::SetEnvironmentVariable($Name, $Value, $scope)
    }
}
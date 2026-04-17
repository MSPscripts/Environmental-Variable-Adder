I found myself irritated as I fiddle-faddled with adding environmental variables to my workstation that I wanted to persist, like dev environment API keys, file paths that I wanted Powershell scripts
to be able to reference when my profile was being loaded, or similar stuff.

If you don't need a variable in your machine or userspace to persist - not useful! You can throw environment (or regular) variables in your Powershell profile, you can easily access, enumerate, and manipulate
the environmental variables in your space with $env:[whatever] or "Set-Location Env:". But if you do need persistence, I found this to be more pleasant than remembering the syntax for the .NET
method of [Environment]::SetEnvironmentVariable()

You can drop the function entirely in your profile, or simply dot-reference it.

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

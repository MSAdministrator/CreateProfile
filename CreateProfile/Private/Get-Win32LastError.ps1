<#
    .Synopsis
    This function will get the last win32 error produced by PowerShell
    .DESCRIPTION
    This function will get the last win32 error produced by PowerShell.  This function is more for interenal troubleshooting than the module itsef
    .EXAMPLE
    Get-Win32LastError -typeName $MethodName
#>
function Get-Win32LastError
{
  [CmdletBinding()]
  [Alias()]
  [OutputType([int])]
  Param(
    $typeName = 'LastError'
  )

  Write-Verbose -Message 'Getting the last win32 Error'

  if (-not ([System.Management.Automation.PSTypeName]$typeName).Type)
  {
    $lasterrorCode = $script:lasterror | ForEach-Object -Process {
      '[DllImport("kernel32.dll", SetLastError = true)]
      public static extern uint GetLastError();'
    }

    Add-Type -TypeDefinition @"
        using System;
        using System.Text;
        using System.Runtime.InteropServices;
        public static class $typeName {
            $lasterrorCode
        }
"@
  }
}

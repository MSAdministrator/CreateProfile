<#
    .Synopsis
    A function to add native .NET methods
    .DESCRIPTION
    A function that will add native .NET methods that may not be exposed naturally or need to be defined before being used
    .EXAMPLE
    Add-NativeMethod -typeName $MethodName
#>
function Add-NativeMethod
{
  [CmdletBinding()]
  [Alias()]
  [OutputType([int])]
  Param(
    $typeName = 'NativeMethods'
  )

  Write-Verbose -Message 'Adding Native Win32 Method'

  try
  {
    $nativeMethodsCode = $script:nativeMethods | ForEach-Object -Process {
      "
        [DllImport(`"$($_.Dll)`")]
        public static extern $($_.Signature);
      "
    }
 
    Add-Type -TypeDefinition @"
            using System;
            using System.Text;
            using System.Runtime.InteropServices;
            public static class $typeName {
                $nativeMethodsCode
            }
"@
  }
  catch
  {
    Write-Error -Message 'Error adding native method' -Exception $Error[0]
  }
}

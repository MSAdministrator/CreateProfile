<#
    .Synopsis
    This function will register a native method
    .DESCRIPTION
    This function will register an unregistered native method, which typically includes WIN_API classes
    .EXAMPLE
    Register-NativeMethod -dll 'usernv.dll' -methodSignature $MethodSignature
#>
function Register-NativeMethod
{
  [CmdletBinding()]
  [Alias()]
  [OutputType([int])]
  Param
  (
    # Param1 help description
    [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
    Position = 0)]
    [string]$dll,
 
    # Param2 help description
    [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
    Position = 1)]
    [string]
    $methodSignature
  )
 
  Write-Verbose -Message 'Registering native method'

  try
  {
    $script:nativeMethods += [PSCustomObject]@{
      Dll       = $dll
      Signature = $methodSignature
    }
  }
  catch
  {
    Write-Error -Message 'Error registering native method' -Exception $Error[0]
  }
}

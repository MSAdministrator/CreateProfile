<#
    .Synopsis
    This function will create a new user profile
    .DESCRIPTION
    This function will create a new local user and then map it to a user profile based on a SID.  After that it will load the user profile.
    .PARAMETER UserName
    This is the UserName of the User to be created
    .PARAMETER Password
    This is the Password of the User to be created
    .EXAMPLE
    New-Profile -UserName 'someusername' -password 'Password'
#>
function New-Profile
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
    [string]$UserName,

    # Param2 help description
    [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
    Position = 1)]
    [string]
    $Password
  )

  Write-Verbose -Message "Creating local user $UserName"

  try
  {
    New-LocalUser -username $UserName -password $Password
  }
  catch
  {
    Write-Error -Message $_.Exception.Message
    break
  }

  $methodName = 'UserEnvCP'
  $script:nativeMethods = @()

  if (-not ([System.Management.Automation.PSTypeName]$methodName).Type)
  {
    Register-NativeMethod -dll 'userenv.dll' -methodSignature `
    "int CreateProfile([MarshalAs(UnmanagedType.LPWStr)] string pszUserSid,`
      [MarshalAs(UnmanagedType.LPWStr)] string pszUserName,`
    [Out][MarshalAs(UnmanagedType.LPWStr)] StringBuilder pszProfilePath, uint cchProfilePath)"

    Add-NativeMethod -typeName $methodName
  }

  try
  {
    $localUser = New-Object -TypeName System.Security.Principal.NTAccount -ArgumentList ("$UserName")
    $userSID = $localUser.Translate([System.Security.Principal.SecurityIdentifier])
    $sb = New-Object -TypeName System.Text.StringBuilder -ArgumentList (260)
    $pathLen = $sb.Capacity

    Write-Verbose -Message "Creating user profile for $UserName"
  }
  catch
  {
    Write-Error -Message 'Error converting SID from account' -Exception $Error[0]
  }

  try
  {
    $null = [UserEnvCP]::CreateProfile($userSID.Value, $UserName, $sb, $pathLen)
  }
  catch
  {
    Write-Error -Message $_.Exception.Message
    break
  }
}

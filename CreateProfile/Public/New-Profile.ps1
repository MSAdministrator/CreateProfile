<#
.Synopsis
   This function will create a new user profile
.DESCRIPTION
   This function will create a new local user and then map it to a user profile based on a SID.  After that it will load the user profile.
.EXAMPLE
   New-Profile -UserName 'someusername' -password 'Password'
#>
function New-Profile {
 
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$UserName,
 
        # Param2 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]
        $Password
    )
  
    Write-Verbose "Creating local user $Username";
  
    try
    {
        New-LocalUser -username $UserName -password $Password;
    }
    catch
    {
        Write-Error $_.Exception.Message;
        break;
    }

    $methodName = 'UserEnvCP'
    $script:nativeMethods = @();
 
    if (-not ([System.Management.Automation.PSTypeName]$MethodName).Type)
    {
        Register-NativeMethod -dll "userenv.dll" -methodSignature `
            "int CreateProfile([MarshalAs(UnmanagedType.LPWStr)] string pszUserSid,`
            [MarshalAs(UnmanagedType.LPWStr)] string pszUserName,`
            [Out][MarshalAs(UnmanagedType.LPWStr)] StringBuilder pszProfilePath, uint cchProfilePath)";
 
        Add-NativeMethod -typeName $MethodName;
    }
 
    try
    {
        $localUser = New-Object System.Security.Principal.NTAccount("$UserName");
        $userSID = $localUser.Translate([System.Security.Principal.SecurityIdentifier]);
        $sb = new-object System.Text.StringBuilder(260);
        $pathLen = $sb.Capacity;
 
        Write-Verbose "Creating user profile for $Username";
    }
    catch
    {
        Write-Error -Message 'Error converting SID from account' -Exception $Error[0]
    } 

    try
    {
        [UserEnvCP]::CreateProfile($userSID.Value, $Username, $sb, $pathLen) | Out-Null;
    }
    catch
    {
        Write-Error $_.Exception.Message;
        break;
    }
}
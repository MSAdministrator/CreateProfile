<#
.Synopsis
   this function will create a new local user account
.DESCRIPTION
   This function will create a new local user account on the local system.
.EXAMPLE
   New-LocalUser -UserName 'SomeUserName' -Password 'Password'
#>
function New-LocalUser
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $UserName,

        # Param2 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]
        $Password
    )
        
    Write-Verbose -Message 'Attempting to create a new local user account'

    try
    {
        $system = [ADSI]"WinNT://$env:COMPUTERNAME";
        $user = $system.Create("user",$userName);
        $user.SetPassword($password);
        $user.SetInfo();
 
        $flag=$user.UserFlags.value -bor 0x10000;
        $user.put("userflags",$flag);
        $user.SetInfo();
 
        $group = [ADSI]("WinNT://$env:COMPUTERNAME/Users");
        $group.PSBase.Invoke("Add", $user.PSBase.Path);
    }
    catch
    {
        Write-Error -Message 'Error attempting to create new local user' -Exception $error[0]
    }
}
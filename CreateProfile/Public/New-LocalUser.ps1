<#
.Synopsis
<<<<<<< HEAD
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function New-LocalUser
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # Username of the new local user account you want to create
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias("name")] 
        [string]$UserName,

        # Param2 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Password
    )

    Begin
    {
        # intentionally left blank
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("$UserName on $env:COMPUTERNAME", "Creating Local User"))
        {
            try
            {
                $system = [ADSI]"WinNT://$env:COMPUTERNAME";
                $user = $system.Create("user",$UserName);
                $user.SetPassword($Password);
                $user.SetInfo();
 
                $flag=$user.UserFlags.value -bor 0x10000;
                $user.put("userflags",$flag);
                $user.SetInfo();
 
                $group = [ADSI]("WinNT://$env:COMPUTERNAME/Users");
                $group.PSBase.Invoke("Add", $user.PSBase.Path);
            }
            catch
            {
                Write-Warning
            }
        }
    }
    End
    {
        # intentionally left blank
    }
}


#Function to create the new local user first
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
        $userName,
        # Param2 help description
        [string]
        $password
    )
 
    $system = [ADSI]"WinNT://$env:COMPUTERNAME";
    $user = $system.Create("user",$userName);
    $user.SetPassword($password);
    $user.SetInfo();
 
    $flag=$user.UserFlags.value -bor 0x10000;
    $user.put("userflags",$flag);
    $user.SetInfo();
 
    $group = [ADSI]("WinNT://$env:COMPUTERNAME/Users");
    $group.PSBase.Invoke("Add", $user.PSBase.Path);
=======
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
>>>>>>> fb704c864af24cdab64a7f52ecd204394456a1e2
}
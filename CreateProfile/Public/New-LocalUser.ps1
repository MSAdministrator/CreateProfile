<#
    .Synopsis
    Create a new Local User
    .DESCRIPTION
    Create a new Local User with password set to never expire
    .PARAMETER UserName
    This is the UserName of the User to be created
    .PARAMETER Password
    This is the Password of the User to be created
    .PARAMETER Whatif
     WhatIF
    .PARAMETER Confirm
     Confirm Action
    .EXAMPLE
    New-LocalUser -UserName "MyUSer" -Password "MySecurePassword"

#>
function New-LocalUser
{
  [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1',
      SupportsShouldProcess = $true,
      PositionalBinding = $false,
      HelpUri = 'http://www.microsoft.com/',
  ConfirmImpact = 'Medium')]
  [Alias()]
  [OutputType([String])]
  Param
  (
    # Username of the new local user account you want to create
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
        ValueFromRemainingArguments = $false,
    Position = 0)]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [Alias('name')]
    [string]$UserName,

    # Param2 help description
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
        ValueFromRemainingArguments = $false,
    Position = 1)]
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
    Write-Verbose -Message 'Attempting to create a new local user account'
    if ($pscmdlet.ShouldProcess("$UserName on $env:COMPUTERNAME", 'Creating Local User'))
    {
      try
      {
        $system = [ADSI]"WinNT://$env:COMPUTERNAME"
        $user = $system.Create('user',$UserName)
        $user.SetPassword($Password)
        $user.SetInfo()

        $flag = $user.UserFlags.value -bor 0x10000
        $user.put('userflags',$flag)
        $user.SetInfo()

        $group = [ADSI]("WinNT://$env:COMPUTERNAME/Users")
        $group.PSBase.Invoke('Add', $user.PSBase.Path)
      }
      catch
      {
        Write-Error -Message 'Error attempting to create new local user' -Exception $error[0]
      }
    }
  }
  End
  {
    # intentionally left blank
  }
}


#requires -Version 2

  <#
  .SYNOPSIS
    Loads all functions into memory
  .DESCRIPTION
    Loads all functions into memory and only exports the public functions for use
  .NOTES
    Author: Josh Rickard & Thom Schumacher
    CreateDate: 04/01/2017 14:59:31
  #>

#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename
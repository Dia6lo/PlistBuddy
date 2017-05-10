Get-Module | Remove-Module
Import-Module "$(Split-Path $MyInvocation.MyCommand.Path)\PlistBuddy.psm1" -Verbose

Sort-Plist "D:\Dev\PlistBuddy\Info — копия.plist"
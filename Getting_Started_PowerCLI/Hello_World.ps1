<#Power CLI DEMO 2
.synopsis
    Loads modules, connects to vcenter and runs report on all vm's.
HELLO WORLD
#>

Import-Module Vmware.VimAutomation.Core

$cred = Get-Credential administrator@vsphere.local

Connect-VIServer 10.101.1.120 -cred $cred

$vms = Get-VM -Name *

$vms | ConvertTo-Html |out-file 'E:\A_Pluralsight\GettingStartedPowerCLI&Automation\VMReport.html'

Start-Process 'E:\A_Pluralsight\GettingStartedPowerCLI&Automation\VMReport.html'


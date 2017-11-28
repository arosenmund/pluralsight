<#

Module 3 Scripts and one liners below.  Use to follow along and learn.

#>
#As learned in Module 2 import modules and connect to vcenter.

Import-Module VMware.VimAutomation.core
Import-MOdule VMware.VimAutomation.Common
$credVC = get-credential administrator@vsphere.local
$credESX = get-credential root
$vc = Connect-VIServer -Server 10.101.1.120 -Credential $credVC
$esx = Connect-VIserver -Server 10.101.1.142 -Credential $credESX



#Get-VM

#1
Get-VM 

Get-VM -Server $esx

Get-Vm -server $vc -Name "*2012*"

Get-Vm -Server $vc -Datastore "datastore1"

Get-Vm -Server $esx -VirtualSwitch vSwitch0

Get-Vm -Server $esx -location "vm"

Get-Vm |FL *

$vm = Get-Vm|get-view

$vm.Config

$vm.Config.Version

$vm = Get-VM

###################

#Stop/Start VM

Start-VM

Start-VM -Server $esx -VM $vm -Confirm

Stop-VM -server $esx  -VM $vm -kill


#New-Snapshot

New-Snapshot -server $vc -VM $vm -Name "OH SNAP" -Description "before you broke me" -Quiesce -Memory
 
Get-Snapshot -server $vc -vm $vm -Name "*OH*"

$snap = Get-Snapshot -Server $esx -Vm $vm -Name "*OH*"

Remove-Snapshot -Snapshot $snap

Get-Snapshot -Server $vc -vm $vm


#New-VM

Get-VM

Get-Vm -Server $vc

New-Vm -vmhost 10.101.1.142 -Name "#1" 

$name = "Whatever I want"

$datastore = get-datastore -server $vc

New-Vm -Name "#2"  -Datastore $datastore -Version v13  -NumCpu 2 -DiskGB 10 -MemoryGB 2  -WhatIf
 
#Update-Tools

Update-tools -vm $vm -NoReboot


Get-VMGuest -VM $vm | Update-Tools -NoReboot 



#fin












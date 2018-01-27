######Welcome to Pluralisght##### I am Automatron########Please enjoy your automated experience.





#Import Core Module  - if not sure why this isn't working then go watch 
import-module vmware.vimautomation.core

#Establish Global Variables
#ESXI Credentials
$ESXI_Cred = get-credential root
#VCenter Credentials
$VCenter_Cred = get-credential administrator@bluerose.local
#ESXi host locations
$ESXI_1 = "10.101.1.149"
$ESXI_2 = "10.101.1.138"
#Vcenter locations
$Vcenter = "10.101.1.118"

#Connect to Each Instanct   * remember once connected it will 
#attempt all commands against all connected instances unless you specify *

$ESXI_1_server = Connect-VIServer $ESXI_1 -Credential $ESXI_Cred
$ESXI_2_server = Connect-VIServer $ESXI_2 -Credential $ESXI_Cred

$Vcenter_Server = Connect-VIServer $Vcenter -Credential $VCenter_Cred


#Mod 2
Get-VM * -server $vCenter 


#Mod 3
#Return the rest of the available properties form the query
$vm = Get-VM -server $vcenter  #GuestId
#Where are all of the settings and values?
$VM = Get-View -server $vcenter –ViewType VirtualMachine –filter @{“name”=“Win2012r2”}
$VM.summary.guest.toolsstatus
$VM.summary.config.numCpu

#


#Mod 4 -Performance


#Get-ESXTOP -Examples
#List Available Counters
Get-ESXTOP -server $esxi_1_server -Counter *
Get-ESXTOP -server $ESXI_1_server -CounterName VCPU |select *

$group = Get-ESXTOP -server $esxi_1_server -CounterName "SchedGroup"

$group.powerinwatt

Get-ESXTOP -server $esxi_1_server -CounterName VCPU |select costoptimeinusec|%{$totsCoS = $totsCos + $_.costoptimeinusec} 
##############################################################################################################################
#all samples vs 1 sample
$stats = Get-Stat -Entity Br-vc-01 -Stat * -MaxSamples 1

$stats.count

get-stat -entity br-vc-01 -cpu -maxsamples 1 -Realtime
get-stat -entity br-vc-01 -network -maxsamples 1 -Realtime
get-stat -entity br-vc-01 -disk -maxsamples 1 -Realtime
get-stat -entity br-vc-01 -memory -maxsamples 1 -Realtime
get-stat -entity br-vc-01 -common -maxsamples 1 -Realtime

$Costop = Get-Stat  -Entity Br-vc-01 -Stat * -maxsamples 1 |where {($_.metricid -eq "cpu.costop.summation")}|select Value

$Costop
######################################################################################################################

$VMView = Get-View -viewtype VirtualMachine -server $Vcenter_server

$Vmview

$SecOnion = $vmview |where {($_.config.name -eq "SecurityOnion")}

$SecOnion.summary.QuickStats

##################################################################


#Mod 5

$esx = get-esx -server $ESXI_1 -Credential $ESXI_Cred

Get-VMHost -server $vcenter

Disconnect-ViServer $ESXI_1

Get-VMHost -server $ESXI_1
$VMHost = Get-VMHost -server $vcenter_server |select * 
$vmhost |Out-GridView -Title "All VMHost Info" -OutputMode Multiple

$VMHost.CustomFields
$vmhost.DatastoreIdList
$VMhost.extensionData
 
################################################################

#Mod 6

get-datastore -server $Vcenter_server

Get-Datastore -server $Vcenter_server | Select * 

$Datastores = Get-Datastore -server $Vcenter_server | Select * # |Out-GridView

$DrillDown = $Datastores | where {($_.FreeSpaceGB -gt 200)}
$DrillDown |ft -auto
$DataSpecific = $Datastores | where{($_.name -eq "ESXI-1-R1-3")}
$Dataspecific.ExtensionData
$Dataspecific.ExtensionData.overallstatus
################################################################

Get-Datastorecluster -server $Vcenter_server | select *

$cluster = Get-Datastorecluster -server $VCenter_Server
$cluster.extensiondata
$cluster.extensiondata.ChildEntity
$Cluster.extensiondata.OverallStatus


######################################################

$luns = Get-ScsiLun -VMHOST $ESXI_1 -luntype disk   

GET-SCSILUNPATH -scsilun $luns |ft -AutoSize

import-module vmware.vimautomation.storage
get-command | where -property source -like "vmware.vimautomation.storage"

#################################################################################

#Mod 7 - netwarking

get-virtualswitch -server $vcenter  | select *

$VSW = get-virtualswitch -server $vcenter |select *

$vsw.ExtensionData.mtu   #note on mtu importance in jumbo frames
$vsw.ExtensionData.Pnic
$vsw.ExtensionData.Portgroup

###################################################################################

$PG = Get-VirtualPortGroup -server $vcenter_server  |select *

$PG.port

$PG.extensiondata
$PG.extensiondata.computedpolicy.security

#importing a vds module

import-module Vmware.vimautomation.vds
get-command | where -property source -like "vmware.vimautomation.vds"


Get-VDSwitch -server $vcenter_server

Get-VDPortgroup -server $vcenter_server

Get-VMHostNetwork |select * |ft -AutoSize
$Hostnet = Get-VMHostNetworkAdapter |select *
$hostnet |ft -AutoSize

Get-VMHostNetworkadapter -server $Vcenter_server | select * |Out-GridView
Get-VMHostNetworkadapter -server $Vcenter_server -Physical
Get-VMHostNetworkadapter -server $Vcenter_server -VMKernel

$HostAdap = Get-VMHostNetworkadapter -server $VCenter | select *
$HostAdap.extensiondata
$HostAdap.extensiondata.PCI
$HostAdap.extensiondata.Driver




Get-Networkadapter -VM $VM |select *
$vmnet = Get-Networkadapter -VM $VM
$vmnet.connectionstate

#####################################################################################

#Mod 8
import-module VMware.VimAutomation.Vds

$esx = get-esxcli -V2 -VMHost $ESXI_1

$esx.network
$esx.network.diag.ping.CreateArgs()
$ping = $esx.network.diag.ping.invoke(@{host="10.101.1.118"})
$ping.trace
$ping.summary

$esx.network.nic.list.invoke()
$esx.network.vswitch.standard.list.invoke()

############################################


$vsw = Get-VirtualSwitch -server $vcenter_server -standard
get-nicteamingpolicy -Server $vcenter_server -VirtualSwitch $vsw

$pg = get-virtualportgroup -server $vcenter_server -standard
Get-NicTeamingPolicy -server $vcenter_server -virtualportgroup $pg



#Virtual Distributed Switches

$vpg = get-virtualportgroup -server $vcenter_server -Distributed


Get-VDPortgroupOverridePolicy -VDPortgroup "DSwitch-1-DVUplinks-65" -Server $vcenter_server

Get-VDSecurityPolicy -server $vcenter_server -VDSwitch *

Get-VDTrafficShapingPolicy -Server $vcenter_server -VDSwitch * -Direction Out

Get-VDUplinkLacpPolicy -Server $vcenter_server -VDSwitch * 

$uplink = Get-VDUplinkTeamingPolicy -server $vcenter_server -VDSwitch *
$uplink.ActiveUplinkPort

############

#Mod 9

$cluster = Get-Cluster | select * 
$cluster.extensiondata.Datastore
$cluster.extensiondata.OverallStatus
$cluster.extensiondata.ActionHistory


Get-DrsRule -Cluster *

Get-DrsRecommendation -Cluster *

Get-HAPrimaryVMHost -Cluster *


############################################################

#Mod 10

import-module VMware.VumAutomation


Get-Baseline -Server $vcenter |select * |Out-GridView

$Baseline = Get-Baseline -Server $vcenter 

$Baseline.CurrentPatches
$Baseline.lastupdatetime

##########################
Get-Patch -Server $VCenter |select *| out-gridview
$patch = Get-Patch -Server $VCenter                                  
$critpatch = $patch |where {($_.Severity -eq "Critical")}

Get-PatchBaseline -server $vcenter |select * | out-gridview


Get-Vm -name * -Server $vcenter | get-compliance -server $vcenter |select *

#############################################

Get-VmHostProfile -server $VCenter

$HP = Get-VmHostProfile -server $vCenter

$HP.ExtensionData
$HP.extensionData.ComplianceStatus

#########################################################

#Mod 11

Get-VIAccount -server $vcenter |select * |ft -AutoSize

Get-VIPermission -server $esxi_1 -Principal root

Get-VIRole admin -server $vcenter |select *

$Accounts = Get-VIRole admin -server $vCenter | select *
$Accounts.PrivilegeList

Get-VIPrivilege -server $vcenter |select *


Get-VMHostFirewallDefaultPolicy -Server $vcenter -VMHost $esxi_1 |select *

$FWP = Get-VMHostFirewallDefaultPolicy -Server $vcenter -VMHost $esxi_1 |select *

$fwp.ExtensionData


Get-VMHostFirewallException -VMHost $esxi_1

$esxi_1_cli = get-esxcli $esxi_1

$esxi_1_cli.network.firewall.ruleset.list()


Get-VMHostService -server $vcenter -VMHost $ESXI_1




Get-VMHostStartPolicy -VMHost $esxi_1

















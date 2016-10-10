####SnapShot VM
###############Aaron Rosenmund
##############################10-2-16

#Add PowerVI tools snapin.

function Initial-ize{
                     Add-PSSnapin VMware.VIMautomation.Core
                     #Connect to VI server:
                     $cred = Get-Credential
                     Connect-VIServer 10.101.1.142 -Credential $cred
                     #Store list of current VM's to a variable and list by name for later use.
                     $Vms = Get-vm
                     $Vms = $Vms.name
                     $Vms
                    }

#If you want to take a snap shot of all vm's then use no further filtering.  Alternatively you can

$Vms = Get-vm -name "*test01*"
$Vms = $Vms.name 
$Vms

#Next you will want to remove all the old snaphsots of your working servers/workstations.
##Save snapshots to remove into a variable and remove.

function Remove-Snaps{   
                      $OldSnaps = get-snapshot -vm *
                      Remove-Snapshot -Snapshot $OldSnaps
                     }
 
#stop machines

Stop-VM -vm *

#Take new snapshots

 function Make-Snaps{ 
                     foreach($vm in $Vms){
                                          $SnapName = $vm +"-prepatch10-9"
                                          New-Snapshot -VM $vm -Name $SnapName
                                         }
                    }

#power on machines
 start-vm -vm *
#perform updates
#if there is a problem can revert whole system to snapshot like this:

#use the below command to revert to the old snapshot one by one.
stop-vm "TEST01"

Set-vm -vm "TEST01" -SnapShot "TEST01-prepatch10-9"
 

#now you just saved some serious time all while maintaining failsafes for your update operation

#if you need to rever to your "known good" use the snippet below while making sure to run this on the most recent snapshot.

Function revert {
           foreach($vm in $Vms){
                                $snap = Get-Snapshot -VM $vm | Sort-Object -Property Created -Descending | Select -First 1
                                Set-VM -VM $vm -SnapShot $snap -Confirm:$false
                               }
          }

#And thats it!



#www.github.com/arosenmund/pluralsight/
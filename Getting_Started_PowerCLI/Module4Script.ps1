<#

Module 4 follow along script.  Can be ran all at once.


#>

#ALL setup actions and global variables.  GLOBAL VARIABLES
$date = get-date
$reportTXT = 'E:\A_Pluralsight\GettingStartedPowerCLI&Automation\Report.txt'
$reportHTML = 'E:\A_Pluralsight\GettingStartedPowerCLI&Automation\Report.html'
import-module vmware.vimautomation.core
$credvc = Get-Credential administrator@vsphere.local
$credESX = Get-Credential root
#$vc = Connect-VIServer -server 10.101.1.120 -Credential $credvc #replace with your vcenter's ip or dns name and your credentials
$esx = Connect-VIserver -Server 10.101.1.142 -Credential $credESX

#Reporting start of script
$log = "Started update and linked clone create script on $date"
$log |Out-File $reportTXT -Append

#################################################
############################LIST VM's to REPLICATE
#select vm's for action.

$VMs = get-vm -server $esx -Name "*Engineering*"

#output to show you have the right one
$VMs

#report to log file
$Name = $Vms.name
$log = "Selected the following VM's for action"
$log |out-file $reportTXT -Append
$Name |out-file $reportTXT -Append

#################################################
######################TURN MACHINES ON
#check for powerstate of vm's and turn on if on.

foreach( $vm in $VMs){
#action and reporting for each vm
                        $state = $vm.powerstate
                        
                        if($state -like "PoweredOff")
                                                 {
                                                    write-host "Powering $VM on" -ForegroundColor Yellow
                                                    start-vm -server $esx -VM $VM
                                                    $log = "Powered on $VM"
                                                    $log |out-file $reportTXT -Append
                                                 }
                                                 Else{
                                                        write-host "$VM already on"
                                                        $log = "$VM already on"
                                                        $log |out-file $reportTXT -Append

                                                     }

}

####give time for full system startup
write-host "Waiting 2min for machine $vms start up" -foreground red -background black
start-sleep 120

###############################################################################################
################################UPDATE TOOLS & STOP VM
#Update-Tools note: an older or same version of tools has to be already on the machine for the update to to work.
Foreach($vm in $VMS)

                    {

                      write-host "Updating tools on $vm" -ForegroundColor Green -BackgroundColor Black
                      
                      Update-Tools -server $esx -vm $vm -NoReboot
                      start-sleep 60 
                      
                      $log = "Updated tools on $vm at $date"
                      $log |out-file $reportTXT -Append
                      Shutdown-VMGuest -server $esx -VM $vm -confirm:$false
                    }



#################################################################################
#####################################SNAPSHOTS
#check current snapshots and remove old ones
Write-host "Deleting old snapshots for $vms" -foreground red -background black

$Snaps = get-snapshot -Server $esx -VM $VMs 

$OldSnaps = $Snaps | Where{($_.Created -like "*"<#-lt $date#>)} #where-object filter: where is an alias for where-object commandlet

$log ="The following snapshots were found older than todays day and removed:"

$log |out-file $reportTXT -Append
$OldSnaps |out-file $reportTXT -Append

Remove-Snapshot  -Snapshot $OldSnaps -confirm:$false


#Create a new snapshot.

foreach($vm in $Vms)
                    {
                        $name = $vm.Name
                      
                        new-snapshot -Server $esx -vm $vm -name "$name - daily snap" -description "a snap a day keeps the resume away" -Quiesce
                        
                        $log = "Created snaphsot for $vm on $date"

                        $log | Out-file $reportTXT -Append
                    }

######################################################################################
###############################CREATE LINKED CLONES
#select snapshot 
$vc = Connect-VIServer -server 10.101.1.120 -Credential $credvc
start-sleep 10

$VM = get-vm -Server $vc -Name "Engineering#1"

$snap = Get-Snapshot -VM $VM

#make many linked clone from snapshot

$vmhost = Get-VMHost -Server $vc



$vmcount = 10
$i = 0
while($i -lt $vmcount)
                        {

                            $name = "Engineering"+$i
                           
                            new-vm -server $vc -LinkedClone -vm $vm -Name $name -ReferenceSnapshot $snap -VMHost $vmhost -RunAsync
                            $log = "Created Linked Clone of "+$vm.name+" called $name"
                            $log |Out-File $reportTXT -Append    
                            $i++
                        }
#start machines
$engvm = get-vm -server $esx |where{($_.PowerState -eq "PoweredOff" -and $_.name -like "Engineering#1")} 
$engvm | Start-VM

$log = "Started all machines:"
$log|out-file $reportTXT -Append
$engvm |out-file $reportTXT -Append

#####Report

start-process $reportTXT


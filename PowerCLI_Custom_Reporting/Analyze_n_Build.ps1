 #Analyze and Build

# Mod 2 Referenced Commands Results Analysis
$data = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\VMS.xml"
#count export
$VM_Count = $data.count
$VM_Count | Export-Clixml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\VM_Count.xml"
#powerstate export
$VM_ON = $data.powerstate | Where{($_.Value -eq "PoweredOn")}
$VM_ON.count | Export-Clixml -Path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\VM_On.xml"
#cpu count 
$CPU_Allocated = $data.NumCPU
$CPU_Allocated.count
#memory count
$Mem_Allocated = $data.memoryGB
#memory totalling function
$i = $Mem_Allocated.count
$s = 0; $c = 0
While($s -le $i){$c = $c + $Mem_Allocated[$s]; $s++}
#total memory export
$Mem_Allocated = $C
$Mem_Allocated |Export-Clixml -Path   "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\Mem_Alloc.xml"
#cpu totalling fnction
$CPUs_Allocated = $data.numcpu
$i = $CPUs_Allocated.count
$s = 0; $c = 0
While($s -le $i){$c = $c + $CPUs_Allocated[$s]; $s++}
#total memory export
$CPUs_Allocated = $c
$CPUs_Allocated |Export-Clixml -Path   "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\Cpus_Alloc.xml"


#Mod3 Referenced Commands Results Analysis
#import data from xml
$data = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\VMDetails.xml"

#load specific metric used space gb
$data = $data.UsedSpaceGB

#used space totalling function
$i = $data.count
$s = 0; $c = 0
While($s -le $i){$c = $c + $data[$s]; $s++}
#Export totaled used GB
$total_usedGB = $c
$total_usedGB |Export-Clixml -Path   "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\VM_UsedGB.xml"

#Import view details data
$data = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\VM_ViewDetails.xml"
#select overall status value
$green = $data | where {($_.OverallStatus.value -like "green")}
#store number of values that are green
$green = $green.count
$green | export-clixml -Path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\Num_NonGreenVM.xml"

############################################################

#Mod4 Referenced Commands Results Analysis

##Power in watts from combining each ESXI results
#Import data form esx1
$data_esx1 = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\ESXI1_Watts.xml"
#select power in watts
$data = $data_esx1.PowerinWatt 
#total across all worlds
$i = $data.count
$s = 0; $c = 0
While($s -le $i){$c = $c + $data[$s]; $s++}
#store total in variable
$ESXI_1_TotalWatts = $c

#Import data for esxi2
$data_esx2 = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\ESXI2_Watts.xml"
#select power in watts
$data = $data_esx2.PowerinWatt 
#total esx2 power in watts across all worlds
$i = $data.count
$s = 0; $c = 0
While($s -le $i){$c = $c + $data[$s]; $s++}
$ESXI_2_TotalWatts = $c
#add both esxi values
$TotalWatts = $ESXI_1_TotalWatts + $ESXI_2_TotalWatts
#export to xml for ingest into dashboard via php
$TotalWatts | export-clixml -Path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\TotalWatts.xml"
####

#Mod5 Referenced Commands Results Analysis

$data_host = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\Host_Info.xml"
$data_MaxMhz = $data_host.CpuTotalMhz -join '+'
$MaxMhz = Invoke-Expression $data_MaxMhz
$data_UsedMhz = $data_host.cpuusageMhz -join '+'
$UsageMhz = Invoke-Expression $data_UsedMhz
$PercentMhzUsed = ($UsageMhz/$maxMhz) * 100
$PercentMhzUsed | export-clixml -Path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\MhzCPUUsedPerc.xml"



#Mod6 Referenced Commands Results Analysis

#used in combo with vm size info in mod 3 results
$data_ds = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\DatastoreInfo.xml"
$data = $data_ds | where {($_.Name) -notlike "*-esxi"} |select -property CapacityGB
$data= $data.CapacityGB
$i = $data.count
$s = 0; $c = 0
While($s -le $i){$c = $c + $data[$s]; $s++}
$Total_DataStore_GB = $c
$Total_DataStore_GB |Export-Clixml -Path   "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\TotalDatastoreGB.xml"




$data_dse = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\DataStoreExtension.xml"
$data_good = $data_dse | where{($_.OverallStatus.value) -eq "green"}
$data_Over = $data_good.count/$data_dse.count * 100
$data_over | Export-Clixml -Path   "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\OverallDSGoodPerc.xml"



#Mod7  Referenced Commands Results Analysis
$data_had = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\HostAdapter.xml"
$data_had = $data_had | where {($_.ExtensionData.Key) -like "*PhysicalNic*"}
$data_PhyUp = $data_had | where {($_.ExtensionData.Key) -like "*PhysicalNic*" -and ($_.BitRatePerSec) -eq "100"}
$Data_had.count | Export-Clixml -Path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\TotalPhysicalNics.xml"
$Data_PhyUp.count | Export-Clixml -Path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\PhyNicswBit100.xml"

#Mod8 Referenced Commands Results Analysis
$data_esxnet1 = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\Esxnet1.xml"


$data_esxnet2 = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\Esxnet2.xml"

$uplinks = $data_esxnet1.uplinks + $data_esxnet2.uplinks
$uplinks.count | Export-Clixml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\UplinksNum.xml"


#Mod9

$data_cluster1 = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\Cluster.xml"
$data_cluster1.value | Export-Clixml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\ClusterStatus.xml"

#Mod 10

#used for module 12 bring it together

$data_lu = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\LatestUpdates.xml"
$c = $data_lu |Sort-Object 
$c = $c[0]
$date = get-date
$days_since_up = ($date - $c).days
$days_since_up | Export-Clixml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\DaysSinceLastUpdate.xml"





#Mod 11

$data_service1 = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\Services_ESXI1.xml"
$data_service1 = $data_service1 | where {($_.Required) -like "False" -and ($_.Running) -like "True"}

$data_service2 = Import-CLIxml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\ServicesESXI2.xml" #note to chagne _ at next gather n stoe run
$data_service2 = $data_service1 | where {($_.Required) -like "False" -and ($_.Running) -like "True"}
$ShouldRun =  $data_service1 + $data_service2
$ShouldRun.count | Export-Clixml -path "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\RunningServNotRequired.xml"



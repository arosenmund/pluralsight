import-module vmware.vimautomation.core
Function Connect_Environment(){
$script:vc_cred = get-credential administrator@bluerose.local  

$script:ESXI_Cred = Get-Credential root

$script:vcenter = "10.101.1.118"

$script:ESXI_1 = "10.101.1.149"

$script:ESXI_2 = "10.101.1.138"

$script:vcenter_serv = Connect-viserver $vcenter -Credential $vc_cred

$script:esxi_1_serv = Connect-Viserver $ESXI_1 -Credential $ESXI_Cred

$script:esxi_2_serv = Connect-Viserver $ESXI_2 -Credential $ESXI_Cred

}

Connect_Environment

$header =@"
<head>

    <style type"text/css">
    <!-
        body {
        font-family: Veranda, Geneva, Arial, Helvetica, sans-serif;
        background-color: darkblue;
        }

        #report {width: 835px; }
        table{
        border-collapse: collapse;
        border: none;
        front: 10pt Verdana, Geneva, Arial, Helvetica, sans-serif;
        color: black;
        margin-bottom: 10px;
        }

        table td{
        font-size: 12px;
        padding-left: 0px;
        padding-right: 20px;
        text-align: left;
        }

        table th {
        font-size: 12px;
        padding-left: 0px;
        padding-right: 20px;
        text-align: left;
        }
        
        table.list{ float: left;}

        table.list td:nth-child(1){
        font-weight: bold;
        border-right: 1px grey solid:
        text-align: right;
        }

        table.list td:nth-child(2){padding-lef: 7px; }
        table tr:nth-child(even) td;nth-child(even){background: #BBBBBB;}
        table tr:nth-child(odd) td;nth-child(odd){background: #F2F2F2;}
        table tr:nth-child(even) td;nth-child(odd){background: #DDDDDD;}
        table tr:nth-child(odd) td;nth-child(even){background: #E5E5E5;}
        div.column {width: 320px: float: left;}
        div.second{ margin-left: 30px;}
        table{margin-left: 20px;}
        ->

    </style>

</head>
        
"@

function Global_Var(){   $Global:xmlpath =  "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\XML-STORE\"
                         $Global:htmlpath  = "E:\A_Pluralsight\powercli-vmware-vsphere-automated-reporting\DEMO_Scripts\WebPage\HTML-STORE\"

                    }

Global_Var
#######Gather and Store########################
#Referenced in Mod 2
$xmlname= $xmlpath + "VMS.xml"
$htmlname= $htmlpath + "VMS.html"
$info = get-vm * -server $vcenter

$info | Export-Clixml $xmlname
$info |convertto-html -Head $header | out-file $htmlname

#######################################################################
#Referenced in Mod 3

#Name of storage path and file
$xmlname= $xmlpath + "VMDetails.xml"
$htmlname= $htmlpath + "VMDetails.html"

#collect get-vm info and save output in xml and html formats
$info = get-vm * -server $vcenter |select *
$info | Export-Clixml $xmlname
$info |convertto-html -Head $header | out-file $htmlname

#collect get-view output and save in xml and html formats
$xmlname= $xmlpath + "VM_ViewDetails.xml"
$htmlname= $htmlpath + "VM_ViewDetails.html"
$vm = Get-View -server $vcenter –ViewType VirtualMachine
$vm | Export-Clixml $xmlname
$vm |convertto-html -Head $header | out-file $htmlname


########################################################################
#Referenced in Mod 4 - Performance


$xmlname= $xmlpath + "ESXI1_Watts.xml"
$htmlname= $htmlpath + "ESXI1_Watts.html"
$esxi_power_1 = get-esxtop -server $esxi_1 -CounterName "SchedGroup"
$esxi_power_1 | Export-Clixml $xmlname
$esxi_power_1 |convertto-html -Head $header | out-file $htmlname


     
$xmlname= $xmlpath + "ESXI2_Watts.xml"
$htmlname= $htmlpath + "ESXI2_Watts.html"
$esxi_power_2 = get-esxtop -server $esxi_2 -CounterName "SchedGroup"
$esxi_power_2 | Export-Clixml $xmlname
$esxi_power_2 |convertto-html -Head $header | out-file $htmlname


$xmlname= $xmlpath + "VM2012_Stats.xml"
$htmlname= $htmlpath + "VM2012_Stats.html"
$VmStats = Get-stat -Server $vcenter -entity "Win2012r2" -Maxsamples 1 -Stat *
$VmStats | Export-Clixml $xmlname
$VmStats |convertto-html -Head $header | out-file $htmlname


$xmlname= $xmlpath + "GuestHeartbeat2012.xml"
$htmlname= $htmlpath + "GuestHeartBeat2012.html"
$view = Get-View -viewtyp VirtualMachine -server $vcenter
$hb = $view |where {($_.name) -like "Win2012r2"}|select -property GuestHeartBeatStatus
$hb = $hb.GuestHeartbeatStatus 
$hb = $hb.tostring()
$hb | Export-Clixml $xmlname
$hb |convertto-html -Head $header | out-file $htmlname

########################################################################
#Referenced in Mod 5 - 

$xmlname= $xmlpath + "Host_Info.xml"
$htmlname= $htmlpath + "Host_Info.html"
$Host_Info = Get-VMHost -server $vcenter
$Host_Info | Export-Clixml $xmlname
$Host_Info |convertto-html -Head $header | out-file $htmlname

########################################################################
#Referenced in Mod 6
$xmlname= $xmlpath + "DatastoreInfo.xml"
$htmlname= $htmlpath + "DatastoreInfo.html"
$Datastores = Get-Datastore -server $Vcenter | Select *
$Datastores | Export-Clixml $xmlname
$Datastores |convertto-html -Head $header | out-file $htmlname

$xmlname= $xmlpath + "DataStoreExtension.xml"
$htmlname= $htmlpath + "DataStoreExtension.html"
$Data_extend = $datastores.extensiondata
$Data_extend | Export-Clixml $xmlname
$Data_extend |convertto-html -Head $header | out-file $htmlname

#########################################################################
#Referenced in Mod 7

$xmlname= $xmlpath + "HostAdapter.xml"
$htmlname= $htmlpath + "HostAdapter.html"
$HostAdap = Get-VMHOstNetworkadapter -server $VCenter #
$HostAdap | Export-Clixml $xmlname
$HostAdap |convertto-html -Head $header | out-file $htmlname

###########################################################################
#Referenced in Mod 8
$xmlname= $xmlpath + "Esxnet1.xml"
$htmlname= $htmlpath + "Esxnet1.html"
$esx = get-esxcli -V2 -VMHost $ESXI_1
$esxnet = $esx.network.vswitch.standard.list.invoke()
$esxnet | Export-Clixml $xmlname
$esxnet |convertto-html -Head $header | out-file $htmlname

$xmlname= $xmlpath + "Esxnet2.xml"
$htmlname= $htmlpath + "Esxnet2.html"
$esx = get-esxcli -V2 -VMHost $ESXI_2
$esxnet = $esx.network.vswitch.standard.list.invoke()
$esxnet | Export-Clixml $xmlname
$esxnet |convertto-html -Head $header | out-file $htmlname



###########################################################################
#Referenced in Mod 9

$xmlname= $xmlpath + "Cluster.xml"
$htmlname= $htmlpath + "Cluster.html"
$cluster = Get-Cluster | select * 
$clusterinfo = $cluster.extensiondata.OverallStatus
$clusterinfo | Export-Clixml $xmlname
$clusterinfo |convertto-html -Head $header | out-file $htmlname

###########################################################################
#Referenced in Mod 10
$xmlname= $xmlpath + "LatestUpdates.xml"
$htmlname= $htmlpath + "LatestUpdates.html"
import-module VMware.VumAutomation
$Baseline = Get-Baseline -Server $vcenter
$latestupdates = $Baseline.lastupdatetime
$latestupdates | Export-Clixml $xmlname
$Baseline |convertto-html -Head $header | out-file $htmlname
###########################################################################
#Referenced in Mod 11

$xmlname= $xmlpath + "Services_ESXI1.xml"
$htmlname= $htmlpath + "Services_ESXI1.html"
$services1 = Get-VMHostService -server $vcenter -VMHost $ESXI_1
$services1 | Export-Clixml $xmlname
$services1 |convertto-html -Head $header | out-file $htmlname


$xmlname= $xmlpath + "Services_ESXI2.xml"
$htmlname= $htmlpath + "Services_ESXI2.html"
$services2 = Get-VMHostService -server $vcenter -VMHost $ESXI_2
$services2 | Export-Clixml $xmlname
$services2 |convertto-html -Head $header | out-file $htmlname




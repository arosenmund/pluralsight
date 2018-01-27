<!doctype html>
<html lang="en">
  <head>
    <title>VMware Dashboard</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
  </head>

                    <?php

                    $xml1 = new SimpleXMLElement(file_get_contents('XML-STORE/VM_Count.xml'));
                    $TotalVMS = $xml1->I32;

                    $xml2 = new SimpleXMLElement(file_get_contents('XML-STORE/VM_On.xml'));
                    $VMs_On = $xml2->I32;

                    $xml3 = new SimpleXMLElement(file_get_contents('XML-STORE/Mem_Alloc.xml'));
                    $Mem_Alloc = $xml3->D;

                    $xml4 = new SimpleXMLElement(file_get_contents('XML-STORE/Cpus_Alloc.xml'));
                    $CPUs_Alloc = $xml4->I32;

                    //CARD - 1 VM_UsedGB.xml vs total available (TotalDatastoreGB.xml) %   -CARD - 1
                    $xml5 = new SimpleXMLElement(file_get_contents('XML-STORE/TotalDatastoreGB.xml'));
                    $DS_CapcityGB = $xml5->D;
                    $xml6 = new SimpleXMLElement(file_get_contents('XML-STORE/VM_UsedGB.xml'));
                    $VM_UsedSpace = $xml6->D;
                    $PercentUsedGB = ($VM_UsedSpace/$DS_CapcityGB) * 100;  //use $PercentUsedGB for progress bar
                    $PercentUsedGB_String1 = "width:" .$PercentUsedGB."%; height: 150%";
                    $PercentUsedGB_String2 = $PercentUsedGB."% of space is used by VMs";

                    //CARD - 2   Total Watts Used by ESXi Hosts  (TotalWatts.xml)        -CARD - 2
                    $xml7 = new SimpleXMLElement(file_get_contents('XML-STORE/TotalWatts.xml'));
                    $CurrentWatts = $xml7->U64;
                    $PercentMaxWatts = ($CurrentWatts/920) * 100;
                    $PercentMaxWatts_Str1 =  "width:" .$PercentMaxWatts."%; height: 150%";
                    $PercentMaxWatts_Str2 =  $PercentMaxWatts."of max wattage capacity is being used";

                    //CARD - 3 MhzCPUUsedPerc.xml  -CARD - 3
                    $xml8 = new SimpleXMLElement(file_get_contents('XML-STORE/MhzCPUUsedPerc.xml'));
                    $CPUUtilPerc = $xml8->Db;
                    $CPUUtilPerc_Str1 =  "width:" .$CPUUtilPerc."%; height: 150%";
                    $CPUUtilPerc_Str2 = "CPU utilization across the cluster is ".$CPUUtilPerc."%";

                    //CARD - 4 OverallDSGoodPerc.xml -CARD - 4
                    $xml9 = new SimpleXMLElement(file_get_contents('XML-STORE/OverallDSGoodPerc.xml'));
                    $DSPercGood = $xml9->I32;
                    $DSPercGood_Str1 = "width:" .$DSPercGood."%; height: 150%";
                    $DSPercGood_Str2 = $DSPercGood."% of Datastores report green status"; 

                    //CARD - 5 TotalPhysicalNics.xml   PhyNicswBit100.xml -CARD - 5
                    $xml10 = new SimpleXMLElement(file_get_contents('XML-STORE/TotalPhysicalNics.xml'));
                    $NumPhyNic = $xml10->I32;
                    $xml11 = new SimpleXMLElement(file_get_contents('XML-STORE/PhyNicswBit100.xml'));
                    $NicWithBits = $xml11->I32;
                    $PercPhyNicsUp = ($NicWithBits/$NumPhyNic) * 100;
                    $NicsUp_Str1 = "width:" .$PercPhyNicsUp."%; height: 150%";
                    $NicsUp_Str2 = $PercPhyNicsUp."% of vmnics connected";



                    //CARD - 6 UplinksNum.xml TotalPhysicalNics.xml  -CARD - 6
                    $xml12 = new SimpleXMLElement(file_get_contents('XML-STORE/UplinksNum.xml'));
                    $Uplinks = $xml12->I32;
                    $UplinksUsedPerc = ($Uplinks/$NumPhyNic) * 100;
                    $Uplink_Str1 = "width:" .$UplinksUsedPerc."%; height: 150%";
                    $Uplink_Str2 = $Uplinks." out of ".$NumPhyNic." adaptes are being used as uplinks";
                    

                    //Status Sheet
                    //Cluster Status
                    $xml14 = new SimpleXMLElement(file_get_contents('XML-STORE/ClusterStatus.xml'));
                    $ClusterStat = $xml14->I32;


                    //Services for status sheet
                    $xml15 = new SimpleXMLElement(file_get_contents('XML-STORE/RunningServNotRequired.xml'));
                    ?>
    
                    
  <body style="background-color: #212121;">
    <div class="mx-3 mb-3 pb-3">

        <h1 style= "color: white;">VMware Dashboard</h1>
    </div>

    <div class="btn-group mb-3 pb-3" role="group">
        <button id="btnGroupDrop1" type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        Pages
        </button>
        <div class="dropdown-menu" aria-labelledby="btnGroupDrop1">
            <a class="dropdown-item" href="status.php">Status Page</a>
            <a class="dropdown-item" href="data.html">Data Links</a>
        </div>
    </div>

</div>
    <div class="container-fluid my-3">
        <div class="row justify-content-around">
            <div class="col-sm-auto">
                <h1 class="text-center"><span class="alert alert-success"><?php echo $TotalVMS; ?></span></h1>
                <div class="mt-2 pt-2">
                    <h4 class="text-center" style="color:teal;">VMs</h4>
                </div>
            </div>
           
            <div class-"col-sm-auto">
                <h1 class="text-center"><span class="alert alert-danger"><?php echo $VMs_On; ?></span></h1>
                <div class="d-flex flex-wrap mt-2 pt-2">
                    <h4 class="text-center" style="color:teal; width: 200px; word-break: break-all;">Powered On</h4>
                </div>
            </div>
      
            <div class-"col-sm-auto">
                <h1 class="text-center"><span class="alert alert-info"><?php echo $Mem_Alloc; ?></span></h1>
                <div class="d-flex mt-2 pt-2">
                    <h4 class="text-center" style="color:teal; width: 200px; word-break: break-all;">Memory Assigned</h4>
                </div>
            </div>
    
            <div class-"col-sm-auto">
                <h1 class="text-center"><span class="alert alert-light"><?php echo $CPUs_Alloc; ?></span></h1>
                <div class="d-flex mt-2 pt-2">
                    <h4 class="text-center" style="color:teal; width: 200px; word-break: break-all;">CPUs Assigned</h4>
                </div>
            </div>
           
        </div>    
    </div>
    <div class="container-fluid my-3">
        <div class="row justify-content-sm-around my-3">
            <div class="col-sm-auto">
                <!-- CARD 1 -->
                <div class="card" style="width: 30rem;">
                    <div class="progress mt-3">
                        <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="<?php echo $PercentUsedGB; ?>" aria-valuemin="0" aria-valuemax="100" style="<?php echo $PercentUsedGB_String1;?>"></div>
                    </div>
                    <div class="card-body">
                        <h4 class="card-title"><?php echo $PercentUsedGB_String2;?></h4>
                    </div>
                </div>
                </div>
            <div class="col-sm-auto">
                <!-- CARD 2 -->               
                <div class="card" style="width: 30rem;">
                    <div class="progress mt-3">
                        <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="<?php echo $PercentMaxWatts; ?>" aria-valuemin="0" aria-valuemax="100" style="<?php echo $PercentMaxWatts_Str1;?>"></div>
                    </div>
                    <div class="card-body">
                        <h4 class="card-title"><?php echo $PercentMaxWatts_Str2;?></h4>
                    </div>
                </div>
            </div>    
        </div>
        <div class="row justify-content-sm-around my-3">
            <div class="col-sm-auto">
                <!-- CARD 3 -->
                <div class="card" style="width: 30rem;">
                    <div class="progress mt-3">
                        <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="<?php echo $CPUUtilPerc; ?>" aria-valuemin="0" aria-valuemax="100" style="<?php echo $CPUUtilPerc_Str1;?>"></div>
                    </div>
                    <div class="card-body">
                        <h4 class="card-title"><?php echo $CPUUtilPerc_Str2;?></h4>
                    </div>
                </div>
                </div>
            <div class="col-sm-auto">
                <!-- CARD 4 -->               
                <div class="card" style="width: 30rem;">
                    <div class="progress mt-3">
                        <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="<?php echo $DSPercGood; ?>" aria-valuemin="0" aria-valuemax="100" style="<?php echo $DSPercGood_Str1; ?>"></div>
                    </div>
                    <div class="card-body">
                        <h4 class="card-title"><?php echo $DSPercGood_Str2;?></h4>
                    </div>
                </div>
            </div>    
        </div>
        <div class="row justify-content-sm-around my-3">
            <div class="col-sm-auto">
                <!-- CARD 5 -->
                <div class="card" style="width: 30rem;">
                    <div class="progress mt-3">
                        <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="<?php echo $PercPhyNicsUp; ?>" aria-valuemin="0" aria-valuemax="100" style="<?php echo $NicsUp_Str1; ?>"></div>
                    </div>
                    <div class="card-body">
                        <h4 class="card-title"><?php echo $NicsUp_Str2; ?></h4>
                    </div>
                </div>
                </div>
            <div class="col-sm-auto"> 
                <!-- CARD 6 -->              
                <div class="card" style="width: 30rem;">
                    <div class="progress mt-3">
                        <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="<?php echo $UplinksUsedPerc;?>" aria-valuemin="0" aria-valuemax="100" style="<?php echo $Uplink_Str1;?>"></div>
                    </div>
                    <div class="card-body">
                        <h4 class="card-title"><?php echo $Uplink_Str2;?></h4>
                    </div>
                </div>
            </div>    
        </div> 
    </div>

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
  </body>
</html>
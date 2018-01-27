<!doctype html>
<html lang="en">
  <head>
    <title>Status Page</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
  </head>
    <?php


     //Cluster Status  Cluster.xml
     $xml1 = new SimpleXMLElement(file_get_contents('XML-STORE/ClusterStatus.xml'));
     $Cluster = $xml1->S;

    
     
    //VM Guest HeartBeat GuestHeartbeat2012.xml
    $xml2 = new SimpleXMLElement(file_get_contents('XML-STORE/GuestHeartbeat2012.xml'));
    $HeartBeat = $xml2->S;

    //machines overall status
    $xml3 = new SimpleXMLElement(file_get_contents('XML-STORE/Num_greenVM.xml'));
    $GreenVM = $xml3->I32;
    $xml4 = new SimpleXMLElement(file_get_contents('XML-STORE/VM_Count.xml'));
    $TotVM = $xml4->I32;
    if($GreenVM < $TotVM) {
                                $color = "Red"; 
                          } 
    elseif($GreenVM = $TotVM) { 
                                $color = "Green";
                              }

    //services  RunningServNotRequired.xml
    $xml5 = new SimpleXMLElement(file_get_contents('XML-STORE/RunningServNotRequired.xml'));
    $Services = $xml5->I32;
    if($Services > 0 ){
                        $color2 = "Red";
    }                    
    elseif($Services = 0){
                            $color2 = "Green";
    }
    //days DaysSinceLastUpdate.xml
    $xml6 = new SimpleXMLElement(file_get_contents('XML-STORE/DaysSinceLastUpdate.xml'));
    $days = $xml6->I32;
    if($days > 30){
                    $color3 = "Red";
    }
    elseif($days < 30){
                        $color3 = "Green";
    }

    ?>
  <body>
    <div class="mx-3 mb-3 pb-3">

        <h1 style= "color: black">Custom Status Page</h1>
    </div>

    <div class="btn-group mb-3 pb-3" role="group">
        <button id="btnGroupDrop1" type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        Pages
        </button>
        <div class="dropdown-menu" aria-labelledby="btnGroupDrop1">
            <a class="dropdown-item" href="dashboard.php">Dashboard</a>
            <a class="dropdown-item" href="data.html">Data Links</a>
        </div>
    </div>

   <div class="container-fluid">
        <!--Cluster Status-->
        <div class="card card-inverse mb-3 mt-3 text-center" style="background-color: <?php echo $Cluster; ?>;">
                <div class="card-block">
                  <h1 class="card-title">Cluster Status</h1>
                  <p class="card-text" style="color:white"> Overall Status is Reporting <?php echo $Cluster; ?> </p>
                </div>     
        </div>
        <!--2012r2 Heartbeat Status-->
        <div class="card card-inverse mb-3 mt-3 text-center" style="background-color:<?php echo $HeartBeat; ?>;">
                <div class="card-block">
                  <h1 class="card-title">Domain Controller Status</h1>
                  <p class="card-text" style="color:white"> Tools Heart Beat is Reporting <?php echo $HeartBeat; ?> </p>
                </div>     
        </div>
        <!--Machines Overall Status-->
        <div class="card card-inverse mb-3 mt-3 text-center" style="background-color: <?php echo $color; ?>;">
                <div class="card-block">
                  <h1 class="card-title"><?php echo $GreenVM; ?> Virtual Machines </h1>
                  <p class="card-text" style="color:white"> OverallStatus Reporting <?php echo $color; ?> </p>
                </div>     
        </div>
        <!--Services Running Not Required-->
        <div class="card card-inverse mb-3 mt-3 text-center" style="background-color: <?php echo $color2; ?>;">
                <div class="card-block">
                  <h1 class="card-title"><?php echo $Services; ?> Services </h1>
                  <p class="card-text" style="color:white">  <?php echo $color2; ?> Un-Required Services Running!</p>
                </div>     
        </div>
                <!--Days Since Last Update-->
        <div class="card card-inverse mb-3 mt-3 text-center" style="background-color: <?php echo $color3; ?>;">
                <div class="card-block">
                  <h1 class="card-title"><?php echo $days; ?> Days </h1>
                  <p class="card-text" style="color:white">  <?php echo $color3; ?> Days Since Last Baseline Update!</p>
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
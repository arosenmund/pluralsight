<#READ THIS FIRST
This script will take input from a credentials file and a resources files and create a usable terraform main.tf file.

For this to work you must first go to the "Tag Managment" service in the AWS Console.  You can create a resource group based on a tag like "pluralsight-lab" to select only specific resoruces or simply go to tag editor seach for all resoruces and then click "Export # resources to CSV"

With the credential file with programatic keys from the IAM role you are using, as well as the resoruces.csv in the project folder.  You then need to place the downloaded terraform.exe into the project folder as well.  Now you are all set!  Run this script inside the project folder, answer the questions and will create a main.tf for you.

Currently supporting EC2 instances.

By EOD 4-20 will support S3 Buckets and VPCs

For Contributors: Inclusion of new resources is relatively trivial, you simply need to write the correct text for the resource to initially import.  


THIS CANNOT BE RAN TWICE AND SHOULD BE CONSIDERED PRE_ALPHA! :)


#>






# Create Main.tf
$global:project_path = read-host

"Path to folder containing the following:
- terraform.exe
- credentials.csv
- resources.csv

[Enter Here]:
" 

# import credentials


$creds = import-csv $project_path\credentials.csv

$Region = Read-host "Enter Region designaton."

$access = $creds.'Access key ID'
$secret = $creds.'Secret access key'


$provider_text = "

provider `"aws`" {
  version = `"~> 2.0`"
  region  = `"$region`"
  access_key = `"$access`"
  secret_key = `"$secret`"
}

"


$provider_text | out-file -Encoding utf8 main.tf

###Main file created

.\terraform.exe init -no-color

<# future auto import
Install-Module -name "Aws.tools.common"

aws configure set AWS_ACCESS_KEY_ID $access
aws configure set AWS_SECRET_ACCESS_KEY $secret
aws configure set region $Region
#>

# future capability to auto perform tagging and csv export
# aws resourcegroupstaggingapi get-resources


#import resources
$resources = import-csv $global:project_path\resources.csv 


#create main.tf resource entry for each based on terraforms naming convetions

# This is where we can add support for one service at a time!
# Can we use iam:GetUser for a unique account ID?

# VPC creation 

$vpc_tf = 
"
resource `"aws_vpc`" `"$generated_name`" {

}
"

# EC2 Instances
$ec2instances_aws = $resources | ?{$_.Service -eq "EC2" -and $_.type -eq "Instance"}

foreach($instance in $ec2instances_aws){
    
    $generated_name = $instance.'Tag: Name'

    $ec2_tf ="resource `"aws_instance`" `"$generated_name`" {}"

    #output ec2 instance shell to main.tf
    $ec2_tf | out-file -Append -Encoding utf8 -FilePath main.tf

    #import ec2 instance to main.tf

    .\terraform.exe import aws_instance.$generated_name $instance.id

    #print terraform state

    $ec2_state_import = .\terraform state show aws_instance.$generated_name -no-color

    $ec2_state_import = $ec2_state_import[1..($ec2_state_import.Length-1)]

    $m = get-content $global:project_path\main.tf

    $m = $m.replace($ec2_tf,"")
    $m | out-file -FilePath $global:project_path\main.tf -Encoding utf8

    $ec2_state_import| out-file -filepath $global:project_path\main.tf -Encoding utf8 -Append    

}



# S3 Buckets - will be done EOD - 4/20
$s3_buckets = $resources| ?{$_.service -eq "S3" -and $_.type -eq "Bucket"}


$generated_name = $instance.'Tag: Name' 

$s3_tf=
"
resource `"aws_s3_bucket" "$generated_name"{


}
"
"
#




# error checking

$tempfile = new-temporaryfile

.\terraform.exe plan -no-color 2> $tempfile.fullname



$tempfile # don't forget to delete the temp file
$e = get-content $tempfile
$e = $e[7..($e.length-1)] |select-string -SimpleMatch "Error"
$e
$m = get-content -Path $global:project_path\main.tf 

foreach($l in $e){

$r = $l.line.split("`"")[1]

    if($r -like "*.*"){
    $r=$r.split(".")
    $s = @()
    $s += $R
    $r = $s[$s.length - 1]
    

    }elseif([string]::IsNullOrEmpty($r)){break :Outer}
$r

$m = $m | select-string -pattern "$r" -notmatch
}
#remove "id" key
$m = $m | select-string -patter "id" -notmatch
$m |out-file -Encoding utf8 -FilePath $global:project_path\main.tf


#add random keys






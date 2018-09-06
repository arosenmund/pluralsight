# Nbad Build Guide

## Virtual Machine Build

Create a virtual machine with whichever hypervisor you feel most comfortable.

- VMware Workstation 14 PRO - this is my go to and what these configurations have been tested with
- Oracle Virtual Box free
- Microsoft Hyper-V free on Win10

**VM Hardware Configuration**

Hardware | Min | Max
-------- | --- |  ---
Cores | 4 | 8 
Ram | 4GB | 16 GB

NetAdapter | Network Assigned
---------- | ----------------
vmnic1 | NAT virtual network
vmnic2 | Bridged to collection interface 1
vmnic3 | Bridged to collection interface 2

---------------------------------------------------

## Operating System Installation

Download the latest CentOS 7 iso and mount to Virtual Machine CD Drive

> https://www.centos.org/download/

Boot virtual machine to CD and follow through with the installation of CentOS 7 choosing the "Creative Workstation" Build

Login with the chosen username and password.

## MOLOCH

Download Elasticsearch 6.x rpm this was tested with 6.4 successfully.

> https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.4.0.rpm

### Install Elasticsearch

  > sudo rpm -i "elasticsearch-rpm"

### Moloch Base Install

  #### Download Moloch RPM 1.5.2

[Moloch Downloads](https://molo.ch/#downloads)

  #### Install RPM Package

   > sudo rpm -i "moloch 1.5.2"

### Configure Elastic and Moloch

 >
  
## NetSA Tools




### SiLK Install
  Download source here:

    https://tools.netsa.cert.org/silk/download.html
  
  Follow README for make & install instructions.


### YAF Install

Download source here:

    https://tools.netsa.cert.org/yaf/download.html
  
  Follow README for make & install instructions.


## ELK Stack Install

### Install Docker
  > sudo yum install docker

### Start Docker
  > sudo systemctl start docker

### Docker search elastic
  > sudo docker elasticsearch

Docker search kibana
  > sudo docker elasticsearch

Configure elastic
  

Configure kibana


Verify Kibana & elastic install by browsing to http://localhost:5601


Install packet beats


## Wireshark

>sudo yum install wireshark



All set!

You are now the proud owner of the Pluralsight Security Network Behavioral Anomaly Detection suite....PS-NBAD.

No super cool logo yet, but I am open to suggestions.

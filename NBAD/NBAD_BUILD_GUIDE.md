# Ps-NBAD Build Guide

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

Boot virtual machine to CD and follow through with the installation of CentOS 7 choosing the "Development and Creative Workstation" Build and leave all other settings default.

Login with the chosen username and password.

----------------------------------------------------

## MOLOCH

Moloch is an open source, large scale, full packet capturing, indexing, and database system. Moloch augments your current security infrastructure to store and index network traffic in standard PCAP format, providing fast, indexed access.

Download Elasticsearch 6.x rpm this was tested with 6.4 successfully.

> https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.4.0.rpm

### Install Elasticsearch

  > sudo rpm -i "elasticsearch-rpm(downloaded file name here)"

### Moloch Base Install

  #### Download Moloch RPM 1.5.2

[Moloch Downloads](https://molo.ch/#downloads)

  #### Install RPM Package

   > sudo rpm -i "moloch 1.5.2(downloaded file name here)"

### Configure Elastic and Moloch

 Start Elasticsearch with default yaml file configuration.
 
 > sudo systemctl start elasticsearch
 
 verify it started successfully
 
 > sudo systemctl status elasticsearch
 
 Navigate to moloch data folder
 > cd /data/moloch
 
 Follow the install and configuration instructions in the README file.
 
 After installation is complete.
 
 Start moloch with the following two commands:
 
 > sudo systemctl start molochcapture
 > sudo systemctl start molochviewer
 
 Option: If you which for moloch to start it self upon start up simpley use:
 > sudo systemctl enable elasticsearch
 > sudo systemctl enable molochcapture
 > sudo systemctl enable molochviewer
 
 Don't forget to start elasticsearch before starting the moloch services.
  
  *However, this will begin capture and continue to capture at all times during the use of the machine, it will essentially become only a Moloch machine instead of a multi-tiered behavioral analysis machine, and storage may be an issue.*
 
 Verify installation by loggining into http://localhost:8005

----------------------------------------------------

## NetSA Tools

The Network Situational Awareness (NetSA) group at CERT has developed and maintains a suite of open source tools for monitoring large-scale networks using flow data. These tools have grown out of the work of the AirCERT project, the SiLK project and the effort to integrate this work into a unified, standards-compliant flow collection and analysis platform. 

### SiLK Install
  Download source here:

    https://tools.netsa.cert.org/silk/download.html
  
  Follow README for make & install instructions.


### YAF Install
Used to convert pcap files to flow files for reading with silk tools like rwfilter.

Download source here:

    https://tools.netsa.cert.org/yaf/download.html
  
  Follow README for make & install instructions.

----------------------------------------------------

## ELK Stack Install

Installing separately from moloch instance. To increase the performance of the standalong machine learning node.

Install Docker
  
  > sudo yum install docker

Start Docker
  
  > sudo systemctl start docker
  
Docker pull elastic image
  
  > sudo docker pull elasticsearch

Docker search kibana
  
  > sudo pull docker elasticsearch

Create docker containers
  
  > sudo docker create elasticsearch
    
  > sudo docker create kibana
    
Configure elastic
  
  > sudo docker exec -t -i "elastic conatiner ID#" /bin/bash
  > bash> vi config/elasticsearch.yml

  Edit with configuration similar to:
  
  ```
  cluster.name: "docker-cluster"
  network.host: 172.17.0.2 #use the elasticsearch container locla ip
  
  #minimum _master_nodes need to be explicitly set when bound on a public IP
  #set to 1 to allow single node clusters
  #Details: https://github.com/elastic/elasticsearch/pull/17288
  discovery.zen.minimum_master_nodes: 1
  
  ```

  
Configure kibana
  
  > docker exec -t -i "kibana container ID#" /bin/bash
  > bash> vi config/kibana.yml
  
  Edit with configuration similar to:
  
  ```
  server.name: kibana
  server.host: "172.17.0.3" #Kibana containers local ip
  elasticsearch.url: http://172.17.0.2:9200 #use the elasticsearch container local ip
  xpack.monitoring.ui.container.elasticsearch.enabled: true
  
  ```
  
Restart docker containers

Verify Kibana & elastic install by browsing to http://<kibana address>:5601

At this point you can enable the machine learning liscense under _managment_ and then _Liscense Managment_



----------------------------------------------------

##Install packet beats

Download packet beats rpm here:

[Packet Beats](https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-6.4.0-x86_64.rpm)

Install RPM

  > sudo rpm -i "packet beats download"

Edit packetbeat.yml file

  > sudo vi /etc/packetbeat/packetbeat.yml

Under the section labeled **Outputs** change the ip to the docker elasticsearch ip like this:

  ```
  output.elasticserch:
   #Array of hosts to connect to.
   hosts: ["172.17.0.2:9200"]
  ```
Under the section labeled **Kibana** change the ip to the docker kibana ip like this:

  ```
  setup.kibana:

   #Kibana Host
   host: "http://172.17.0.3:5601"
  ```
Save the file.  Now you can use the packetbeat command to read the pcaps dumped by Moloch into the /data/moloch/raw folder and parse them into the dockerized elkstack for more analysis.

----------------------------------------------------

## Bro

Download the bro source from here:

https://www.bro.org/download/index.html

Unpack the tarball

> tar -zxvf bro-2.5.4.tg.gz

Navigate to bro folder.

> cd bro-2.5.4

Configure, make and make install.

> sudo ./configure
> sudo make
> sudo make install

Bro is good to go and should work from the command line as referenced in the NBAD course.

----------------------------------------------------

## Wireshark
GUI for viewing smaller pcaps graphically.  Lots of great functionality but stores all read file information in memory, so avoid large pcaps.

>sudo yum install wireshark-gnome

-------------------------------------------------------------------------------------------------------------------

All set!

You are now the proud owner of the Pluralsight Security Network Behavioral Anomaly Detection suite....PS-NBAD.

No super cool logo yet, but I am open to suggestions.  Please provide commits as necesary for changes, this is hosted on git for a reason and I welcom collaboration.

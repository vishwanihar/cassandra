#!/bin/bash
sudo add-apt-repository -y ppa:webupd8team/java
sleep 05
sudo apt-get -y update
sleep 10
sudo apt-get -y install oracle-java8-installer
sleep 10
echo deb http://www.apache.org/dist/cassandra/debian 311x main | sudo tee -a /etc/apt/sources.list.d/cassandra.list
sleep 05
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
sleep 05
sudo apt-get -y update
sleep 05
sudo apt-get -y install cassandra
sleep 10
sudo service cassandra start
sleep 05
sudo nodetool status

#!/bin/bash
sudo add-apt-repository -y ppa:webupd8team/java
sleep 05

sudo apt-get update
sleep 05

sudo apt-get -y install oracle-java8-installer
sleep 05

echo "deb http://www.apache.org/dist/cassandra/debian 310x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.list
sleep 05

gpg --keyserver pgp.mit.edu --recv-keys 749D6EEC0353B12C
gpg --export --armor 749D6EEC0353B12C | sudo apt-key add -

sleep 05
sudo apt-get update
sleep 10

sudo apt-get install cassandra
sleep 10

sudo service cassandra start
sleep 05
cqlsh


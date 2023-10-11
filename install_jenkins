#!/bin/bash

echo "Running updates..."
sudo apt-get update
sudo apt -y upgrade

echo " "

echo "Installing java..."
sudo apt-get install -y fontconfig openjdk-17-jre

echo "Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get install -y jenkins

sudo systemctl start jenkins

echo " "
echo "TO NAVIGATE TO JENKINS"
echo " "
echo "Jenkins IP Address:  $(curl ifconfig.me | cut -d "u" -f 1):8080"
echo " "
sudo chmod 777 /var/lib/jenkins/secrets/
sudo chmod 644 /var/lib/jenkins/secrets/initialAdminPassword

echo "administrator password: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"
echo " "
echo "Install Jenkins plugin as required"

exit 0

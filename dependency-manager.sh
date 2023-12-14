#!/bin/bash

####Update the server and install base packages
sudo apt-get update -y 
sudo apt-get upgrade -y
sudo apt install git apt-transport-https ca-certificates curl software-properties-common -y

#add docker to sources
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#add kubectl to sources
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

#download minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

#add helm to sources
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

#update sources get ready for install
sudo apt update -y

#even after installation, terminal refresh is required in order to use docker
sudo apt-get install docker-ce kubectl helm  -y
sudo usermod -aG docker $USER 

sudo install minikube-linux-amd64 /usr/local/bin/minikube

#java 17 & mvn 3.9.5
sudo apt install openjdk-17-jdk -y
cd /tmp; wget https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz; 
tar xf apache-maven-3.9.5-bin.tar.gz
sudo mv apache-maven-3.9.5  /opt/maven
sudo chown -R root:root /opt/maven

#go back to starting directory
cd -

#link mvn exe under PATH and set ENV vars
cat <<EOF >> mymavenvars.sh
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
EOF
sudo cp mymavenvars.sh /etc/profile.d/
rm mymavenvars.sh
sudo ln -s /opt/maven/bin/mvn /usr/bin/mvn

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}

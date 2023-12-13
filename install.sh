#!/bin/bash

####INSTALL
sudo apt-get update -y 
sudo apt-get upgrade -y
cd /opt
apt install apt-transport-https ca-certificates curl software-properties-common -y

#docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#kubectl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

#minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo apt update -y
sudo apt install docker-ce -y
sudo usermod -aG docker $LOGNAME
sudo apt-get update -y 
sudo apt-get install -y kubectl
install minikube-linux-amd64 /usr/local/bin/minikube
minikube start

#java 17 & mvn 3.9.5
apt install openjdk-17-jdk -y
cd /tmp; wget https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz
tar xf apache-maven-3.9.5-bin.tar.gz
sudo mv apache-maven-3.9.5  /opt/maven
chown -R root:root /opt/maven

#link mvn exe under PATH 
cat <<EOF >> /etc/profile.d/mymavenvars.sh
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
EOF
ln -s /opt/maven/bin/mvn /usr/bin/mvn

#Install helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm


#Start minikube
minikube start --driver=docker
minikube -p minikube docker-env
minikube addons enable ingress

#Install RabbitMQ
helm install rabbitmq ./rabbitmq


#Build images
cd consumer-app && mvn install && docker build -t rabbit-consumer:0.0.1 -f Dockerfile . && cd ..
cd publisher-app && mvn install && docker build -t rabbit-publisher:0.0.1 -f Dockerfile . && cd ..

#Add secret
kubectl apply -f rabbitmq-secrets.yaml

#Install services 
helm install consumer ./rabbit-consumer
helm install publisher ./rabbit-publisher

#Open internal port for testing
#kubectl port-forward svc/publisher-rabbit-publisher 9090:9090 &





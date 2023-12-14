#!/bin/bash

#############################################################################
##  git clone https://github.com/AhmetOgulcanCankaya/rabbit-in-spring.git  ##
#############################################################################

#Start minikube with docker driver
minikube start --driver=docker
minikube -p minikube docker-env
minikube addons enable ingress

#Add secret
kubectl apply -f rabbitmq-secrets.yaml

#Install RabbitMQ and amqp ingress
helm install rabbitmq ./rabbitmq
kubectl apply -f amqp-ingress.yaml

# Docker env eval to minikube is required for builded images to be recognized by minikube
eval $(minikube -p minikube docker-env)

#Build images
cd consumer-app && mvn install && docker build -t rabbit-consumer:0.0.1 -f Dockerfile . && cd ..
cd publisher-app && mvn install && docker build -t rabbit-publisher:0.0.1 -f Dockerfile . && cd ..

#Install services 
helm install consumer ./rabbit-consumer
helm install publisher ./rabbit-publisher

export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services consumer-rabbit-consumer)
export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
echo $NODE_IP rabbitpub.local | sudo tee -a /etc/hosts
echo $NODE_IP rabbitmq.local | sudo tee -a /etc/hosts
echo $NODE_IP rabbitmq-amqp.local | sudo tee -a /etc/hosts


echo "Publisher endpoint is http://rabbitpub.local/"
echo "Rabbitmq management endpoint is http://rabbitmq.local/"
echo "Rabbitmq amqp endpoint is http://rabbitmq-amqp.local/"




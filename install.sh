#!/bin/bash

#Start minikube
minikube start --driver=docker
minikube -p minikube docker-env

#Build images
cd consumer-app && mvn install && docker build -t rabbit-consumer:0.0.1 -f Dockerfile . && cd ..
cd publisher-app && mvn install && docker build -t rabbit-publisher:0.0.1 -f Dockerfile . && cd ..

#Add secret
kubectl apply -f rabbitmq-secrets.yaml

#Install services and RabbitMQ
helm install rabbitmq ./rabbitmq
helm install consumer ./rabbit-consumer
helm install publisher ./rabbit-publisher

#Open internal port for testing
kubectl port-forward svc/publisher-rabbit-publisher 9090:9090 &
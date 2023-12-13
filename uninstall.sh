#!/bin/bash

#Start minikube
minikube stop

#Build images
cd consumer-app && mvn install && docker build -t rabbit-consumer:0.0.1 -f Dockerfile . && cd ..
cd publisher-app && mvn install && docker build -t rabbit-publisher:0.0.1 -f Dockerfile . && cd ..

#Add secret
kubectl delete -f rabbitmq-secrets.yaml

#Install services and RabbitMQ
helm uninstall rabbitmq
helm uninstall consumer
helm uninstall publisher

#Open internal port for testing
kubectl port-forward svc/publisher-rabbit-publisher 9090:9090 &
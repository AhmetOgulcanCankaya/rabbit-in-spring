#!/bin/bash

#Stop minikube
minikube stop

#Add secret
kubectl delete -f rabbitmq-secrets.yaml

#Uninstall services and RabbitMQ
helm uninstall rabbitmq
helm uninstall consumer
helm uninstall publisher


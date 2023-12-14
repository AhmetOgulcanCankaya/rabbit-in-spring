#!/bin/bash

#Add secret
kubectl delete -f rabbitmq-secrets.yaml
kubectl delete -f amqp-ingress.yaml

#Uninstall services and RabbitMQ
helm uninstall rabbitmq
helm uninstall consumer
helm uninstall publisher

#Stop minikube
minikube stop

## rabbit-in-spring
A Spring Boot - RabbitMQ app that just sends a message over RabbitMQ service.

## TL;DR
Run [dependency-manager.sh]

> Docker installations require terminal refresh for proper usage. Open the terminal again or run ```sudo su $USER -``` after successful execution. First method suggested!

If at ~/rabbit-in-spring, run [install.sh]
For commands run end details please see [install.sh] as well

At the end of the deployment it is planned to have: 
```
Publisher endpoint as http://rabbitpub.local/
Rabbitmq management endpoint as http://rabbitmq.local/
Rabbitmq amqp endpoint as http://rabbitmq-amqp.local/
```
and they should be reachable

> Note: This repository is prepared with an Ubuntu 22.04 base installation from AWS EC2 service.


### Apps

Simple send/receive user model app. Only connection between them is RabbitMQ.
1 publisher and 1 consumer needed.

[consumer-app]
 - Dockerfile is all you need
 - Run ```docker build -t rabbit-consumer:0.0.1 -f Dockerfile .``` in directory
 - Runs on port 9090 by default, change it from ```consumer-app/src/main/resources/application.properties```


[publisher-app]
 - Dockerfile is all you need
 - Run ```docker build -t rabbit-publisher:0.0.1 -f Dockerfile .``` in directory
 - Runs on port 9091 by default, change it from ```publisher-app/src/main/resources/application.properties```
 
> If you change application.properties files you also have to edit charts

### Helms

[rabbitmq]

 - Pulled from bitnami repository with latest settings
 - values.yaml file contains the preferred specifications
 - Only need helm to install to kubernetes

[rabbit-consumer]

 - Created with Helm 
 - Can be used after image builds
 - Deploys to kubernetes specified with ```.kube/config```

[rabbit-publisher]

 - Created with Helm 
 - Can be used after image builds
 - Deploys to kubernetes specified with ```.kube/config```

### Misc

[terraform]

 - Created for test usages
 - variables.tf and main.tf files contains the preferred specifications for the network and instance but rest is automatic, mostly (be sure to set the aws profile correct)
 - Only need terraform to be installed and run accordingly
 - ```terraform init/plan/apply/destroy``` for best usage

## Individuals

[dependency-manager.sh]
 - Installs the required packages and sets the environment ready
 - This installs: ```java-17, maven-3.9.5, minikube, docker-ce, kubectl, helm, etc.```

[install.sh]
 - Starts minikube
 - Builds the docker images
 - Installs the helm charts
 - Adds ingresses and rabbit password secret

[uninstall.sh]
 - Reverses the effects of [install.sh]


## Testing

#### Rabbit-consumer
You can use ``` kubectl logs <podName>``` for logs

#### Rabbit-publisher
Rabbit-publisher should be able to take this message
```
curl --location 'http://rabbitpub.local/register' \
    --header 'Content-Type: application/json' \
    --data '{
        "email":"beet",
        "name":"hoven"
    } 
```
and responde with message: ```{"message":"User registered successfully!"}```

#### General
After deploying a chart and svc connected to it, you can always use
```kubectl port-forward svc/<servicename> svcPort:nodePort ``` for some internal testing. For eq.
```kubectl port-forward svc/publisher-rabbit-publisher 9090:9090```
provides a port from localhost that answers to your requests defined above ^


> <div style="text-align: right"> *Special thanks to StackOverflow community* </div>

[//]: #
  [consumer-app]: <./consumer-app/Dockerfile>
  [publisher-app]: <./publisher-app/Dockerfile>
  [rabbitmq]: <./rabbitmq/README.md>
  [rabbit-consumer]: <./rabbit-consumer/>
  [rabbit-publisher]: <./rabbit-publisher/>
  [terraform]: <./terraform/README.md>
  [install.sh]: <./install.sh>
  [uninstall.sh]: <./uninstall.sh>
  [dependency-manager.sh]: <./dependency-manager.sh>

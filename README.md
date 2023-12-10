## rabbit-in-spring


A Spring Boot - RabbitMQ app that just sends a message over RabbitMQ service.

###Apps
[consumer-app]

 - Dockerfile is all you need
 - Run ```docker build -t rabbit-consumer:0.0.1 -f Dockerfile .``` in directory
 - Runs on port 9090 by default, change it from ```consumer-app/src/main/resources/application.properties```


[publisher-app]

 - Dockerfile is all you need
 - Run ```docker build -t rabbit-publisher:0.0.1 -f Dockerfile .``` in directory
 - Runs on port 9091 by default, change it from ```publisher-app/src/main/resources/application.properties```
 
> If you change application.properties files you also have to edit charts

 
###Helms

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


##Individuals
[install.sh]
 - Installs the helm charts and creates port-forwards on node

> Note: *Special thanks to StackOverflow community*


[//]: #
  [consumer-app]: <./consumer-app/Dockerfile>
  [publisher-app]: <./publisher-app/Dockerfile>
  [rabbitmq]: <./rabbitmq/README.md>
  [rabbit-consumer]: <./rabbit-consumer/>
  [rabbit-publisher]: <./rabbit-publisher/>
  [install.sh]: <./install.sh>

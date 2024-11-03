kcl mod init infrastructure-crossplane

from every folder I want to convert a yaml into a kcl file (for example, from kubernetes-provider):

```
kcl import -f kubernetes-provider.yaml
```

over infrastructure-crossplane  execute: 

```
kcl run | kubectl apply -f -
```

To list all package versions: (providers, configurations and functions)

```
 k get pkgrev
```

QUESTDB:

 clone repository from: https://github.com/questdb/questdb-operator.git , delete all folders and files except config
 in manager/kustomization.yaml change the version for the desired questdb-operator version (in my case newTag: v0.5.1)
 over questdb-operator/config execute: k apply -k default

 we can get the crds in a file: k kustomize default > default_crds.yaml

 to retrieve all resources managed by crossplane:

 ```
 k get managed
 ```


For Strimzi: first we need to build annotations, then generator

you can simply get the crds from: https://strimzi.io/install/latest?namespace=kafka

then 

```
k create -f strimzi-cluster-operator-0.43.0.yaml -n kafka 
```

we could generate the CRDs manually

```
https://github.com/strimzi/strimzi-kafka-operator.git

cd strimzi-kafka-operator/crd-annotations

make

cd strimzi-kafka-operator/crd-generator

make

java -jar target/crd-generator-0.45.0-SNAPSHOT.jar

```

we will obtain the file: strimzi-crds.yaml

when we do make what we are doing is:

```
cd strimzi-kafka-operator
mvn clean install -pl crd-generator -am

```

MONGODB

over operator/kubernetes_deployment/community_operator/mongodb-kubernetes-operator/config

```
k apply -k default -n mongodb
```
then we will use: mongodb.com_v1_mongodbcommunity_additional_mongod_config_cr.yaml
wich is in: mongodb/operator/kubernetes_deployment/community_operator/mongodb-kubernetes-operator/config/samples/

GRAFANA

```
k create -f grafana-operator-v5.14.0.yaml 
```

ELASTICSEARCH

```
kubectl port-forward service/blue-kibana-kb-http 5601 -n elk
```

```
kubectl get secret blue-elasticsearch-es-elastic-user -n elk -o=jsonpath='{.data.elastic}' | base64 --decode; echo

kubectl get secret/blue-elasticsearch-apm-server-apm-token -o go-template='{{index .data "secret-token" | base64decode}}' -n elk
```


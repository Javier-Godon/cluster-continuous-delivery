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
 clone repository from: https://github.com/questdb/questdb-operator.git , delete all folders and files except config
 in manager/kustomization.yaml change the version for the desired questdb-operator version (in my case newTag: v0.5.1)
 over questdb-operator/config execute: k apply -k default

 to retrieve all resources managed by crossplane:

 ```
 k get managed
 ```


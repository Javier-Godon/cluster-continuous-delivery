https://www.kcl-lang.io/docs/user_docs/guides/package-management/quick-start

over apps: kcl mod init

if you want to create a project from scrach you can do: (kcl will create the folder blue_deployment)

over apps: kcl mod init blue_deployment && cd blue_deployment

from: https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1 install all needed packages, like:

``
kcl mod add k8s:1.31.2
```

On the same way we can use modules from another folders in my filesystem. For example, to add the kcl dependecy to my 
module environmets I can do:
kcl mod add ../konfig

this will only work if that dependency is a kcl module (so I previously did kcl mod init over it)

the output could be like:
```
adding dependency 'kcl'
add dependency 'kcl:0.0.1' successfully
``
in environments dev I would do

```
kcl mod add ../../../konfig
kcl mod add ../../../deployments
```

and the result

```
adding dependency 'konfig'
add dependency 'konfig:0.0.1' successfully
```

kcl run main.k -D environment="dev"

to create a kcl file from a yaml : kcl import -f deployment.yaml

to run and configure the deployment:

```
kcl run -D appenv=dev -D app=pokedex -D appns=dev
```

to generate the manifests:
kcl run

to generate and apply manifests:
kcl run | kubectl apply -f -
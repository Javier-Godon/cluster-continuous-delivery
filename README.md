# cluster-continuous-delivery
kcl examples: https://github.com/kcl-lang/kcl-lang.io/tree/main/examples
# Install kcl openapi
https://github.com/kcl-lang/kcl-openapi
# generate kcl from crds:
kcl import -m crd -o ${the_kcl_files_output_dir} -s ${your_CRD.yaml}
 # ArgoCD
 manifests(CRDs): https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
 (split into CRDs and Deployment)
 copy to yaml -> argocd_crd.yaml and argocd_deployment.yaml

kcl import -m crd -o ./ -s argocd_crd.yaml
kcl import -m crd -o ./ -s argocd_deployment.yaml

# generate kubernetes objects like Deployments, Services,...

kcl import -f argocd_crd.yaml
kcl import -f argocd_deployment.yaml

# Create main.k file
This will be our kcl program

# For kubernetes we would need k8s module but it is included when we generate CRDs
https://artifacthub.io/packages/kcl/kcl-module/k8s/1.31.0

to do that execute: kcl mod add k8s:1.28

in mod we will see 

```
[dependencies]
k8s = "1.28"
```



# Get the yaml manifests
```
kcl run -f argocd_crd.k
```
over dev execute: kcl run | kubectl apply -f -

over namespaces execute: kcl namespaces.k | kubectl apply -f -
over argocd execute: kcl argocd_crd.k | k apply -n argocd -f -

Once we have the CRDs in KCL format these are the steps to follow:

# Create a module with kusionstack and tunning it

```
kusion mod init <your-module-name>

```

# Let's give it another go to kusion
over kusion_argocd

```
kusion init

kusion stack create dev

kusion stack create prod

```

From the v0.2.1 version of kam ,workload is no longer a required field in the AppConfiguration model

# import kam.v1.app_configuration as ac
# import kam.v1.app_configuration as ac
# import k8s_manifest



# argocd: ac.AppConfiguration{
#     accessories: {
#         "k8s_manifest": k8s_manifest.K8sManifest {
#             paths: [
#                 # The path of a YAML file. 
#                 # The path of a directory containing K8s manifests. 
#                 "vendor_files/k8s_manifests"
#             ]
#         }
#     }
# }

import k8s.api.core.v1 as kub
import manifests
import vendor_files.argocd_crd
import vendor_files.argocd_deployment

schema EnvConfig:
    namespace: str

_env_config = EnvConfig {
    namespace: "argocd"
}

_argocd_namespace = kub.Namespace {
    metadata: {
        name: _env_config.namespace
    }
}

manifests.yaml_stream([_argocd_namespace])
# Apply the CRDs (CRDs should be deployed first)
manifests.yaml_stream(argocd_crd.items)
# Inject the namespace dynamically into the resources
# Mutate the namespace of each resource in argocd_deployment.argocd_resources
# argocd_resources_with_namespace = [r.update(metadata={"namespace": env_config.namespace}) for r in argocd_deployment.items]
# argocd_resources_with_namespace = [item + {
#     "metadata": {
#         "namespace": "argocd"
#     }
# } for item in argocd_deployment.items]
# argocd_resources_with_namespace = [{
#     "metadata": item.metadata | {"namespace": argocd_namespace} 
# } for item in argocd_deployment.items]
_argocd_resources_with_namespace = [{
    **item
    "metadata": item.metadata | {"namespace" = _env_config.namespace}
} for item in argocd_deployment.items]
# Apply the ArgoCD resources with the injected namespace
manifests.yaml_stream([_argocd_namespace, argocd_crd.items, _argocd_resources_with_namespace])

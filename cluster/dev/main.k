import kam.v1.app_configuration as ac
import k8s_manifest

# main.k declares the customized configuration codes for default stack. 
continuous_delivery: ac.AppConfiguration {
    accessories: {
        "k8s_manifest": k8s_manifest.K8sManifest {
            paths: [               
                "argocd_crd.yaml"                
            ]
        }
    }
}

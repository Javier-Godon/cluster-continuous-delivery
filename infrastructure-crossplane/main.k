import manifests
import providers.helm_provider as helm_prov
import providers.kubernetes_provider as kub_prov
import managed_resources.questdb

manifests.yaml_stream([
    kub_prov.items_kubernetes_install
    helm_prov.items_helm_install
    kub_prov.items_kubernetes_provider
    questdb.items_questdb_operator
    questdb.items_questdb_instance
])

import konfig.models.kube.frontend
import deployments.erp_back_go.base.application_configuration as configuration
import deployments.erp_back_go.base.erp_back_go_configmap as configmap

erp_back_go_configuration_properties: configuration.ApplicationConfiguration {
    server_port = 8799
    postgres_db_driver = "postgres"
    postgres_uri = "postgres://postgres:postgres@blue-postgres.postgres.svc.cluster.local:5432/blue_postgres?sslmode=disable&search_path=public"
    postgres_user = "postgres"
    postgres_password = "postgres"
    postgres_database = "blue-mongodb"
}
erp_back_go_configmap: configmap.ErpBackGoConfigmap {
    _application_configuration = erp_back_go_configuration_properties
    namespace = "dev"
}
github_service_account: serviceaccount.ServiceAccount {
    namespace = "dev"
}
erpBackGoApplication: frontend.Server {
    image = "ghcr.io/javier-godon/erp-back:1b78a5a-2025-01-06t22-18"
    imagePullPolicy = "IfNotPresent"
    namespace = "dev"
    replicas = 1
    services = [
        service.Service {
            type = "NodePort"
            ports = [
                {
                    port = 8002
                    nodePort = 31030
                    name = "erp-back-go-server"
                }
            ]
        }
    ]
    volumes = [
        v.Volume {
            name = "application-configuration"
            volumeSource = v.ConfigMap {
                name = "erp-back-go-configmap"
                items = [
                    {key: "application.yaml", path: "application.yaml"}
                ]
            }
            mounts = [
                v.Mount {
                    path = "/app/application.yaml"
                    subPath = "application.yaml"
                }
            ]
        }
    ]
    # subPath ensures that only the application.yaml file from the ConfigMap is mounted, avoiding replacing the entire target directory.
    configMaps = [
        erp_back_go_configmap
    ]
}

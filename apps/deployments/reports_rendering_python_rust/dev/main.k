import konfig.models.kube.frontend
import deployments.reports_rendering_python_rust.base.application_configuration as app_configuration
import deployments.reports_rendering_python_rust.base.reports_rendering_python_rust_configmap as reports_rendering_configmap

reports_rendering_app_configuration: app_configuration.ApplicationConfiguration {
    server_port = 8008
    questdb_pass = "questdb"
    questdb_user = "questdb"
    questdb_database = "reports"
}
reports_rendering_python_rust_configmap_impl: reports_rendering_configmap.ReportsRenderingPythonRustConfigmap {
    _config = reports_rendering_app_configuration
    namespace = "dev"
}
github_service_account: serviceaccount.ServiceAccount {
    namespace = "dev"
}
# imagePullSecrets: [
#     {
#         name: "pull-image-from-github-registry-secret"
#     }
# ]
reportsRenderingPythonRustApplication: frontend.Server {
    image = "ghcr.io/javier-godon/reports-rendering-python-rust:3f8fce0-2025-03-08T19-01"
    imagePullPolicy = "IfNotPresent"
    namespace = "dev"
    replicas = 1
    services = [
        service.Service {
            type = "NodePort"
            ports = [
                {
                    port = 8002
                    nodePort = 31040
                    name = "reports-rendering-python-rust-server"
                }
            ]
        }
    ]
    volumes = [
        v.Volume {
            name = "application-configuration"
            volumeSource = v.ConfigMap {
                name = "reports-rendering-python-rust-configmap"
                items = [
                    {key: "application.yaml", path: "application.yaml"}
                ]
            }
            mounts = [
                v.Mount {
                    path = "/code/app/configuration/application.yaml"
                    subPath = "application.yaml"
                }
            ]
        }
    ]
    # subPath ensures that only the application.yaml file from the ConfigMap is mounted, avoiding replacing the entire target directory.
    configMaps = [
        reports_rendering_python_rust_configmap_impl
    ]
}

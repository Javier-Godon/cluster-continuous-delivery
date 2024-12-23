import konfig.models.kube.frontend
import deployments.video_collector_mongodb_python.base.application_configuration as app_configuration
import deployments.video_collector_mongodb_python.base.video_collector_mongodb_python_configmap as video_collector_configmap

# import base.video_collector_mongodb_python_app_config as app_configuration
# import base.video_collector_mongodb_python_configmap as video_collector_configmap
kafka_server_app_configuration: app_configuration.ApplicationConfiguration {
    server_port = 8002
    mongodb_ui = "mongodb://admin:admin@localhost:30332/admin?readPreference=primaryPreferred"
    mongodb_database = "blue-mongodb"
}
video_collector_mongodb_python_configmap_impl: video_collector_configmap.VideoCollectorMongodbPythonConfigmap {
    _config = kafka_server_app_configuration
    namespace = "dev"
}
github_service_account: serviceaccount.ServiceAccount {
    # name = "github-service-pull-image-account"
    namespace = "dev"
}
# imagePullSecrets: [
#     {
#         name: "pull-image-from-github-registry-secret"
#     }
# ]
videoCollectorMongodbPythonApplication: frontend.Server {
    image = "ghcr.io/javier-godon/video-collector-mongodb-python:d5d74ad-2024-12-22T18-07"
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
                    name = "video-collector-mongodb-python-server"
                }
            ]
        }
    ]
    volumes = [
        v.Volume {
            name = "application-configuration"
            volumeSource = v.ConfigMap {
                name = "video-collector-mongodb-python-configmap"
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
        video_collector_mongodb_python_configmap_impl
    ]
}

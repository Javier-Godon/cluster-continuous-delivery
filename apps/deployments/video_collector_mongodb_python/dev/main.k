import konfig.models.kube.frontend
import base.application_configuration as configuration
import base.video_collector_mongodb_python_configmap as configmap

kafka_server_configuration_properties: configuration.ApplicationConfiguration {
    server_port = 8002
    mongodb_ui = "mongodb://admin:admin@localhost:30332/admin?readPreference=primaryPreferred"
    mongodb_database = "blue-mongodb"
}
video_collector_mongodb_python_configmap: configmap.VideoCollectorMongodbPythonConfigmap {
    _application_configuration = kafka_server_configuration_properties
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
    image = "ghcr.io/javier-godon/video-collector-mongodb-python:bae6ea3-20241219t2249"
    imagePullPolicy = "IfNotPresent"
    namespace = "dev"
    replicas = 1
    services = [
        service.Service {
            type = "NodePort"
            ports = [
                {
                    port = 8002
                    nodePort = 31022
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
                    path = "/application.yaml"
                    subPath = "application.yaml"
                }
            ]
        }
    ]
    # subPath ensures that only the application.yaml file from the ConfigMap is mounted, avoiding replacing the entire target directory.
    configMaps = [
        video_collector_mongodb_python_configmap
    ]
}

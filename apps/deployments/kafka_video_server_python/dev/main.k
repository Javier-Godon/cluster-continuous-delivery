import konfig.models.kube.frontend
import base.application_configuration as configuration
import base.kafka_video_server_python_configmap as configmap

kafka_server_configuration_properties: configuration.ApplicationConfiguration {
    server_port = 8002
    kafka_producer_boostrap_servers = "10.152.183.90:9094"
}
kafka_video_server_python_configmap: configmap.KafkaVideoServerPythonConfigmap {
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
kafkaVideoServerPythonApplication: frontend.Server {
    image = "ghcr.io/javier-godon/kafka-video-server-python:853711c-20241219t1013"
    imagePullPolicy = "IfNotPresent"
    namespace = "dev"
    replicas = 1
    services = [
        service.Service {
            type = "NodePort"
            ports = [
                {
                    port = 8002
                    nodePort = 31020
                    name = "kafka-video-server-python-server"
                }
            ]
        }
    ]
    volumes = [
        v.Volume {
            name = "application-configuration"
            volumeSource = v.ConfigMap {
                name = "kafka-video-server-python-configmap"
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
        kafka_video_server_python_configmap
    ]
}

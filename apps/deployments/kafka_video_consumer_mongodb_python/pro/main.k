import konfig.models.kube.frontend
import deployments.kafka_video_consumer_mongodb_python.base.application_configuration as configuration
import deployments.kafka_video_consumer_mongodb_python.base.kafka_video_consumer_mongodb_python_configmap as configmap

kafka_consumer_mongodb_configuration_properties: configuration.ApplicationConfiguration {
    server_port = 8002
    kafka_consumer_boostrap_servers = "blue-cluster-kafka-bootstrap.kafka.svc.cluster.local:9092"
    kafka_consumer_auto_offset_reset = "earliest"
    mongodb_ui = "mongodb://admin:admin@blue-mongo-db.mongodb.svc.cluster.local:27017/admin?readPreference=primaryPreferred"
    mongodb_database = "blue-mongodb"
}
kafka_video_consumer_mongodb_python_configmap: configmap.KafkaVideoConsumerMongodbPythonConfigmap {
    _application_configuration = kafka_consumer_mongodb_configuration_properties
    namespace = "pro"
}
github_service_account: serviceaccount.ServiceAccount {
    # name = "github-service-pull-image-account"
    namespace = "pro"
}
# imagePullSecrets: [
#     {
#         name: "pull-image-from-github-registry-secret"
#     }
# ]
kafkaVideoConsumerMongodbPythonApplication: frontend.Server {
    image = "ghcr.io/javier-godon/kafka-video-consumer-mongodb-python:8b19688-2024-12-22T17-18"
    imagePullPolicy = "IfNotPresent"
    namespace = "pro"
    replicas = 1
    services = [
        service.Service {
            type = "NodePort"
            ports = [
                {
                    port = 8002
                    nodePort = 31022
                    name = "kafka-video-consumer-mongodb-python-server"
                }
            ]
        }
    ]
    volumes = [
        v.Volume {
            name = "application-configuration"
            volumeSource = v.ConfigMap {
                name = "kafka-video-consumer-mongodb-python-configmap"
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
        kafka_video_consumer_mongodb_python_configmap
    ]
}

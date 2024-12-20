import base.application_configuration as configuration
import base.kafka_video_consumer_mongodb_python_configmap as configmap
import konfig.models.kube.frontend
import konfig.models.kube.templates as res_tpl
import konfig.models.kube.frontend.container
import konfig.models.kube.frontend.container.env as e
import konfig.models.kube.frontend.container.port as cp
import konfig.models.kube.frontend.container.probe as p
import konfig.models.kube.frontend.volume as v
import konfig.models.kube.frontend.service as service
import konfig.models.kube.frontend.serviceaccount as serviceaccount

kafka_consumer_mongodb_configuration_properties = configuration.ApplicationConfiguration {
    server_port = 8002
    kafka_topics_processed = "processed-video"
    kafka_topics_streaming = "streaming-video"
    kafka_consumer_key_serializer = "serializer"
    kafka_consumer_value_serializer = "serializer"
    kafka_consumer_acks = "all"
}

kafka_video_consumer_mongodb_python_configmap = configmap.KafkaVideoConsumerMongodbPythonConfigmap {
    _application_configuration = kafka_consumer_mongodb_configuration_properties
    name = "kafka-video-consumer-mongodb-python-configmap"
}

kafka_video_video_consumer_mongodb_python = container.Main {
    name = "kafka-video-consumer-mongodb-python"
    livenessProbe = p.Probe {
        failureThreshold = 3
        initialDelaySeconds = 30
        periodSeconds = 5
        successThreshold = 1
        timeoutSeconds = 10
        handler = p.Exec {
            command = ["/bin/sh", "-c", "echo livenessProbe"]
        }
    }
    readinessProbe = p.Probe {
        failureThreshold = 3
        initialDelaySeconds = 30
        periodSeconds = 5
        successThreshold = 1
        timeoutSeconds = 10
        handler = p.Exec {
            command = ["/bin/sh", "-c", "echo readinessProbe"]
        }
    }
    startupProbe = p.Probe {
        failureThreshold = 3
        initialDelaySeconds = 30
        periodSeconds = 5
        successThreshold = 1
        timeoutSeconds = 10
        handler = p.Exec {
            command = ["/bin/sh", "-c", "echo startupProbe"]
        }
    }
}

github_service_account: serviceaccount.ServiceAccount {
    name = "github-service-pull-image-account"
    namespace = "dev"
    imagePullSecrets: [
        {
            name: "pull-image-from-github-registry-secret"
        }
    ]
}
kafkaVideoConsumerMongodbPythonApplication: frontend.Server {
    serviceAccount = github_service_account
    workloadType = "Deployment"
    name = "kafka-video-consumer-mongodb-python"
    mainContainer = kafka_video_video_consumer_mongodb_python
    useBuiltInLabels = False
    useBuiltInSelector = False
    selector = {
        app = "kafka-video-consumer-mongodb-python"
    }
    podMetadata.labels: {
        app = "kafka-video-consumer-mongodb-python"
    }
    needNamespace = False
    schedulingStrategy.resource = res_tpl.small
    configMaps = [
        kafka_video_consumer_mongodb_python_configmap
    ]
}

import deployments.video_collector_mongodb_python.base.video_collector_mongodb_python_configmap as video_collector_configmap
import deployments.video_collector_mongodb_python.base.video_collector_mongodb_python_app_config as configuration
import konfig.models.kube.frontend
import konfig.models.kube.templates as res_tpl
import konfig.models.kube.frontend.container
import konfig.models.kube.frontend.container.env as e
import konfig.models.kube.frontend.container.port as cp
import konfig.models.kube.frontend.container.probe as p
import konfig.models.kube.frontend.volume as v
import konfig.models.kube.frontend.service as service
import konfig.models.kube.frontend.serviceaccount as serviceaccount

kafka_server_app_configuration: configuration.VideoCollectorMongodbPythonAppConfiguration {
    server_port = 8002
}
video_collector_mongodb_python_configmap_impl: video_collector_configmap.VideoCollectorMongodbPythonConfigmap {
    _config = kafka_server_app_configuration
    name = "video-collector-mongodb-python-configmap"
}
kafka_video_video_server_python = container.Main {
    name = "video-collector-mongodb-python"
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
videoCollectorMongodbPythonApplication: frontend.Server {
    serviceAccount = github_service_account
    workloadType = "Deployment"
    name = "video-collector-mongodb-python"
    mainContainer = kafka_video_video_server_python
    useBuiltInLabels = False
    useBuiltInSelector = False
    selector = {
        app = "video-collector-mongodb-python"
    }
    podMetadata.labels: {
        app = "video-collector-mongodb-python"
    }
    needNamespace = False
    schedulingStrategy.resource = res_tpl.small
    configMaps = [
        video_collector_mongodb_python_configmap_impl
    ]
}

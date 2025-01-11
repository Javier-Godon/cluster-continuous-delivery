import deployments.erp_back_go.base.application_configuration as configuration
import deployments.erp_back_go.base.erp_back_go_configmap as configmap
import konfig.models.kube.frontend
import konfig.models.kube.templates as res_tpl
import konfig.models.kube.frontend.container
import konfig.models.kube.frontend.container.env as e
import konfig.models.kube.frontend.container.port as cp
import konfig.models.kube.frontend.container.probe as p
import konfig.models.kube.frontend.volume as v
import konfig.models.kube.frontend.service as service
import konfig.models.kube.frontend.serviceaccount as serviceaccount

erp_back_go_configuration_properties: configuration.ApplicationConfiguration {
    server_port = 8799
    postgres_db_driver = "postgres"
}
erp_back_go_configmap: configmap.ErpBackGoConfigmap {
    _application_configuration = erp_back_go_configuration_properties
    name = "erp-back-go-configmap"
}
erp_back_go = container.Main {
    name = "erp-back-go"
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
    name = "github-service-pull-image-account-erp-back-go"
    imagePullSecrets: [
        {
            name: "pull-image-from-github-registry-secret"
        }
    ]
}
erpBackGoApplication: frontend.Server {
    serviceAccount = github_service_account
    workloadType = "Deployment"
    name = "erp-back-go"
    mainContainer = erp_back_go
    useBuiltInLabels = False
    useBuiltInSelector = False
    selector = {
        app = "erp-back-go"
    }
    podMetadata.labels: {
        app = "erp-back-go"
    }
    needNamespace = False
    schedulingStrategy.resource = res_tpl.small
    configMaps = [
        erp_back_go_configmap
    ]
}

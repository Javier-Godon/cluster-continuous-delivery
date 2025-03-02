import deployments.reports_rendering_python_rust.base.reports_rendering_python_rust_configmap as reports_rendering_configmap
import deployments.reports_rendering_python_rust.base.application_configuration as configuration
import konfig.models.kube.frontend
import konfig.models.kube.templates as res_tpl
import konfig.models.kube.frontend.container
import konfig.models.kube.frontend.container.env as e
import konfig.models.kube.frontend.container.port as cp
import konfig.models.kube.frontend.container.probe as p
import konfig.models.kube.frontend.volume as v
import konfig.models.kube.frontend.service as service
import konfig.models.kube.frontend.serviceaccount as serviceaccount

reports_rendering_app_configuration: configuration.ApplicationConfiguration {
    server_port = 8008
}
reports_rendering_python_rust_configmap_impl: reports_rendering_configmap.ReportsRenderingPythonRustConfigmap {
    _config = reports_rendering_app_configuration
    name = "reports-rendering-python-rust-configmap"
}
reports_rendering_python_rust = container.Main {
    name = "reports-rendering-python-rust"
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
    name = "github-service-pull-image-account-reports-rendering-python-rust"
    namespace = "dev"
    imagePullSecrets: [
        {
            name: "pull-image-from-github-registry-secret"
        }
    ]
}
reportsRenderingPythonRustApplication: frontend.Server {
    serviceAccount = github_service_account
    workloadType = "Deployment"
    name = "reports-rendering-python-rust"
    mainContainer = reports_rendering_python_rust
    useBuiltInLabels = False
    useBuiltInSelector = False
    selector = {
        app = "reports-rendering-python-rust"
    }
    podMetadata.labels: {
        app = "reports-rendering-python-rust"
    }
    needNamespace = False
    schedulingStrategy.resource = res_tpl.small
    configMaps = [
        reports_rendering_python_rust_configmap_impl
    ]
}

import konfig.custom
import .pokedex_configmap as pokedex_config
import konfig.models.kube.frontend
import konfig.models.kube.templates as res_tpl
import konfig.models.kube.frontend.container
import konfig.models.kube.frontend.container.env as e
import konfig.models.kube.frontend.container.port as cp
import konfig.models.kube.frontend.container.probe as p
import konfig.models.kube.frontend.volume as v
import konfig.models.kube.frontend.service as service
import konfig.models.kube.frontend.serviceaccount as serviceaccount

pokedex_application_properties: custom.ApplicationProperties {
    server_port = 8089
    application_name = "pokedex"
    flyway_schemas = ["pokedex", "other"]
}
pokedex_configmap: pokedex_config.PokedexConfigmap {
    _application_properties = pokedex_application_properties
    name = "pokedex-configmap"
}
# namespace = "dev"
pokedex = container.Main {
    name = "pokedex"
    # envFrom = [
    #     e.EnvFromSource {
    #         configMapRef = "my-configmap"
    #     }
    # ]
    # ports = [
    #     cp.ContainerPort {
    #         containerPort = 12201
    #         protocol = "TCP"
    #     }
    # ]    
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

github_service_account = serviceaccount.ServiceAccount {
    name = "github-service-pull-image-account"
    namespace = "dev"
    imagePullSecrets: [
        {
            name: "pull-image-from-github-registry-secret"
        }
    ]
}

pokedexApplication: frontend.Server {
    serviceAccount = github_service_account
    workloadType = "Deployment"
    name = "pokedex"
    mainContainer = pokedex
    useBuiltInLabels = False
    useBuiltInSelector = False
    selector = {
        app = "pokedex"
    }
    podMetadata.labels: {
        app = "pokedex"
    }
    needNamespace = False
    schedulingStrategy.resource = res_tpl.small
    volumes = [
        v.Volume {
            name = "config"
            volumeSource = v.ConfigMap {
                name = "pokedex-configmap"
            }
            mounts = [
                v.Mount {
                    path = "/config"
                }
            ]
        }
    ]
    services = [
        service.Service {
            type = "NodePort"
            ports = [
                {
                    port = 8089
                    nodePort = 31010
                    name = "pokedex-server"
                }
            ]
        }
    ]
    configMaps = [
        pokedex_configmap
    ]
}
# data = config_map.data
# manifests.yaml_stream([pokedexApplication, pokedex_configmap, pokedex_deployment.items], {sep = "---"})

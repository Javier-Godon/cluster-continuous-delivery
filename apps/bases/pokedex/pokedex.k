import konfig.custom
import konfig.models.kube.frontend
import konfig.models.kube.templates as res_tpl
import konfig.models.kube.frontend.container
import konfig.models.kube.frontend.container.env as e
import konfig.models.kube.frontend.container.port as cp
import konfig.models.kube.frontend.container.probe as p
import konfig.models.kube.frontend.volume as v
import konfig.models.kube.frontend.service as service

_pokedex_application_properties = custom.ApplicationProperties {
    postgres_username = "postgres"
    postgres_password = "postgres"
    server_port = 8089
    application_name = "pokedex"
    # database_url = "r2dbc:postgresql://pokedex-postgres.postgres:5432/postgres"
    flyway_enabled = True
}
# flyway_locations = "classpath:db/migration/{vendor}"
# flyway_table = "flyway_schema_history"
# flyway_schemas = ["pokedex"]
# api_docs_path = "/pokedex/api-docs"
# swagger_ui_path = "/pokedex/swagger/api-docs-ui"
# pokedex_configmap = pokedex.PokedexConfigmap {
#     _application_properties = pokedex_application_properties
#     name = "pokedex-configmap"
#     namespace = "dev"
# }
_pokedex = container.Main {
    name = "pokedex"
    env: {
        "app.version": {value = "v1.0.0"}
    }
    envFrom = [
        e.EnvFromSource {
            configMapRef = "my-configmap"
        }
    ]
    ports = [
        cp.ContainerPort {
            containerPort = 12201
            protocol = "TCP"
        }
    ]
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
        successThreshold = 2
        timeoutSeconds = 10
        handler = p.Exec {
            command = ["/bin/sh", "-c", "echo readinessProbe"]
        }
    }
    startupProbe = p.Probe {
        failureThreshold = 3
        initialDelaySeconds = 30
        periodSeconds = 5
        successThreshold = 2
        timeoutSeconds = 10
        handler = p.Exec {
            command = ["/bin/sh", "-c", "echo startupProbe"]
        }
    }
}
pokedexApplication: frontend.Server {
    mainContainer = _pokedex
    needNamespace = True
    schedulingStrategy.resource = res_tpl.tiny
    # volumes = [
    #     v.Volume {
    #         name = "log-volume"
    #         volumeSource = v.EmptyDir {}
    #         mounts = [
    #             v.Mount {
    #                 container = "main"
    #                 path = "/home/admin/logs"
    #             }
    #         ]
    #     }
    # ]
    services = [
        service.Service {
            ports = [
                {
                    "port" = 6379
                }
            ]
        }
    ]
}
# data = config_map.data
# manifests.yaml_stream([pokedexApplication, pokedex_configmap, pokedex_deployment.items], {sep = "---"})

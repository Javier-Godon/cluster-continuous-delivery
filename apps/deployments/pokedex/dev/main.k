import konfig.models.kube.frontend
import konfig.custom
import deployments.pokedex.base.pokedex_configmap as pokedex_configuration

pokedex_application_properties: custom.ApplicationProperties {
    postgres_username = "postgres"
    postgres_password = "postgres"
    server_port = 8089
    flyway_enabled = True
    database_url = "r2dbc:postgresql://blue-postgres.postgres:5432/postgres"
}
pokedex_configmap: pokedex_configuration.PokedexConfigmap {
    _application_properties = pokedex_application_properties
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
pokedexApplication: frontend.Server {
    podMetadata: {
        annotations: {
            "instrumentation.opentelemetry.io/inject-java" = "pokedex-otel-instrumentation"
        }
    }
    image = "ghcr.io/javier-godon/ddd-hexagonal-vertical-slice-cqrs-reactive-kubernetes:2ec7c49-2024-12-22T17-03"
    imagePullPolicy = "IfNotPresent"
    namespace = "dev"
    replicas = 1
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

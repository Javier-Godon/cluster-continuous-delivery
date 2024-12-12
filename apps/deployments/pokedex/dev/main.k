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
pokedexApplication: frontend.Server {
    image = "ghcr.io/javier-godon/ddd-hexagonal-vertical-slice-cqrs-reactive-kubernetes:v0.0.1-snapshot"
    imagePullPolicy = "IfNotPresent"
    namespace = "dev"
    replicas = 1
    configMaps = [
        pokedex_configmap
    ]
}

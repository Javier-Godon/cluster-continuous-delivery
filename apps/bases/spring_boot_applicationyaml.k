import k8s.api.core.v1 as k8s

# Define environment-specific values
_config = {
    "dev": {
        "port": 8089
        "db_url": "r2dbc:postgresql://dev-postgres.postgres:5432/postgres"
        "db_username": "postgres-dev"
        "db_password": "postgres"
        "flyway_schema": "pokedex"
    }
    "prod": {
        "port": 8089
        "db_url": "r2dbc:postgresql://prod-postgres.postgres:5432/postgres"
        "db_username": "postgres-prod"
        "db_password": "postgres"
        "flyway_schema": "pokedex"
    }
}
# Select environment (passed as an argument or default to 'dev')
_environment = "dev"
# Get environment-specific config
_env_config = _config[_environment]
# Create a Kubernetes ConfigMap
pokedex_configmap = k8s.ConfigMap {
    apiVersion = "v1"
    metadata.name = "pokedex-configmap"
    data = {"application.yaml": """server:
port: ${_env_config["port"]}
spring:
  application:
    name: pokedex
  r2dbc:
    url: ${_env_config["db_url"]}
    username: ${_env_config["db_username"]}
    password: ${_env_config["db_password"]}
  flyway:
    enabled: true
    url: jdbc:${_env_config["db_url"]}
    user: ${_env_config["db_username"]}
    password: ${_env_config["db_password"]}
    locations: "classpath:db/migration/{vendor}"
    table: flyway_schema_history
    baselineOnMigrate: true
    createSchemas: true
    schemas:
      - ${_env_config["flyway_schema"]}
springdoc:
  api-docs:
    path: /pokedex/api-docs
  swagger-ui:
    path: /pokedex/swagger/api-docs-ui
"""}
}

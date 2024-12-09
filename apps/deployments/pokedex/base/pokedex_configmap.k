import konfig.models.kube.frontend.configmap
import konfig.custom

schema PokedexConfigmap(configmap.ConfigMap):
    _application_properties: custom.ApplicationProperties
    data = {
        "application.yaml": """server:
  port: ${_application_properties.server_port}

spring:
  application:
    name: ${_application_properties.application_name}
  r2dbc:
    url: ${_application_properties.database_url}
    username: ${_application_properties.postgres_username}
    password: ${_application_properties.postgres_password}
  flyway:
    enabled: ${_application_properties.flyway_enabled}
    url: ${_application_properties.database_url.replace("r2dbc", "jdbc")}
    user: ${_application_properties.postgres_username}
    password: ${_application_properties.postgres_password}
    locations: "${_application_properties.flyway_locations}"
    table: ${_application_properties.flyway_table}
    baselineOnMigrate: true
    createSchemas: true
    schemas: ${[schema  for schema in _application_properties.flyway_schemas ] }

springdoc:
  api-docs:
    path: ${_application_properties.api_docs_path}
  swagger-ui:
    path: ${_application_properties.swagger_ui_path}
"""
    }


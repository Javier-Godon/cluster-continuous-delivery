import konfig.models.kube.frontend.configmap
import deployments.erp_back_go.base.application_configuration as configuration

schema ErpBackGoConfigmap(configmap.ConfigMap):
    _application_configuration: configuration.ApplicationConfiguration
    data = {
        "application.yaml": """server:
  port: ${_application_configuration.server_port}
postgres:
  dbDriver: ${_application_configuration.postgres_db_driver}
  uri: ${_application_configuration.postgres_uri}
  user: ${_application_configuration.postgres_user}
  password: ${_application_configuration.postgres_password}
  database: blue-${_application_configuration.postgres_database}
"""
    }


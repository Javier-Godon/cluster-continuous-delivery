import konfig.models.kube.frontend.configmap
import .application_configuration as configuration

schema VideoCollectorMongodbPythonConfigmap(configmap.ConfigMap):
    _application_configuration: configuration.ApplicationConfiguration
    data = {
        "application.yaml": """server:
  port: ${_application_configuration.server_port}
mongodb:
  uri: ${_application_configuration.mongodb_ui}
  database: ${_application_configuration.mongodb_database}
"""
    }


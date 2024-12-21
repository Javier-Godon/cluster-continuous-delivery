import konfig.models.kube.frontend.configmap

schema ApplicationConfiguration:
    server_port?: int = 8089
    mongodb_ui: str
    mongodb_database: str

schema VideoCollectorMongodbPythonConfigmap(configmap.ConfigMap):
    _config: ApplicationConfiguration
    data = {
        "application.yaml": """server:
  port: ${_config.server_port}
mongodb:
  uri: ${_config.mongodb_ui}
  database: ${_config.mongodb_database}
"""
    }

    


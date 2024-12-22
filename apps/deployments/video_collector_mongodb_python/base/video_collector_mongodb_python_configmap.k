import konfig.models.kube.frontend.configmap as konfig_configmap
import deployments.video_collector_mongodb_python.base.video_collector_mongodb_python_app_config

schema VideoCollectorMongodbPythonConfigmap(konfig_configmap.ConfigMap):
    _config: video_collector_mongodb_python_app_config.VideoCollectorMongodbPythonAppConfiguration
    data = {
        "application.yaml": """server:
  port: ${_config.server_port}
mongodb:
  uri: ${_config.mongodb_ui}
  database: ${_config.mongodb_database}
"""
    }


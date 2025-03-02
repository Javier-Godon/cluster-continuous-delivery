import konfig.models.kube.frontend.configmap as configmap
import deployments.reports_rendering_python_rust.base.application_configuration as configuration

schema ReportsRenderingPythonRustConfigmap(configmap.ConfigMap):
    _config: configuration.ApplicationConfiguration
    data = {
        "application.yaml": """server:
  port: ${_config.server_port}
questdb:
  user: ${_config.questdb_user}
  pass: ${_config.questdb_pass}
  database: ${_config.questdb_database}
"""
    }


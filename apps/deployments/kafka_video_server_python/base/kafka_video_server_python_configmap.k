import konfig.models.kube.frontend.configmap
import deployments.kafka_video_server_python.base.application_configuration as configuration

schema KafkaVideoServerPythonConfigmap(configmap.ConfigMap):
    _application_configuration: configuration.ApplicationConfiguration
    data = {
        "application.yaml": """server:
  port: ${_application_configuration.server_port}
kafka:
  topics:
    processed: ${_application_configuration.kafka_topics_processed}
    streaming: ${_application_configuration.kafka_topics_streaming}
  producer:
    bootstrap-servers: ${_application_configuration.kafka_producer_boostrap_servers}
    key-serializer: ${_application_configuration.kafka_producer_key_serializer}
    value-serializer: ${_application_configuration.kafka_producer_value_serializer}
    acks: ${_application_configuration.kafka_producer_acks}
    compression-type: ${_application_configuration.kafka_producer_compression_type}
"""
    }


import konfig.models.kube.frontend.configmap
import base.application_configuration as configuration

schema KafkaVideoConsumerMongodbPythonConfigmap(configmap.ConfigMap):
    _application_configuration: configuration.ApplicationConfiguration
    data = {
        "application.yaml": """server:
  port: ${_application_configuration.server_port}
kafka:
  topics:
    processed: ${_application_configuration.kafka_topics_processed}
    streaming: ${_application_configuration.kafka_topics_streaming}
  consumer:
    bootstrap-servers:  ${_application_configuration.kafka_consumer_boostrap_servers}
    key-serializer: ${_application_configuration.kafka_consumer_key_serializer}
    value-serializer: ${_application_configuration.kafka_consumer_value_serializer}
    acks: ${_application_configuration.kafka_consumer_acks}
    auto-offset-reset: ${_application_configuration.kafka_consumer_auto_offset_reset}
mongodb:
  uri:  ${_application_configuration.mongodb_ui}
  database: ${_application_configuration.mongodb_database}
"""
    }


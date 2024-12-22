schema KafkaVideoConsumerMongodbPythonAppConfig:
    server_port?: int = 8089
    kafka_topics_processed?: str
    kafka_topics_streaming?: str
    kafka_consumer_boostrap_servers?: str
    kafka_consumer_key_serializer?: str
    kafka_consumer_value_serializer?: str
    kafka_consumer_acks?: "all" | "-1 " | "0" | "1" = "all"
    kafka_consumer_auto_offset_reset?: "latest" | "earliest" | "none"
    mongodb_ui: str
    mongodb_database: str


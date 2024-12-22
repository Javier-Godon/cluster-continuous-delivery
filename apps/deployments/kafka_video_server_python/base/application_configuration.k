schema ApplicationConfiguration:
    server_port?: int = 8089
    kafka_topics_processed?: str
    kafka_topics_streaming?: str
    kafka_producer_boostrap_servers?: str
    kafka_producer_key_serializer?: str
    kafka_producer_value_serializer?: str
    kafka_producer_acks?: "all" | "-1 " | "0" | "1" = "all"
    kafka_producer_compression_type?: "none" | "gzip" | "snappy" | "lz4" | "zstd"


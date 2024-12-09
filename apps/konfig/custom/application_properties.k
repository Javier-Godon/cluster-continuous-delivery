schema ApplicationProperties:
    postgres_username?: str
    postgres_password?: str
    server_port?: int = 8089
    application_name: str
    database_url?: str = "r2dbc:postgresql://${application_name}-postgres.postgres:5432/postgres"
    flyway_enabled?: bool = True
    flyway_locations?: str = "classpath:db/migration/{vendor}"
    flyway_table?: str = "flyway_schema_history"
    flyway_schemas?: [str]
    api_docs_path?: str = "/${application_name}/api-docs"
    swagger_ui_path?: str = "/${application_name}/swagger/api-docs-ui"


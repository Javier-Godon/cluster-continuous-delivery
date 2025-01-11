schema ApplicationConfiguration:
    server_port?: int = 8799
    postgres_db_driver: str
    postgres_uri: str
    postgres_user: str
    postgres_password: str
    postgres_database: str


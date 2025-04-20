import kcl_to_kusion

_deployment = {
    apiVersion = "apps/v1"
    kind = "Deployment"
    metadata = {
        name = "erp-back-go"
        namespace = "dev"
    }
    spec = {
        replicas = 1
        selector = {
            matchLabels = {
                app = "erp-back-go"
            }
        }
        template = {
            metadata = {
                labels = {
                    app = "erp-back-go"
                }
            }
            spec = {
                containers = [
                    {
                        image = "ghcr.io/javier-godon/erp-back:15a84eb-2025-01-12T19-16"
                        imagePullPolicy = "IfNotPresent"
                        livenessProbe = {
                            exec = {
                                command = [
                                    "/bin/sh"
                                    "-c"
                                    "echo livenessProbe"
                                ]
                            }
                            failureThreshold = 3
                            initialDelaySeconds = 30
                            periodSeconds = 5
                            successThreshold = 1
                            timeoutSeconds = 10
                        }
                        name = "erp-back-go"
                        readinessProbe = {
                            exec = {
                                command = [
                                    "/bin/sh"
                                    "-c"
                                    "echo readinessProbe"
                                ]
                            }
                            failureThreshold = 3
                            initialDelaySeconds = 30
                            periodSeconds = 5
                            successThreshold = 1
                            timeoutSeconds = 10
                        }
                        resources = {
                            limits = {
                                cpu = "1"
                                memory = "2Gi"
                                "ephemeral-storage" = "20Gi"
                            }
                            requests = {
                                cpu = "1"
                                memory = "2Gi"
                                "ephemeral-storage" = "20Gi"
                            }
                        }
                        startupProbe = {
                            exec = {
                                command = [
                                    "/bin/sh"
                                    "-c"
                                    "echo startupProbe"
                                ]
                            }
                            failureThreshold = 3
                            initialDelaySeconds = 30
                            periodSeconds = 5
                            successThreshold = 1
                            timeoutSeconds = 10
                        }
                        volumeMounts = [
                            {
                                mountPath = "/app/application.yaml"
                                name = "application-configuration"
                                subPath = "application.yaml"
                            }
                        ]
                    }
                ]
                serviceAccountName = "github-service-pull-image-account-erp-back-go"
                volumes = [
                    {
                        configMap = {
                            name = "erp-back-go-configmap"
                            items = [
                                {
                                    key = "application.yaml"
                                    path = "application.yaml"
                                }
                            ]
                        }
                        name = "application-configuration"
                    }
                ]
            }
        }
    }
}
_configmap = {
    apiVersion = "v1"
    data = {
        "application.yaml" = r"""server:
  port: 8799
postgres:
  dbDriver: postgres
  uri: postgres://postgres:postgres@blue-postgres.postgres.svc.cluster.local:5432/blue_postgres?sslmode=disable&search_path=public
  user: postgres
  password: postgres
  database: blue-blue-mongodb
"""
    }
    kind = "ConfigMap"
    metadata = {
        name = "erp-back-go-configmap"
        namespace = "dev"
    }
}
_service = {
    apiVersion = "v1"
    kind = "Service"
    metadata = {
        name = "erp-back-go"
        namespace = "dev"
    }
    spec = {
        ports = [
            {
                name = "erp-back-go-server"
                nodePort = 31060
                port = 8799
            }
        ]
        selector = {
            app = "erp-back-go"
        }
        $type = "NodePort"
    }
}
_service_account = {
    apiVersion = "v1"
    imagePullSecrets = [
        {
            name = "pull-image-from-github-registry-secret"
        }
    ]
    kind = "ServiceAccount"
    metadata = {
        name = "github-service-pull-image-account-erp-back-go"
        namespace = "dev"
    }
}
_namespace = {
    apiVersion = "v1"
    kind = "Namespace"
    metadata = {
        name = "dev"
    }
}

_postgres_namespace = {
    apiVersion = "v1"
    kind = "Namespace"
    metadata = {
        name = "postgres"
    }
}

_postgres_configmap = {
    apiVersion = "v1"
    kind = "ConfigMap"
    metadata = {
        name = "blue-postgres-config"
        labels = {
            app = "blue-postgres"
        }
        namespace = "postgres"
    }
    data = {
        POSTGRES_DB = "blue_postgres"
        POSTGRES_USER = "postgres"
        POSTGRES_PASSWORD = "postgres"
    }
}

_postgres_deployment = {
    apiVersion = "apps/v1"
    kind = "Deployment"
    metadata = {
        name = "blue-postgres"
        labels = {
            app = "blue-postgres"
        }
        namespace = "postgres"
    }
    spec = {
        replicas = 1
        selector = {
            matchLabels = {
                app = "blue-postgres"
            }
        }
        template = {
            metadata = {
                labels = {
                    app = "blue-postgres"
                }
            }
            spec = {
                containers = [
                    {
                        name = "postgres"
                        image = "postgres:17.0-alpine3.20"
                        imagePullPolicy = "IfNotPresent"
                        ports = [
                            {
                                containerPort = 5432
                            }
                        ]
                        envFrom = [
                            {
                                configMapRef = {
                                    name = "blue-postgres-config"
                                }
                            }
                        ]
                        volumeMounts = [
                            {
                                mountPath = "/var/lib/postgresql/data"
                                name = "postgresdb"
                            }
                        ]
                    }
                ]
                volumes = [
                    {
                        name = "postgresdb"
                        persistentVolumeClaim = {
                            claimName = "blue-postgres-pv-claim"
                        }
                    }
                ]
            }
        }
    }
}
_postgres_service = {
    apiVersion = "v1"
    kind = "Service"
    metadata = {
        name = "blue-postgres"
        labels = {
            app = "blue-postgres"
        }
        namespace = "postgres"
    }
    spec = {
        selector = {
            app = "blue-postgres"
        }
        $type = "NodePort"
        ports = [
            {
                port = 5432
                nodePort = 31543
            }
        ]
    }
}

_postgres_pv = {
    kind = "PersistentVolume"
    apiVersion = "v1"
    metadata = {
        name = "blue-postgres-pv-volume"
        labels = {
            $type = "local"
            app = "blue-postgres"
        }
    }
    spec = {
        storageClassName = "manual"
        capacity = {
            storage = "20Gi"
        }
        accessModes = [
            "ReadWriteMany"
        ]
        persistentVolumeReclaimPolicy = "Retain"
        hostPath = {
            path = "/mnt/data/postgres-volume"
        }
    }
}

_postgres_pvc = {
    kind = "PersistentVolumeClaim"
    apiVersion = "v1"
    metadata = {
        name = "blue-postgres-pv-claim"
        labels = {
            app = "blue-postgres"
        }
        namespace = "postgres"
    }
    spec = {
        storageClassName = "manual"
        accessModes = [
            "ReadWriteMany"
        ]
        resources = {
            requests = {
                storage = "20Gi"
            }
        }
    }
}

resources = [
    kcl_to_kusion.kusion_spec_stream(_namespace, [])
    kcl_to_kusion.kusion_spec_stream(_postgres_namespace, [])
    kcl_to_kusion.kusion_spec_stream(_postgres_configmap, [_postgres_namespace])
    kcl_to_kusion.kusion_spec_stream(_postgres_pv, [_postgres_namespace])
    kcl_to_kusion.kusion_spec_stream(_postgres_pvc, [_postgres_namespace, _postgres_pv])
    kcl_to_kusion.kusion_spec_stream(_postgres_deployment, [_postgres_namespace, _postgres_configmap, _postgres_pv, _postgres_pvc])
    kcl_to_kusion.kusion_spec_stream(_postgres_service, [_postgres_namespace, _postgres_deployment])
    kcl_to_kusion.kusion_spec_stream(_configmap, [_namespace])
    kcl_to_kusion.kusion_spec_stream(_service_account, [_namespace])
    kcl_to_kusion.kusion_spec_stream(_deployment, [_namespace, _service_account, _configmap, _postgres_deployment])
    kcl_to_kusion.kusion_spec_stream(_service, [_deployment])
]
# items = [
#     kcl_to_kusion.kusion_spec(_namespace, [])
#     kcl_to_kusion.kusion_spec(_deployment, [_namespace])
# ]
# # manifests.yaml_stream(items)
# manifests.yaml_stream(items, {sep = "---\n"})

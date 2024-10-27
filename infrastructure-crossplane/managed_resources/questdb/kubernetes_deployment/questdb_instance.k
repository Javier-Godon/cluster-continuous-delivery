items_questdb_instance = [
    {
        apiVersion = "kubernetes.crossplane.io/v1alpha2"
        kind = "Object"
        metadata = {
            name = "questdb-operator-install"
            namespace = "default"
        }
        spec = {
            forProvider = {
                manifest = {
                    apiVersion = "v1"
                    kind = "Namespace"
                    metadata = {
                        name = "questdb"
                    }
                }
            }
            providerConfigRef = {
                name = "kubernetes-provider"
            }
        }
    }
    {
        apiVersion = "kubernetes.crossplane.io/v1alpha2"
        kind = "Object"
        metadata = {
            name = "questdb-instance"
            namespace = "default"
        }
        spec = {
            forProvider = {
                manifest = {
                    apiVersion = "questdb.io/v1"
                    kind = "QuestDB"
                    metadata = {
                        name = "my-questdb"
                        namespace = "questdb"
                    }
                    spec = {
                        replicas = 1
                        storage = {
                            volumeSize = "10Gi"
                        }
                    }
                }
            }
            providerConfigRef = {
                name = "kubernetes-provider"
            }
        }
    }
]


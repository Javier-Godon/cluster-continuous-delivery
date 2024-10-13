items_questdb_operator = [
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
                        name = "questdb-system"
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
            name = "questdb-operator-crds"
            namespace = "default"
        }
        spec = {
            forProvider = {
                manifest = {
                    apiVersion = "apiextensions.k8s.io/v1"
                    kind = "CustomResourceDefinition"
                    metadata = {
                        name = "questdbs.questdb.io"
                    }
                    spec = {
                        group = "questdb.io"
                        names = {
                            kind = "QuestDB"
                            listKind = "QuestDBList"
                            plural = "questdbs"
                            singular = "questdb"
                        }
                        scope = "Namespaced"
                        versions = [
                            {
                                name = "v1"
                                served = True
                                storage = True
                                $schema = {
                                    openAPIV3Schema = {
                                        $type = "object"
                                    }
                                }
                            }
                        ]
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
            name = "questdb-operator-deployment"
            namespace = "default"
        }
        spec = {
            forProvider = {
                manifest = {
                    apiVersion = "apps/v1"
                    kind = "Deployment"
                    metadata = {
                        name = "questdb-operator"
                        namespace = "questdb-system"
                    }
                    spec = {
                        replicas = 1
                        selector = {
                            matchLabels = {
                                "control-plane" = "questdb-operator"
                            }
                        }
                        template = {
                            metadata = {
                                labels = {
                                    "control-plane" = "questdb-operator"
                                }
                            }
                            spec = {
                                serviceAccountName = "questdb-operator"
                                containers = [
                                    {
                                        name = "manager"
                                        image = "questdb/questdb-operator:v0.5.1"
                                        command = [
                                            "/manager"
                                        ]
                                    }
                                ]
                            }
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


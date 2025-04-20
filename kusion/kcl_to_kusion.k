schema KusionResource:
    id: str
    type: str = "Kubernetes"
    attributes: any
    dependsOn?: [str] = []
    extensions?: {str:str}

schema KusionSpec:
    resources: [KusionResource]

# Helper function to wrap a manifest into a Kusion resource
kusion_spec_stream = lambda manifest: any, depends_on: [any] -> KusionResource {
    __kusion_resource = KusionResource {
        if manifest.metadata.namespace is Undefined:
            id = "${manifest.apiVersion}:${manifest.kind}:${manifest.metadata.name}"
        else:
            id = "${manifest.apiVersion}:${manifest.kind}:${manifest.metadata.namespace}:${manifest.metadata.name}"
        dependsOn = ["${parent.apiVersion}:${parent.kind}:${parent.metadata.name}" if parent.metadata.namespace is Undefined else "${parent.apiVersion}:${parent.kind}:${parent.metadata.namespace}:${parent.metadata.name}" for parent in depends_on]
        attributes = manifest
    }
}
# kusion_spec = KusionSpec {
#     resources = [__kusion_resource]
# }

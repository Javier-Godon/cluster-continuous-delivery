items_helm_install = [
    {
        apiVersion = "pkg.crossplane.io/v1"
        kind = "Provider"
        metadata = {
            name = "provider-helm"
        }
        spec = {
            package = "xpkg.upbound.io/crossplane-contrib/provider-helm:v0.17.0"
        }
    }
]

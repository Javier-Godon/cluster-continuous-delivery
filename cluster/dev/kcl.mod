[package]
name = "cluster-continuous-delivery"
version = "1.0.0"

[dependencies]
kam = { git = "https://github.com/KusionStack/kam.git", tag = "0.2.0" }
service = {oci = "oci://ghcr.io/kusionstack/service", tag = "0.1.0" }
network = { oci = "oci://ghcr.io/kusionstack/network", tag = "0.2.0" }
k8s_manifest = { oci = "oci://ghcr.io/kusionstack/k8s_manifest", tag = "0.1.0" }

# describes the list of files Kusion should look for when parsing the application configuration.
[profile]
entries = ["main.k"]

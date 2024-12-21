[package]
name = "dev"
edition = "v0.10.0"
version = "0.0.1"

[dependencies]
deployments = { path = "../../../deployments" }
k8s = "1.31.2"
konfig = { path = "../../../konfig" }

[profile]
entries = ["../base/video_collector_mongodb_python.k", "main.k", "${konfig:KCL_MOD}/models/kube/render/render.k"]

[package]
name = "dev"
edition = "v0.10.0"
version = "0.0.1"

[dependencies]
deployments = { path = "../../../deployments" }
konfig = { path = "../../../konfig" }
k8s = "1.31.2"

[profile]
entries = ["../base/kafka_video_server_python.k", "main.k", "${konfig:KCL_MOD}/models/kube/render/render.k"]

[package]
name = "stg"
edition = "v0.10.0"
version = "0.0.1"

[dependencies]
k8s = "1.31.2"
konfig = { path = "../../../konfig" }
deployments = { path = "../../../deployments" }

[profile]
entries = ["../base/kafka_video_server_python.k", "main.k", "${konfig:KCL_MOD}/models/kube/render/render.k"]

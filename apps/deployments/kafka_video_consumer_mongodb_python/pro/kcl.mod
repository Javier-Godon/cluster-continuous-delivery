[package]
name = "pro"
edition = "v0.10.0"
version = "0.0.1"

[dependencies]
konfig = { path = "../../../konfig" }
deployments = { path = "../../../deployments" }

[profile]
entries = ["../base/kafka_video_consumer_mongodb_python.k", "main.k", "${konfig:KCL_MOD}/models/kube/render/render.k"]

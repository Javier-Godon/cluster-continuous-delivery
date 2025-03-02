[package]
name = "pro"
edition = "v0.10.0"
version = "0.0.1"

[dependencies]
k8s = "1.31.2"
konfig = { path = "../../../konfig" }
deployments = { path = "../../../deployments" }

[profile]
entries = ["../base/reports_rendering_python_rust.k", "main.k", "${konfig:KCL_MOD}/models/kube/render/render.k"]

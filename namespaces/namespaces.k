"""
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""
import manifests

items = [
    {
        apiVersion = "v1"
        kind = "Namespace"
        metadata = {
            name = "argocd"
        }
    }
    {
        apiVersion = "v1"
        kind = "Namespace"
        metadata = {
            name = "questdb"
        }
    }
]
manifests.yaml_stream(items)

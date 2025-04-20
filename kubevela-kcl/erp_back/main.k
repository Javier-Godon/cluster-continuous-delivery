import oam

oam.Application {
    metadata.name: "erp-back",
    metadata.namespace: "default",
    metadata.labels: {
        app: "erp-back"
    },
    metadata.annotations: {
        description: "ERP Back-end Application"
    }
    spec.components = [
        { 
            name = metadata.name
            type = "microservice"
            properties = {
                image = "ghcr.io/javier-godon/erp-back:15a84eb-2025-01-12T19-16"
            }            
        }
    ]
}




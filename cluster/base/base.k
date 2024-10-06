mport kam.v1.app_configuration as ac
import service
import service.container as c
import network as n
import postgres

# main.k declares the customized configuration codes for default stack. 
continuous_delivery: ac.AppConfiguration {   
    accessories: {
        "network": n.Network {
            ports: [
                n.Port {
                    port: 8080
                }
            ]
        }
        "postgres": postgres.PostgreSQL {
            type: "local"
            version: "17.0"
        }
    }
}
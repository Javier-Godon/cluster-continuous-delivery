# The configuration codes in perspective of developers.
import kam.v1.app_configuration as ac
import service
import service.container as c

# Please replace the ${APPLICATION_NAME} with the name of your application, and complete the 
# 'AppConfiguration' instance with your own workload and accessories.
${APPLICATION_NAME}: ac.AppConfiguration {
	workload: service.Service {
		containers: {

		}
	}
	accessories: {

	}
}
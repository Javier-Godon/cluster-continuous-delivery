# Cluster Continuous Delivery

This repository is designed to facilitate the deployment of projects on Kubernetes using modern tools like Crossplane, KCL, and ArgoCD. It is organized into four main directories, each serving a specific purpose:

---

## 📂 [.github](https://github.com/Javier-Godon/cluster-continuous-delivery/tree/main/.github)

This folder contains workflows for **GitHub Actions**, divided into two main groups:

1. **Image Tag Update Workflows**  
   These workflows automatically update the container image tag in the Kubernetes manifests whenever changes to the project code are merged into the `main` branch.

2. **Kubernetes Manifest Update Workflow**  
   The [generate-manifests-from-kcl.yaml](https://github.com/Javier-Godon/cluster-continuous-delivery/blob/main/.github/workflows/generate-manifests-from-kcl.yaml) workflow updates Kubernetes manifests manually when deployment configuration files are modified.

---

## 📂 [apps](https://github.com/Javier-Godon/cluster-continuous-delivery/tree/main/apps)

This folder contains the **KCL configurations** required to generate Kubernetes manifests for deployment. 

- The repository uses the [Konfig](https://www.kcl-lang.io/docs/user_docs/guides/working-with-konfig/overview) library from KCL, enabling the generation of all necessary manifests with minimal configuration.  
- Each project has its own subfolder:
  - A `base` folder containing shared project configurations.
  - Environment-specific folders (e.g., `dev`, `prod`) with configurations unique to that environment.

### ✨ Key Features:
- **Dynamic ConfigMaps**: Using string interpolation, variables, and schemas in KCL, you can easily define and manage Kubernetes ConfigMaps.

---

## 📂 [infrastructure-crossplane](https://github.com/Javier-Godon/cluster-continuous-delivery/tree/main/infrastructure-crossplane)

This folder contains the necessary **Crossplane manifests** and **Custom Resource Definitions (CRDs)** for each provider to deploy the required infrastructure for each project. 

- The `managed_resources` folder organizes the manifests by tool, making it easy to locate and manage resources.

---

## 📂 [argocd](https://github.com/Javier-Godon/cluster-continuous-delivery/tree/main/argocd)

This folder includes the **ArgoCD manifests** required to implement GitOps, ensuring that the Kubernetes resources defined in the repository are deployed and synchronized effectively.

---

## 📖 Blueprint

![image](./resources/continuous_delivery_blueprint.jpg)

To understand the overall architecture of this repository, please refer to the slide [continuous_delivery_blueprint.odp](resources/continuous_delivery_blueprint.odp).

As described in the slide, the system consists of the following components:

### Overview

1. **Code Repositories**  
   Each application/microservice has its own code repository.  
   - In this repository structure, there is a folder for the project (e.g., `pokedex`) containing:
     - A `src` folder with the application code (e.g., Java for the Pokedex project).
     - A `dagger_python` folder with a Python project implementing a CI/CD pipeline using Dagger. This Python project includes all necessary requirements and configurations to run in a container.
     - A `.github` folder defining the GitHub Actions workflows:
       - `run-dagger-ci-pipeline.yaml`: Executes the pipeline in the `dagger_python` folder to build a container image, assign it a commit SHA-based tag, and push it to the container registry.
       - `trigger-dagger-ci-pipeline.yaml`: Emits a custom event (`dagger-pipeline-trigger`) with the commit SHA in its payload.

2. **Deployment/GitOps Repository**  
   - This repository contains the folder structure to generate the final Kubernetes manifests ArgoCD uses as the desired state. It includes:
     - **Infrastructure-Crossplane**: Contains Crossplane manifests and resources for infrastructure deployment.
     - **ArgoCD Manifests**: Defines how each application/environment is deployed. For example, `argocd/managed/apps/pokedex/pokedex-dev.yaml` specifies the desired state for the Pokedex application in the `dev` environment.
     - **Apps Folder**: Defines configurations in KCL to build final YAML manifests:
       - A `base` folder for common configurations across environments.
       - Environment-specific folders (`dev`, `stg`, `prod`) containing the final YAML manifests under the `manifests` folder (e.g., `apps/deployments/pokedex/dev/manifests/kubernetes-manifests.yaml`).
     - **GitHub Workflows**:
       - `generate-manifests-from-kcl.yaml`: Updates the YAML manifests when a platform engineer modifies KCL files in this repository.
       - Environment-specific workflows (e.g., `update-image-tag-in-pokedex-dev.yaml`) that update the container image tag in the corresponding YAML manifest.

3. **GitHub Container Registry**  
   - Stores container images for each application, tagged based on the commit SHA. A new image is generated and tagged every time a commit is merged into `main`.

4. **Kubernetes Cluster**  
   - Hosts the GitOps tool (ArgoCD), which continuously reconciles the desired state (defined in the GitOps repository's YAML manifests) with the actual state in the cluster.
   - Utilizes **Sealed Secrets** to securely encrypt and store secrets in the GitOps repository. ArgoCD ensures the container images described in the YAML manifests are downloaded from the GitHub Container Registry.

---

This section provides a high-level overview of the system's blueprint. Future sections will delve deeper into each component, its configuration, and its interaction with the system as a whole.

## Code Repositories

To implement CI using Dagger, we embed a lightweight Python application into each project. This replaces traditional CI configurations like `Jenkinsfile` (specific to Jenkins) or Tekton pipeline manifests (specific to Tekton). This approach offers significant advantages:

- **Portability**: Pipelines run as programs within containers, making them compatible with any environment (Jenkins, Tekton, GitHub Actions, local machines, etc.).
- **Infrastructure Agnostic**: The pipeline runs seamlessly across platforms without modification, simplifying migrations and execution.
- **Local Testing**: Developers can execute and test pipelines locally, ensuring reliability before committing changes.

### Example Project
For this example, we use a **Java/Spring Boot project**:  

![image](./resources/java_project_wit_dagger_python_structure.png)

👉 [Java Project Repository](https://github.com/Javier-Godon/ddd-hexagonal-vertical-slice-cqrs-reactive-kubernetes)

The Python project for defining the Dagger pipeline resides here:  
👉 [Dagger Python Project](https://github.com/Javier-Godon/ddd-hexagonal-vertical-slice-cqrs-reactive-kubernetes/tree/main/pokedex/dagger_python)

The pipeline script can be found here:  
👉 [Pipeline Script](https://github.com/Javier-Godon/ddd-hexagonal-vertical-slice-cqrs-reactive-kubernetes/blob/main/pokedex/dagger_python/main.py)

---

### Setting Up the Python Project in IntelliJ for a Spring Boot Repository

Follow these steps to include the Python Dagger project in your existing Java/Spring Boot repository:

1. **Install Python Plugin**  
   Install the Python plugin in IntelliJ IDEA.

2. **Create a Virtual Environment**  
   ```
   python3 -m venv .venv3.12
   ```
3. **Ignore Virtual Environment**
   
   - Add .venv3.12 to .gitignore.
   
4. **Activate Virtual Environment**
   For Ubuntu/Linux:
   ```
   source .venv3.12/bin/activate
   ```
5. **Add Python SDK**

    - Go to File > Project Structure > SDKs.
    - Add the Python interpreter:
    - Path: .venv3.12/bin/python (Linux/macOS) or .venv3.12/Scripts/python.exe (Windows).
    - Name it .venv3.12.   
6. **Create a New Module for Python**

    - Go to File > Project Structure > + Add Module.
    - Select Python as the module type.
    - Name the module dagger_python and place it inside the root of the project (e.g., pokedex).
    - Use .venv3.12 as the virtual environment.
7. **Mark as Python Source Root**
   - Right-click the dagger_python folder > Mark Directory as > Sources Root.    
8. **Initialize Files**
    - Create main.py for your pipeline logic.
    - Create requirements.txt to manage dependencies.
9. **Exclude Virtual Environment Folder**
    - Right-click .venv3.12 > Mark Directory as > Excluded.
10. **Initialize Dagger Module**
    - Run the following command from the root directory:
      ```
      dagger init --sdk=python --source=./dagger_python
      ```

Once this setup is complete, you can run the pipeline from any environment by executing: 
```
      python3 dagger_python/main.py
```

---
### GitHub Actions Workflows
Since GitHub Actions is the chosen CI tool, two workflows need to be defined:

Run CI Pipeline
This workflow, triggered on merges to the main branch, executes the Dagger pipeline:

👉 run-dagger-ci-pipeline.yaml

Trigger CD Pipeline
This workflow emits an event captured by the deployment repository, updating manifests with the new image tag:

👉 trigger-dagger-ci-pipeline.yaml

## Deployment/GitOps Repository

This repository is structured into four main folders, each serving a distinct purpose in the GitOps workflow:

### 1. **apps**
- **Purpose**: Configures the deployments for each application.
- **Output**: A `kubernetes-manifests.yaml` file is generated within the `manifests` folder for each environment and application.
- **Implementation**: Defined and structured using **KCL** and the **Konfig project** for consistent and reusable configurations.

### 2. **argocd**
- **Purpose**: Contains ArgoCD manifests.
- **Organization**: Managed by platform engineers, the manifests are organized by application and environment.

### 3. **infrastructure-crossplane**
- **Purpose**: Provides the configurations for Crossplane.
- **Functionality**: Enables Kubernetes to act as an orchestrator by reconciling the desired state with the actual state of the infrastructure.

### 4. **.github**
- **Purpose**: Hosts GitHub Actions workflows.
- **Functionality**:
  - Orchestrates updates to the Kubernetes manifests (`kubernetes-manifests.yaml`).
  - Handles actions triggered by platform engineers on this repository or by software engineers merging changes into `main`.
  - Automatically updates image tags specified in the Kubernetes deployments of `kubernetes-manifests.yaml`.

This structure ensures a clear separation of concerns, empowering both platform and software engineers to collaborate seamlessly in maintaining deployments and infrastructure state.

### 1. **apps**

![image](./resources/repository_structure_apps_detailed.png)

The `apps` folder is based on **KCL language** ([KCL](https://www.kcl-lang.io/)) and its project **Konfig** ([Konfig GitHub](https://github.com/kcl-lang/konfig)). A detailed description of Konfig can be found [here](https://www.kcl-lang.io/docs/user_docs/guides/working-with-konfig/overview).

KCL files use the `.k` extension, while dependency files use `.mod` and `.mod.lock`. The `apps` folder contains two subfolders:

#### **konfig**
- Includes the entire Konfig project.
- Responsible for generating all Kubernetes manifests in YAML format.
- Uses minimal configurations written in KCL language.
- Specific configurations for each application and environment are located in the `deployments` folder.

#### **deployments**
- Organized by application, where each application has its own folder.
- Inside each application folder:
  - A `base` folder contains common configuration for the application.
  - Environment-specific folders (e.g., `dev`, `prod`) each have a `main.k` file with the environment-specific configuration.
- The final YAML manifests are generated in the `manifests` folder as the file `kubernetes-manifests.yaml`.

##### Example: Pokedex Project (Java Spring Boot)

![image](./resources/repository_structure_apps_pokedex_detailed.png)
![image](./resources/pokedex_folder_structure.png)

- The Pokedex application has an environment folder `dev` with:
  - `pokedex-configmap.k`: Defines the Spring Boot `application.yaml`, where each configuration can be specified via a variable.
  - `pokedex.k`: Configures the Kubernetes manifests to generate.
  - `dev/main.k`: Specifies the environment-specific configurations for development.
- To generate the YAML manifests, run the following command from the root of the project:
  ```
  kcl -r apps/deployments/pokedex/dev -o apps/deployments/pokedex/dev/manifests/kubernetes-manifests.yaml
  ```

Thanks to KCL:

Updating the image tag is straightforward since it is a parameter of a schema that can be easily configured.
There's no need for complex text parsing scripts to modify the configuration.
This structure ensures a clean, maintainable way to manage Kubernetes manifests for multiple applications and environments. 

---
**full process to define the deployment of an app**
```  
   Create folders base and dev,stg,pro,...(depending on your case)
   over the folder with the name of the project (ex: apps/deployments/pokedex):
   kcl mod init
   kcl mod add k8s:1.31.2 
   kcl mod add ../../konfig
   kcl mod add ../../deployments

   and delete the folder main.k that will be created

   over the rest of the folders environment folder f(base,dev, stg, pro,..) do:
   kcl mod init 
   kcl mod add k8s:1.31.2 
   kcl mod add ../../../konfig 
   kcl mod add ../../../deployments 

   over every environment add this line to kcl.mod

   [profile]
   entries = ["../base/<project_name>.k", "main.k", "${konfig:KCL_MOD}/models/kube/render/render.k"]

   in folder base create the file: <project-name>.k like pokedex.k
   (make sure the name of the folder that contains the project has the same name as project-name)
   Create a <project_name_configmap>.k like pokedex_configmap.k

   for a python project create too:
   application_configuration.k

You can find examples for projects in Java/Spring Boot (pokedex), Python (kafka_video_server_python, kafka_video_consumer_mongodb_python), GoLang (erp_back) and Elixir/Phoenix
   
```
---

![image](./resources/application_kcl_definition.jpg)


As we can see in the image, KCL allows us to define schemas, such as `PokedexConfigmap` (as shown in **1. Schema definition**), which contains a series of configurable parameters. In our case, we use this schema as a class (in Object-Oriented Programming terminology) to generate a ConfigMap. This ConfigMap will overwrite the `application.yaml` configuration file of our Spring Boot project for each environment. The advantage is that, as we can see, each value is a configurable parameter.

In **2. Basic common configuration**, we create what in Object-Oriented Programming terminology would be the concrete classes or instances based on the schemas defined in KCL. These schemas could be:
- Our custom-defined schemas.
- Schemas provided by the Konfig project of KCL.
- Schemas from the [k8s:1.31.2](https://artifacthub.io/packages/kcl/kcl-module/k8s) module, which we imported into our KCL project definition. This module essentially contains the schemas of the Kubernetes API.

We can observe that generic parameters for all environments are defined, such as `server_port`, `application_name`, and `flyway_schemas` for our `application.yaml`. Similarly, generic configurations are defined for the ConfigMap and what in Konfig represents the main configuration for the container.

Later, in **3. Concrete configuration for DEV**, we define specific configurations for the development environment. Unlike Helm or Kustomize, we do not work with plain text and apply composition. Instead, our `pokedex_configmap` object will already include the parameter values defined in **2** and additionally any specific parameters we indicate at this stage, such as `namespace = "dev"`.

More importantly, as we can see, `frontend.Server` (a Konfig schema from KCL) contains a parameter `image`, which will be used to generate the `image` parameter of the Kubernetes deployment in YAML format (**4. Final result kubernetes-manifests.yaml**). This enables us to modify it easily and 
automatically within our CI/CD process.

---

### 2. **argocd**

![image](./resources/argocd_configuration.jpg)


In the `argocd` folder, we find the ArgoCD manifests grouped by application and environment. As an example, the image shows the manifest for the `pokedex` application in the `dev` environment.

When we apply this Kubernetes object to our cluster (`kubectl apply -f pokedex-dev.yaml`), ArgoCD will continuously monitor any changes in the repository specified in `source.repoURL` (in our case, this is our Deployment/GitOps repository). Specifically, it will track the contents of the folder indicated in `source.path` (`apps/deployments/dev/manifests`) and reconcile the desired state defined in that path with what is actually deployed in the namespace dev of our cluster. This reconciliation happens constantly, by default every 3 minutes.

This way, any change made to the `kubernetes-manifests.yaml` file in that folder (for example, a change in the tag of the image to be deployed) will be detected and applied automatically (or manually, depending on the configuration we specify for each environment).

---

### 3. **infrastructure-crossplane**

![image](./resources/crossplane_configuration.jpg)

Suppose we want to deploy PostgreSQL in our cluster. For this, we navigate to the `postgresql` folder, where we find a subfolder named `crossplane`. This folder will always contain the following:

1. A [Composite Resource Definition (XRD)](https://docs.crossplane.io/latest/concepts/composite-resource-definitions/), in our case, `xrd_postgresql.yaml`.  
2. A [Composition](https://docs.crossplane.io/latest/concepts/compositions/), in our case, `x_postgresql.yaml`.  
   This composition is based on the XRD and specifies exactly which components we want Crossplane to reconcile in our cluster and which provider will handle them. In our case, since we are deploying directly onto our cluster, we use the [Kubernetes Provider](https://github.com/crossplane-contrib/provider-kubernetes). A complete list of available providers can be found on the [Upbound Marketplace](https://marketplace.upbound.io/providers).  
3. A [Claim](https://docs.crossplane.io/latest/concepts/claims/), in our case, `claim_postgresql.yaml`.  

To deploy this infrastructure, the deployment order must always be:  
**Composite Resource Definition -> Composition -> Claim**.

```
kubectl apply -f xrd_postgresql.yaml
kubectl apply -f x_postgresql.yaml
kubectl apply -f claim_postgresql.yaml
```

### 4. **.github**

![image](./resources/github_folder_structure.png)

### Explanation of the `.github` Folder

This folder contains the necessary resources for configuring the CI/CD aspects related to GitHub Actions.  

> **Note:** As mentioned, our Dagger pipelines can run anywhere, so we could choose any other tool, such as Jenkins or Tekton, without needing to modify these pipelines.  

We have two types of workflows:

1. **Workflow to update `kubernetes-manifests.yaml` when a Platform Engineer makes changes in this repository (Deployment/GitOps repository).**  
   For example, suppose the file `apps/deployments/pokedex/base/pokedex.k` is modified. Since this file is a generic configuration for the Pokedex application and affects all environments, this change will trigger the workflow `generate-manifests-from-kcl.yaml`.  
   This workflow will update the three `kubernetes-manifests.yaml` files in the respective subfolders for each environment (dev, pro, and stg).  
   While this updates the manifests, it does not modify the image tag of our application. However, ArgoCD will detect these changes and apply them to the cluster as soon as it identifies the updates.  
   To generate the new manifests, the corresponding KCL command is used:  
   ```
   kcl -d apps/deployments/$SERVICE/$ENVIRONMENT -o $OUTPUT_DIR/kubernetes-manifests.yaml
   kcl -d apps/deployments/$PROJECT/$ENV -o $OUTPUT_DIR/kubernetes-manifests.yaml
   ```

2. **Workflow per application and environment**
   For example, for Pokedex in the dev environment, we have the workflow update-image-tag-in-pokedex-dev.yaml.

   As shown, modifying the image tag is straightforward with KCL. We simply update the value of a parameter, **pokedexApplication.image** in a well-defined schema.
   Since we are using Python, we utilize the library [kcl-lib](https://pypi.org/project/kcl-lib/).
   ```
   python -c "
          import kcl_lib.api as api

          file = 'apps/deployments/pokedex/dev/main.k'
          specs = [f'pokedexApplication.image=\"ghcr.io/javier-godon/ddd-hexagonal-vertical-slice-cqrs-reactive-kubernetes:${{ github.event.client_payload.image_tag }}\"']
          args = api.OverrideFile_Args(file=file, specs=specs)
          api.API().override_file(args)
          "
   ```

   After modifying this parameter, we regenerate the corresponding kubernetes-manifests.yaml files.
   ```
   kcl -r apps/deployments/pokedex/dev -o apps/deployments/pokedex/dev/manifests/kubernetes-manifests.yaml
   ```
   In this case, what is being modified is the image tag in the manifests, unlike the previous case.  

   > **Note:** Remember that this workflow is triggered by a `repository_dispatch` event: `image-tag-in-pokedex-dev-updated`. This means it runs after the corresponding CI pipeline has executed in the Pokedex application repository because a developer merged changes into the `main` branch. These changes result in a new image being built, tagged, and pushed to our registry.  

   As a result, ArgoCD in this case will need to pull the new image with the specified tag in the `kubernetes-deployment.yaml` from the registry and redeploy the application with the updated version.  








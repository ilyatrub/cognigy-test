# Cognigy Coding Assignment


## Task 1

### Docker

#### Description

You will find a Dockerfile in `password-generator` dir. I also created `requirements.txt` file to install python dependencies (Flask).
In order to build the image, use:
```
docker build -t passgen ./password-generator
```

In order to run the image, use:
```
docker run -d --rm --name passgen -p 3000:3000 passgen [COMMAND]
```
By default application exposes port 3000, and listens on `0.0.0.0:3000`. Image also allows to execute other Flask command by providing them in [COMMAND] parameter.

In order to test application, you can use curl, Postman, etc.
Here are some requests to check whether application works as expected:
```
# check / enpoint
curl http://localhost:3000
# check /generate-passwords endpoint
curl -X POST http://localhost:3000/generate-passwords -H "Content-Type: application/json" -d '{"num_passwords": 4, "min_length": 12, "numbers": 5, "special_chars": 2}' 
curl -X POST http://localhost:3000/generate-passwords -H "Content-Type: application/json" -d '{"num_passwords": 3, "min_length": 12, "numbers": 0, "special_chars": 4}'
curl -X POST http://localhost:3000/generate-passwords -H "Content-Type: application/json" -d '{"num_passwords": 6, "min_length": 12, "numbers": 6, "special_chars": 0}'
```

#### Things to imporove

- Exposed port number can be provided as build arg
- Scripts to build and push the image to repository can be created
- Script to run the image can be created

---
### Helm Chart

#### Description

You will find a Helm chart in `helm-chart` dir. The chart allows for generic deployment and also Blue/Green deployment. Chart assumes that Ingress Controller exists in the cluster and required imagePullSecret also exists. Otherwise `extraManifests` can be used to deploy them.

In order to use generic deployment, set:
- `general.productionColor=blue`
- `blueDeployment.enabled=true`
- `greenDeployment.enabled=false`
- `service.production.enabled=true`
- `service.staging.enabled=false`

Generic deployment will provide you with Ingress, Service and Deployment for application.

In order to use Blue/Green deployment enable both deployments and services. After applying to the cluster, there will be 2 Deployments created (blue and green), 2 Services (production and staging) and 1 Ingress (that has rules for both services). Blue/Green switch is done by adjusting `general.productionColor` value. What is happening behind is that selectors that production and staging services are using will be changed to target another (blue -> green, green -> blue) deployment.

In order to install the chart, use:
```
helm install passgen ./helm-chart -f values.yaml -n testing
```
In order to upgrade:
```
helm upgrade passgen ./helm-chart -f blue_green_deployment_values.yaml -n testing
```
In order to clean up:
```
helm uninstall passgen
```

#### Things to improve

- Allow more deployment configuration (volumes, envFrom, resource limits and requests, etc.)
- Allow more configuration for services and ingress
- Additional refactoring and usage of _helpers is possible
- Blue/Green deployment is not recommended to be implemented in Helm by Helm itself. This is a more suitable task for service meshes (e.g. Istio) or Ingress Controllers.
- Create scripts to package and push chart to repo.

---

## Task 2

### Terraform

#### Description

In this task I assumed that Terraform modules can be used, so I used AWS VPC and AWS EKS module. The first one is creating VPC, public and private subnets, security groups, internet gateway and NAT gateway. The AWS EKS module is responsible for creating a managed EKS cluster, required certificates and roles for it and node group with autoscaling. 

You will find variables used in `variables.tf`, setup of required versions, providers and backends in `terraform.tf`, outputs in `outputs.tf` and the main code in `main.tf`.

Use the following commands to init the state, plan and apply infrastructure and then clean up:
```
terraform init
terraform plan
terraform apply
terraform destroy
```

#### Things to improve

- Allow more configuration through variables
- Review what is created by modules to tighten up and adjust security measures to the needs of company
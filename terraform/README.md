# Deploy the Aspen Mesh Demo Site on a New EKS Cluster

This deploys the following:

- Creates a new  VPC, 3 Private Subnets and 3 Public Subnets
- Creates Internet gateway for Public Subnets and NAT Gateway for Private Subnets
- Creates EKS Cluster Control plane with one managed node group
- Installs Istio on the EKS cluster
- Installs Prometheus, Grafana, and Kiali on the EKS cluster
- Deploys the Aspen Mesh Demo Site to the EKS cluster

## How to Deploy

### Prerequisites:

Ensure that you have installed the following tools before you start working with this module:

 1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
 1. [Kubectl](https://Kubernetes.io/docs/tasks/tools/)
 1. [Helm](https://helm.sh/docs/intro/install/)
 1. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### Deployment Steps

#### Step 1: Clone the repo using the command below

```shell script
git clone https://github.com/aspenmesh/aspenmesh-demo-site.git
```

#### Step 2: Run Terraform Init

Initialize a working directory with configuration files

```shell script
cd aspenmesh-demo-site/terraform
terraform init
```
#### Step 3: Update variables

 1. Edit [`demo-site.auto.tfvars`](demo-site.auto.tfvars) and change the variables to appropriate settings.
 1. Edit [`values.yaml`](../charts/aspenmesh-demo/charts/frontend/values.yaml) in the `frontend` chart, and set the hostname for the demo site.

#### Step 4: Run Terraform plan

There is a limitation with the Kubernetes (and Helm) provider that requires manual plans and applies.  The Kubernetes provider requires an existing cluster to fetch metadata for Kubernetes manifests and Helm charts.  Therefore, you have to create the cluster first, and then deploy all of the workloads.

To accomplish this, use the `target` argument for the `terraform plan` command:

```shell script
terraform plan -target="module.aws_vpc"
terraform plan -target="module.eks_cluster"
terraform plan -target="module.istio"
terraform plan -target="module.integrations"
terraform plan -target="module.demo_site"
```

In the future we will create separate Terraform configurations using data sources for the Kubernetes context so that you can simply run `terraform plan` in each configuration.

#### Step 5: Run Terraform apply

As with Step 4, there is a limitation with the Kubernetes (and Helm) provider that requires manual plans and applies.  The Kubernetes provider requires an existing cluster to fetch metadata for Kubernetes manifests and Helm charts.  Therefore, you have to create the cluster first, and then deploy all of the workloads.

To accomplish this, use the `target` argument for the `terraform apply` command:

```shell script
terraform apply -target="module.aws_vpc"
terraform apply -target="module.eks_cluster"
terraform apply -target="module.istio"
terraform apply -target="module.integrations"
terraform apply -target="module.demo_site"
```
In the future we will create separate Terraform configurations using data sources for the Kubernetes context so that you can simply run `terraform apply` in each configuration.

#### Step 6: Run `update-kubeconfig` command

`~/.kube/config` file gets updated with cluster details and certificate from the below command.  This command is also an output after applying the configuration.

    $ aws eks --region <enter-your-region> update-kubeconfig --name <cluster-name>

#### Step 7: Test that everything is deployed

Forward the ports for the following workloads in `kubectl`:

|Namespace|Pod|Port|
|---------|---|----|
|istio-system|grafana-xxx|3000|
|istio-system|kiali-xxx|20001|
|frontend|frontend-xxx|8080|

And then open these URLs in a browser to make sure everything is deployed:

```shell script
open http://localhost:3000
open http://localhost:20001
open http://localhost:8080
```

You can create a CNAME DNS record for the hostname that you created in Step 3 to expose the demo site publicly.  The CNAME record should point to the ingress gateway's External IP value:

```shell script
kubectl get svc -n istio-system istio-ingressgateway | awk '{print $4}'

EXTERNAL-IP
a6d274b8802a94151978dc2df034e93a-506542154.us-east-2.elb.amazonaws.com
```

## How to Destroy

The following command destroys the resources created by `terraform apply`

```shell script
terraform destroy
```


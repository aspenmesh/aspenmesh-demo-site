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

Ensure that you have installed the following tools in your Mac or Windows Laptop before start working with this module and run Terraform Plan and Apply

1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
2. [Kubectl](https://Kubernetes.io/docs/tasks/tools/)
3. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### Deployment Steps

#### Step 1: Clone the repo using the command below

```shell script
git clone https://github.com/aspenmesh/aspenmesh-demo-sit.git
```

#### Step 2: Run Terraform Init

Initialize a working directory with configuration files

```shell script
terraform init
```
#### Step 3: Update variables

 1. Edit [`demo-site.auto.tfvars`](demo-site.auto.tfvars) and change the variables to appropriate settings.
 1. Edit [`values.yaml`](../charts/aspenmesh-demo/charts/frontend/values.yaml) in the `frontend` chart, and set the hostname for the demo site.
 2. 
#### Step 4: Run Terraform plan

Verify the resources created by this execution

```shell script
terraform plan
```

#### Step 5: Run Terraform apply

Create the resources

```shell script
terraform apply
```

Enter `yes` to apply

#### Step 6: Run `update-kubeconfig` command

`~/.kube/config` file gets updated with cluster details and certificate from the below command

    $ aws eks --region <enter-your-region> update-kubeconfig --name <cluster-name>

#### Step 7: Test that everything is deployed

Forward the ports for the following workloads in `kubectl`:

|Namespace|Pod|Port|
|---------|---|----|
|istio-system|grafana-xxx|3000|
|istio-system|kiali-xxx|20001|
|frontend|frontend-xxx|8080|

You should also be able to navigate to the demo site hostname set up in step 3.

## How to Destroy

The following command destroys the resources created by `terraform apply`

```shell script
terraform destroy
```


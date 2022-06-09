output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = module.eks_cluster.configure_kubectl
}

output "kubernetes_host" {
  description = "Kubernetes endpoint"
  value = module.eks_cluster.eks_cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "The CA certificate for the cluster"
  value = module.eks_cluster.eks_cluster_certificate_authority_data
}

output "cluster_name" {
  description = "The name of the cluster"
  value = module.eks_cluster.eks_cluster_id
}
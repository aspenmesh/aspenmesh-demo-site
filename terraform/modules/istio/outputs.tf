output "ingress-url" {
  description = "The public URL of the Ingress Controller"
  value       = helm_release.istio-ingress
}
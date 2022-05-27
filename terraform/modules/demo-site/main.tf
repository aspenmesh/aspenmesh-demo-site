resource "helm_release" "boutique" {
  name       = "boutique"
  chart      = "../../charts/aspenmesh-demo"
}
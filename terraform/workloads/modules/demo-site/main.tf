resource "helm_release" "boutique" {
  name  = "boutique"
  chart = var.aspenmesh_demo_chart
}
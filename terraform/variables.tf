variable "tenant" {
  type        = string
  description = "Account Name or unique account unique id e.g., apps or management or aws007"
  default     = "aws"
}

variable "environment" {
  type        = string
  default     = "preprod"
  description = "Environment area, e.g. prod or preprod "
}

variable "zone" {
  type        = string
  description = "zone, e.g. dev or qa or load or ops etc..."
  default     = "dev"
}

variable "region" {
  type        = string
  description = "Region"
  default     = "us-west-2"
}

variable "aspenmesh_demo_chart" {
  type        = string
  description = "The relative path to the demo site Helm chart"
  default     = "../charts/aspenmesh-demo/"
}
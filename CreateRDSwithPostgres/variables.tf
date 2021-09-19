variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "db_password" {
  default     = "<********>"
  description = "RDS root user password"
  sensitive   = true
}

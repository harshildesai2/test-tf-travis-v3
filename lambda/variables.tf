variable "env_name" {
  description = "Environment name [dev, qa14, qa16, stage, prod]"
}

variable "code_bucket" {
  description = "s3 bucket name for code"
}

variable "jar_path" {
  description = "path of code jar in S3 s3 bucket"
}

variable "api_endpoint" {
  description = "Endpoint to the token api"
}

variable "api_password" {
  description = "Password for the token api"
}

variable "required_tags" {
  type = "map"
  description = "Tags to apply to all resources"
}

locals {
  required_tags = "${var.required_tags}"
}

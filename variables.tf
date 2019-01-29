variable "env_name" {
  description = "Environment name [dev, qa, stage, prod]"
}

variable "env_tag" {
  description = "Environment name for tagging [dev, qa, stg, prod]"
  default = ""
}

variable "code_bucket" {
  description = "S3 bucket name for code"
  default = "lll-responsys-consentmgt"
}

variable "jar_path" {
  description = "Path of code JAR in S3 bucket"
  default = "code/consentmgtapi-1.0.0-jar-with-dependencies.jar"
}

variable "api_endpoint" {
  description = "Endpoint to the token api"
}

variable "api_password" {
  description = "Password for the token api"
}


locals {
  required_tags = {
    "lll:deployment:terraform"      = "True"
    "lll:business:application-name" = "Subscriber Management"
    "lll:deployment:environment"    = "${var.env_tag == "" ? lower(var.env_name) : lower(var.env_tag)}"
  }
}

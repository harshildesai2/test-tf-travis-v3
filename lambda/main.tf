provider "aws" {
  version = "~> 1.54"
}

# Retrieve information about current region
data "aws_region" "current" {}

# Retrieve AWS account ID, user ID, etc
data "aws_caller_identity" "current" {}

data "aws_s3_bucket_object" "lambda" {
  bucket = "${var.code_bucket}"
  key    = "${var.jar_path}"
}

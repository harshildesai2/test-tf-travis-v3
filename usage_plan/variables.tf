variable "env_name" {
  description = "Environment name [dev, qa14, qa16, stage, prod]"
}

variable "api_resource_id" {
  description = "The Id for the API gateway resource"
}

variable "stage_name" {
  description = "the name of the stage"
}

variable "method_throttling" {
  type        = "list"
  description = "List of throttling settings for each method"
  default     = [
    "\\\"/getsubscriberinfo/POST\\\":{\\\"rateLimit\\\":30,\\\"burstLimit\\\":25}",
    "\\\"/getsubscriptionstatus/POST\\\":{\\\"rateLimit\\\":30,\\\"burstLimit\\\":25}"
  ]
}

variable "burst_limit" {
  description = "Burst limit. Default: 5000"
  default     = 5000
}

variable "rate_limit" {
  description = "Rate limit. Default: 10000"
  default     = 10000
}

locals {
  name_prefix = "${lower(var.env_name) == "prod" ? "consentmgt" : "consentmgt-${lower(var.env_name)}"}"
}

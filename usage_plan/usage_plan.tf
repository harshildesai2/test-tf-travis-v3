resource "aws_api_gateway_usage_plan" "api_usage_plan" {
  name        = "${local.name_prefix}-usage-plan"
  description = "The usage plan for the Consent Management API resources"

  api_stages {
    api_id = "${var.api_resource_id}"
    stage  = "${var.stage_name}"
  }

  throttle_settings {
    burst_limit = "${var.burst_limit}"
    rate_limit  = "${var.rate_limit}"
  }
}

resource "aws_api_gateway_api_key" "webkey" {
  name = "${local.name_prefix}-web-key"
}

resource "aws_api_gateway_usage_plan_key" "webkey_plan" {
  key_id        = "${aws_api_gateway_api_key.webkey.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.api_usage_plan.id}"
}

#installing CLI using the linux script
data "template_file" "install_script" {
  template = <<EOF
  set -e
  WORKDIR=/tmp/${uuid()}
  mkdir -p "$WORKDIR"
  cd "$WORKDIR"

  # Install AWS CLI if it's missing (inside Docker container when executed by TFE)
  AWSCLI_PATH=$(which aws || echo -n '')
  if [ -z "$AWSCLI_PATH" ]
  then
    curl -f "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
    unzip awscli-bundle.zip
    ./awscli-bundle/install -i "$WORKDIR"/aws
    AWSCLI_PATH="$WORKDIR"/aws/bin/aws
  fi

  EOF
}

# locals
locals {
  # Delimiter for later usage
  delimiter      = "'"

  # Base aws cli command
  base_command   = "apigateway update-usage-plan --usage-plan-id ${aws_api_gateway_usage_plan.api_usage_plan.id} --patch-operations op"

  # Later aws cli command
  base_path      = "path=/apiStages/${var.api_resource_id}:${var.stage_name}/throttle,value"

  # Join method throttling variable to string
  methods_string = "${local.delimiter}\"{${join(",", var.method_throttling)}}\"${local.delimiter}"

  # create command
  create_command = "${local.base_command}=add,${local.base_path}=${local.methods_string}"

  # edit command
  edit_command = "${local.base_command}=replace,${local.base_path}=${local.methods_string}"

  # delete command
  delete_command = "${local.base_command}=remove,${local.base_path}="

  # rendered CLI
  cli_rendered = "${data.template_file.install_script.rendered}"
}

data "template_file" "create" {
  template = <<EOF
  ${local.cli_rendered}
  "$AWSCLI_PATH" ${local.create_command}
  EOF
}

data "template_file" "edit" {
  template = <<EOF
  ${local.cli_rendered}
  "$AWSCLI_PATH" ${local.edit_command}
  EOF
}

data "template_file" "destroy" {
  template = <<EOF
  ${local.cli_rendered}
  "$AWSCLI_PATH" ${local.delete_command}
  EOF
}

resource "null_resource" "method_throttling" {
  count = "${length(var.method_throttling) != 0 ? 1 : 0}"

  # create method throttling
  provisioner "local-exec" {
    when       = "create"
    command    = "${data.template_file.create.rendered}"
    on_failure = "continue"
  }

  # edit method throttling
  provisioner "local-exec" {
    command    = "${data.template_file.edit.rendered}"
    on_failure = "fail"
  }

  # delete method throttling
  provisioner "local-exec" {
    when       = "destroy"
    command    = "${data.template_file.destroy.rendered}"
    on_failure = "fail"
  }

  triggers = {
    usage_plan_change = "${aws_api_gateway_usage_plan.api_usage_plan.id}"
    methods_change    = "${local.methods_string}"
  }

  depends_on = [
    "aws_api_gateway_usage_plan.api_usage_plan"
  ]
}
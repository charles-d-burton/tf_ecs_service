//Add log filters and have it call lambda function
resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_lambda_filter" {
  count           = "${var.enable_logs_function = true ? 1 : 0 }"
  name            = "ecs-filter-${var.service_name}"
  log_group_name  = "${var.log_group_path}/${var.service_name}"
  filter_pattern  = "${var.filter_pattern}"
  destination_arn = "${var.logs_function_arn}"
  depends_on      = ["aws_lambda_permission.allow_cloudwatch"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "null" {}

resource "random_pet" "name" {}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count          = "${var.enable_logs_function = true ? 1 : 0 }"
  statement_id   = "${random_pet.name.id}"
  action         = "lambda:InvokeFunction"
  function_name  = "${var.logs_function_name}"
  principal      = "logs.${var.region}.amazonaws.com"
  source_account = "${data.aws_caller_identity.current.account_id}"

  #source_arn     = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:ECS-${var.service_name}:*"
  source_arn = "${aws_cloudwatch_log_group.task_log.arn}:*"
}

resource "aws_iam_role" "iam_for_logging" {
  count              = "${var.enable_logs_function = true ? 1 : 0 }"
  name               = "logging_${var.service_name}"
  assume_role_policy = "${data.aws_iam_policy_document.cloudwatch_lambda_assume_role.json}"
}

resource "aws_iam_policy" "logging_policy" {
  count       = "${var.enable_logs_function = true ? 1 : 0 }"
  name        = "logging_policy_${var.service_name}"
  path        = "/logs/"
  description = "Policy to access cloudwatch logs for lambda forwarding"
  policy      = "${data.aws_iam_policy_document.logging_policy.json}"
}

resource "aws_iam_policy_attachment" "logging_attach" {
  count      = "${var.enable_logs_function = true ? 1 : 0 }"
  name       = "logging-attachment-${var.service_name}"
  policy_arn = "${aws_iam_policy.logging_policy.arn}"
  role       = "${aws_iam_role.iam_for_logging.name}"
}

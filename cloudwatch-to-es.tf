/*data "terraform_remote_state" "logs" {
  backend = "atlas"

  config {
    name = "gaia-engineering/${var.env}-us-west-2-logger"
  }
}

//Add log filters and have it call lambda function
resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_lambda_filter" {
  name            = "ecs-filter-${var.service_name}"
  log_group_name  = "ECS-${var.service_name}"
  filter_pattern  = ""
  destination_arn = "${data.terraform_remote_state.logs.lambda_to_es_arn}"
  depends_on      = ["aws_lambda_permission.allow_cloudwatch"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "null" {}

data "aws_caller_identity" "current" {
  # no arguments
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id   = "${random_pet.name.id}"
  action         = "lambda:InvokeFunction"
  function_name  = "${data.terraform_remote_state.logs.lambda_to_es_name}"
  principal      = "logs.${var.region}.amazonaws.com"
  source_account = "${data.aws_caller_identity.current.account_id}"
  source_arn     = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:ECS-${var.service_name}:*"
}

resource "aws_iam_role" "iam_for_es" {
  name = "es_${var.service_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "es_policy" {
  name        = "es_policy_${var.service_name}"
  path        = "/loggly/"
  description = "Policy to access cloudwatch logs for lambda to ES"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:Describe*",
        "logs:Get*",
        "logs:TestMetricFilter",
        "logs:FilterLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "autoscaling:Describe*",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "logs:Get*",
        "logs:Describe*",
        "logs:TestMetricFilter",
        "sns:Get*",
        "sns:List*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Resource": "${data.terraform_remote_state.logs.lambda_to_es_arn}"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "es_attach" {
  name       = "es-attachment-${var.service_name}"
  policy_arn = "${aws_iam_policy.es_policy.arn}"
  roles      = ["${aws_iam_role.iam_for_es.name}"]
}*/


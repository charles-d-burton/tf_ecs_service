data "aws_caller_identity" "current" {}

/* data "terraform_remote_state" "logger" {
  backend = "atlas"

  config {
    
  }
} */

resource "aws_cloudwatch_log_group" "task_log" {
  name              = "${var.log_group_name}"
  retention_in_days = "365"

  tags {
    Application = "${var.service_name}"
  }
}

/* resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_lambda_filter" {
  name            = "lambda-filter-${var.service_name}"
  log_group_name  = "ECS-${var.service_name}"
  filter_pattern  = ""
  destination_arn = "${data.terraform_remote_state.logger.lambda_to_es_arn}"
  depends_on      = ["aws_cloudwatch_log_group.task_log", "aws_lambda_permission.allow_cloudwatch"]

  lifecycle {
    create_before_destroy = true
  }
} */

resource "random_pet" "name" {}

/* resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id   = "${random_pet.name.id}"
  action         = "lambda:InvokeFunction"
  function_name  = "${data.terraform_remote_state.logger.lambda_to_es_name}"
  principal      = "logs.${var.region}.amazonaws.com"
  source_account = "${data.aws_caller_identity.current.account_id}"
  source_arn     = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:ECS-${var.service_name}:*"
} */

resource "aws_iam_policy" "ecs_service" {
  name   = "ecs-service-${var.service_name}"
  policy = "${data.aws_iam_policy_document.ecs_service.json}"
}

resource "aws_iam_policy" "task_policy" {
  name   = "ecs-task-${var.service_name}"
  policy = "${data.aws_iam_policy_document.task_policy.json}"
}

resource "aws_iam_role" "ecs_role" {
  name               = "tf-ecs-role-${var.service_name}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_role.json}"
}

resource "aws_iam_role" "task_role" {
  name               = "tf-task-${var.service_name}"
  assume_role_policy = "${data.aws_iam_policy_document.task_role.json}"
}

resource "aws_iam_policy_attachment" "ecs_attachment" {
  name       = "tf-ecs-attachment-${var.service_name}"
  policy_arn = "${aws_iam_policy.ecs_service.arn}"
  roles      = ["${aws_iam_role.ecs_role.name}"]
}

resource "aws_iam_policy_attachment" "task_attachment" {
  name       = "tf-ecs-attachment-${var.service_name}-task"
  policy_arn = "${aws_iam_policy.task_policy.arn}"
  roles      = ["${aws_iam_role.task_role.name}"]
}

#Will only attach a policy if set to true
resource "aws_iam_policy_attachment" "extra_task_attachment" {
  count      = "${var.add_task_policy}"
  name       = "tf-ecs-attachment-${var.service_name}-extra-task"
  policy_arn = "${var.task_policy_arn}"
  roles      = ["${aws_iam_role.task_role.name}"]
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "${var.service_name}"
  container_definitions = "${var.container_definition}"
  task_role_arn         = "${aws_iam_role.task_role.arn}"
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.service_name}"
  cluster         = "${var.cluster_name}"
  task_definition = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count   = "${var.desired_count}"

  #iam_role        = "${aws_iam_role.ecs-role.arn}"
}

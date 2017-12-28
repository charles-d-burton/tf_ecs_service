#Create the service policy for the service deployed into the ECS cluster
resource "aws_iam_policy" "ecs_service" {
  name   = "ecs-service-${var.service_name}"
  policy = "${data.aws_iam_policy_document.ecs_service.json}"
}

#Create the policy for the task assigned to the service
resource "aws_iam_policy" "task_policy" {
  name   = "ecs-task-${var.service_name}"
  policy = "${data.aws_iam_policy_document.task_policy.json}"
}

#Create the role to attache policis for the service to
resource "aws_iam_role" "ecs_role" {
  name               = "tf-ecs-role-${var.service_name}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_role.json}"
}

#Create the role for the tasks to assume
resource "aws_iam_role" "task_role" {
  name               = "tf-task-${var.service_name}"
  assume_role_policy = "${data.aws_iam_policy_document.task_role.json}"
}

#Attach ECS policy to ECS Role
resource "aws_iam_policy_attachment" "ecs_attachment" {
  name       = "tf-ecs-attachment-${var.service_name}"
  policy_arn = "${aws_iam_policy.ecs_service.arn}"
  role       = "${aws_iam_role.ecs_role.name}"
}

#Attache Task policy to Task role
resource "aws_iam_policy_attachment" "task_attachment" {
  name       = "tf-ecs-attachment-${var.service_name}-task"
  policy_arn = "${aws_iam_policy.task_policy.arn}"
  roles      = "${aws_iam_role.task_role.name}"
}

#Will only attach a policy if set to true
resource "aws_iam_policy_attachment" "extra_task_attachment" {
  count      = "${var.add_task_policy}"
  name       = "tf-ecs-attachment-${var.service_name}-extra-task"
  policy_arn = "${var.task_policy_arn}"
  roles      = "${aws_iam_role.task_role.name}"
}

#Policy for autoscaling
resource "aws_iam_policy" "autoscaling_policy" {
  count  = "${var.enable_autoscaling == true ? 1 : 0}"
  name   = "autoscaling-${var.service_name}"
  policy = "${data.aws_iam_policy_document.autoscaling_policy.json}"
}

resource "aws_iam_role" "autoscaling_role" {
  count              = "${var.enable_autoscaling == true ? 1 : 0}"
  name               = "tf-autoscalinng-${var.service_name}"
  assume_role_policy = "${data.aws_iam_policy_document.autoscaling_role.json}"
}

resource "aws_iam_policy_attachment" "autoscaling_attachment" {
  count      = "${var.enable_autoscaling == true ? 1 : 0}"
  name       = "tf-autoscaling-attachment-${var.service_name}"
  policy_arn = "${aws_iam_policy.autoscaling_policy.arn}"
  role       = "${aws_iam_role.autoscaling_role.name}"
}

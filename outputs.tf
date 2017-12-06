output "task_log_group_arn" {
  value = "${aws_cloudwatch_log_group.task_log.arn}"  
}

output "task_role_arn" {
  value = "${aws_iam_role.task_role.arn}"
}

output "task_role_name" {
  value = "${aws_iam_role.task_role.name}"
}

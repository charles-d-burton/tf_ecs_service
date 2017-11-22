variable "cluster_name" {
  type        = "string"
  description = "The ECS Cluster to deploy into"
}

//For more information see this: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
variable "container_definition" {
  type        = "string"
  description = "A JSON Document describing your task"
}

variable "service_name" {}

variable "desired_count" {}

variable "task_policy_arn" {
  default = ""
}

variable "add_task_policy" {
  default = false
}

variable "region" {
  type = "string"
}

variable "log_group_name" {
  type = "string"
  description = "cloudwatch log group name"
}

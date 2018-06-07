variable "add_task_policy" {
  default = false
}

variable "alb_arn" {
  description = "The ARN of the HTTP load balancer to attach to"
  type        = "string"
  default     = ""
}

variable "alb_security_group" {
  type        = "string"
  description = "The id of the security group to add a rule to"
}

variable "cluster_name" {
  type        = "string"
  description = "The ECS Cluster to deploy into"
}

variable "container_definition" {
  type        = "string"
  description = "A JSON Document describing your task"
}

variable "container_port" {
  description = "The port the container will listen on usually overridden in container definition"
  default     = 0
}

variable "deregistration_delay" {
  description = "The amount of time to drain connections before terminating containers"
  default     = 60
}

variable "desired_count" {
  description = "The number of containers you would like to run"
  default     = 1
}

variable "enable_autoscaling" {
  description = "Enable application autoscaling"
  default     = false
}

variable "enable_log_forwarding" {
  default     = false
  description = "Enable attaching lambda log forwarder to log stream"
}

variable "filter_pattern" {
  description = "Pattern used to filter out logs"
  default     = ""
}

variable "health_check_healthy_threshold" {
  default = 5
}

variable "health_check_interval" {
  default = 30
}

variable "health_check_matcher" {
  default = 200
}

variable "health_check_path" {
  default = "/"
}

variable "health_check_port" {
  default = "traffic-port"
}

variable "health_check_protocol" {
  default = "HTTP"
}

variable "health_check_timeout" {
  default = 5
}

variable "health_check_unhealthy_threshold" {
  default = 2
}

variable "listener_port" {
  description = "The port to attach to the load balancer listener"
  default     = 0
}

variable "log_forwarding_arn" {
  default     = ""
  description = "ARN of lambda function to attach to log stream"
}

variable "log_forwarding_name" {
  default     = ""
  description = "The name of the function being called"
}

variable "log_group_path" {
  type        = "string"
  description = "cloudwatch log group path"
}

variable "max_containers" {
  description = "The maximum number of containers to scale to"
  default     = 20
}

variable "max_log_retention" {
  description = "The number of days to retain logs"
  default     = "365"
}

variable "namespace_arn" {
  type        = "string"
  description = "service discovery namespace arn"
  default     = ""
}

variable "namespace_id" {
  type        = "string"
  description = "service discovery namespace id"
  default     = ""
}

variable "nlb_arn" {
  description = "The ARN of the TCP load balancer to attach to"
  type        = "string"
  default     = ""
}

variable "region" {
  type = "string"
}

variable "scale_in_adjustment" {
  description = "The number of containers to remove to scale in, must be negative number"
  default     = -2
}

variable "scale_in_cooldown" {
  description = "The sample rate intervale for autoscaling containers back in seconds"
  default     = 60
}

variable "scale_out_adjustment" {
  description = "The number of containers to scale during autoscaling"
  default     = 2
}

variable "scale_out_cooldown" {
  description = "The sample rate interval for autoscaling containers out in seconds"
  default     = 60
}

variable "sd_name" {
  type        = "string"
  description = "optionally used to override service_name as the service discovery name"
  default     = ""
}

variable "service_name" {
  description = "The name of thes service you are creating"
}

variable "stickiness_enabled" {
  description = "Enable or disable sticky cookies on the load balancer"
  default     = false
}

variable "task_policy_arn" {
  default = ""
}

variable "use_alb" {
  description = "Conditional to use an ALB vs NLB"
  default     = false
}

variable "use_load_balancer" {
  default = false
}

variable "use_nlb" {
  description = "Conditional to use an ALB vs NLB"
  default     = false
}

variable "vpc_id" {
  type        = "string"
  description = "The VPC to deploy into"
}

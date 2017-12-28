variable "cluster_name" {
  type        = "string"
  description = "The ECS Cluster to deploy into"
}

//For more information see this: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
variable "container_definition" {
  type        = "string"
  description = "A JSON Document describing your task"
}

variable "service_name" {
  description = "The name of thes service you are creating"
}

variable "desired_count" {
  description = "The number of containers you would like to run"
  default     = 1
}

variable "task_policy_arn" {
  default = ""
}

variable "add_task_policy" {
  default = false
}

variable "region" {
  type = "string"
}

#Set autoscaling variables
variable "enable_autoscaling" {
  description = "Enable application autoscaling"
  default     = false
}

variable "scale_out_adjustment" {
  description = "The number of containers to scale during autoscaling"
  default     = 2
}

variable "scale_out_cooldown" {
  description = "The sample rate interval for autoscaling containers out in seconds"
  default     = 60
}

variable "scale_in_adjustment" {
  description = "The number of containers to remove to scale in, must be negative number"
  default     = -2
}

variable "scale_in_cooldown" {
  description = "The sample rate intervale for autoscaling containers back in seconds"
  default     = 60
}

variable "max_containers" {
  description = "The maximum number of containers to scale to"
  deafult     = 20
}

####Define the load balancer if using one
variable "use_load_balancer" {
  default = false
}

variable "alb_arn" {
  description = "The ARN of the HTTP load balancer to attach to"
  type        = "string"
  default     = ""
}

variable "nlb_arn" {
  description = "The ARN of the TCP load balancer to attach to"
  type        = "string"
  default     = ""
}

variable "listener_port" {
  description = "The port to attach to the load balancer listener"
}

#Log group to drop logs into
variable "log_group_path" {
  type        = "string"
  description = "cloudwatch log group path"
}

#Enable log forwarding
variable "enable_logs_function" {
  default     = false
  description = "Enable attaching lambda log forwarder to log stream"
}

variable "logs_function_arn" {
  default     = ""
  description = "ARN of lambda function to attach to log stream"
}

variable "logs_function_name" {
  default     = ""
  description = "The name of the function being called"
}

variable "filter_pattern" {
  description = "Pattern used to filter out logs"
  defaule     = ""
}

variable "max_log_retention" {
  description = "The number of days to retain logs"
  default     = "365"
}

#Health checks for load balanced applications
variable "health_check_interval" {
  default = 30
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

variable "health_check_healthy_threshold" {
  default = 5
}

variable "health_check_unhealthy_threshold" {
  default = 2
}

variable "health_check_matcher" {
  default = 200
}

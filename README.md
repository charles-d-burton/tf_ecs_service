# tf-ecs-service
a `terraform` module that manages an ECS service

## Getting Started

### Non-load balanced service
```hcl
module "service" {
    source                = "git::git@github.com:Mindflash/tf-ecs-service?ref={version}"
    desired_count         = 1
    enable_log_forwarding = true
    env                   = "${var.env}"
    filter_pattern        = ""
    lock_table            = "${var.lock_table}"
    log_forwarding_arn    = "${data.terraform_remote_state.log_forwarding.arn}"
    log_forwarding_name   = "${data.terraform_remote_state.log_forwarding.name}"
    log_group_name        = "/aws/ecs/my-service-${var.env}"
    region                = "${var.region}"
    service_name          = "my-service-${var.env}"
}
```

### Load-balanced service
```hcl
module "service" {
    source  = "git::git@github.com:Mindflash/tf-ecs-service?ref={version}"
    desired_count = 2
    enable_log_forwarding = true
    logs_function_arn = "{arn_of_log_function}"
    logs_function_name = "{name_of_logging_function}"
    log_group_path = "/ecs/services/"
    use_load_balancer = true
    alb_arn = "{arn_of_loadbalancer}"
    listner_port = 8080
    region = "${var.region}"
    container_definition = "${data.template_file.container_definition.rendered}"
    cluster_name = "${var.cluster_name}"
    enable_autoscaling = true
}
```

## Variables
| variable                           | type   | description                                | default       |
| ---------------------------------- | :----: | :----------------------------------------- | ------------- |
| cluster_name                       | string | the name of the ecs cluster                |               |
| container_definition               | string | json container definition array            |               |
| region                             | string | aws region                                 |               |
| service_name                       | string | name of ECS service                        |               |
| desired_count                      | string | baseline container count                   |               |
| task\_policy_arn                   | string | arn of additional task policy              |               |
| add\_task_policy                   | bool   | set to enable additional task policy       | false         |
| enable_autoscaling                 | bool   | set to enable application scaling          | false         |
| scale\_out_adjustment              | int    | number of containers to add for scaling    | 2             |
| scale\_in_adjustement              | int    | negative number of containers to remove    | -2            |
| scale\_in_cooldown                 | int    | time window for autoscaling in             | 60            |
| scale\_out_cooldown                | int    | time window for autoscaling out            | 60            |
| max_containers                     | int    | maximum number of containers to scale to   | 20            |
| use\_load_balancer                 | bool   | whether or not to enable load balancing    | false         |
| alb_arn                            | string | arn of ALB to attach to                    |               |
| nlb_arn                            | string | arn of NLB to attach to                    |               |
| listener_port                      | int    | port to assign to listener on LB           |               |
| log\_group_path                    | string | path for cloudwatch logging                |               |
| enable\_logs_function              | bool   | enable log forwarding to lambda            | false         |
| logs\_function_arn                 | string | arn of function to attach to log stream    |               |
| logs\_function_name                | string | name of lambda function to forward logs    |               |
| filter_pattern                     | string | log forwarding subscription filter pattern | ""            |
| max\_log_retention                 | int    | maximum time to keep logs in days          | 365           |
| health\_check_interval             | int    | time between health checks                 | 30            |
| health\_check_path                 | string | path to health check                       | \"\/\"        |
| health\_check_port                 | string | port to container health check             | traffic\_port |
| health\_check_protocol             | string | protocol for health check                  | HTTP          |
| health\_check_timeout              | int    | seconds before health check timeout        | 5             |
| health\_check\_healthy_threshold   | int    | number of checks for healthy status        | 5             |
| health\_check\_unhealthy_threshold | int    | number of failures for unhealthy status    | 2             |
| health\_check_matcher              | int    | http status code to match health check     | 200           |

## Outputs
| name                  | type   | description                       |
| --------------------- | :----: | --------------------------------- |
| task\_role_arn        | string | arn of iam role used by ECS task  |
| task\_role_name       | string | name of iam role used by ECS task |
| task\_log\_group\_arn | string | arn of created log group          |

## License
**Apache V2**
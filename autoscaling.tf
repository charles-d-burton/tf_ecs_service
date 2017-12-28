resource "aws_appautoscaling_target" "service_target" {
  count              = "${var.enable_autoscaling == true ? 1 : 0}"
  max_capacity       = "${var.max_containers}"
  min_capacity       = "${var.desired_count}"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  role_arn           = "${aws_iam_role.autoscaling_role.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "service_down_policy" {
  count                   = "${var.enable_autoscaling == true ? 1 : 0}"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = "${var.scale_in_cooldown}"
  metric_aggregation_type = "Minimum"
  name                    = "scale-down-${var.service_name}"
  resource_id             = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  step_adjustment {
    metric_interval_upper_bound = 0
    scaling_adjustment          = "${var.scale_in_adjustment}"
  }

  depends_on = ["aws_appautoscaling_target.service_target"]
}

resource "aws_appautoscaling_policy" "service_up_policy" {
  count                   = "${var.enable_autoscaling == true ? 1 : 0}"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = "${var.scale_out_cooldown}"
  metric_aggregation_type = "Maximum"
  name                    = "scale-up-${var.service_name}"
  resource_id             = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = "${var.scale_out_adjustment}"
  }

  depends_on = ["aws_appautoscaling_target.service_target"]
}

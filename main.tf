#Create the log stream, all functions will need this
resource "aws_cloudwatch_log_group" "task_log" {
  name              = "${var.log_group_path}/${var.service_name}"
  retention_in_days = "${var.max_log_retention}"

  tags {
    Application = "${var.service_name}"
  }
}

#Generate the the task definition for the service
resource "aws_ecs_task_definition" "task_definition" {
  family                = "${var.service_name}"
  container_definitions = "${var.container_definition}"
  task_role_arn         = "${aws_iam_role.task_role.arn}"
}

#Create the service and attach the task definition
resource "aws_ecs_service" "ecs_service" {
  count           = "${var.use_load_balancer ? 0 : 1}"
  name            = "${var.service_name}"
  cluster         = "${var.cluster_name}"
  task_definition = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count   = "${var.desired_count}"
}

#Create the target group for the http version of the service
resource "aws_alb_target_group" "target_group_http" {
  count    = "${var.use_alb ? 1 : 0}"
  name     = "${var.service_name}"
  port     = "${var.container_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    interval            = "${var.health_check_interval}"
    path                = "${var.health_check_path}"
    port                = "${var.health_check_port}"
    protocol            = "${var.health_check_protocol}"
    timeout             = "${var.health_check_timeout}"
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    matcher             = "${var.health_check_matcher}"
  }
}

#Create the HTTP listener bound to the internal load balancer
resource "aws_alb_listener" "front_end_http" {
  count             = "${var.use_alb ? 1 : 0}"
  load_balancer_arn = "${var.alb_arn}"
  port              = "${var.listener_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.target_group_http.arn}"
    type             = "forward"
  }
}

resource "aws_security_group_rule" "alb_sg_attach" {
  type              = "ingress"
  from_port         = "${var.listener_port}"
  to_port           = "${var.listener_port}"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${var.alb_security_group}"
}

#Create the service and attach the task definition
resource "aws_ecs_service" "ecs_service_alb" {
  count           = "${var.use_alb ? 1 : 0}"
  name            = "${var.service_name}"
  cluster         = "${var.cluster_name}"
  task_definition = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count   = "${var.desired_count}"

  depends_on = [
    "aws_alb_listener.front_end_http",
    "aws_ecs_task_definition.task_definition",
  ]

  load_balancer {
    target_group_arn = "${aws_alb_target_group.target_group_http.arn}"
    container_name   = "${var.service_name}"
    container_port   = "${var.container_port}"
  }
}

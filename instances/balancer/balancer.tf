variable name                { }
variable vpc_id              { }
variable subnet_ids          { }
variable check_path          { }
variable interval            { }
variable healthy_threshold   { }
variable unhealthy_threshold { }


resource "aws_security_group" "loadbalancer" {
  name        = "${var.name}-loadbalancer-sg"
  description = "${var.name}-loadbalancer-sg"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-loadbalancer"
  }
}

resource "aws_lb" "calendar" {
  name               = "${var.name}-calendar"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.loadbalancer.id}"]
  subnets            = "${split(",", var.subnet_ids)}"
}


resource "aws_lb_target_group" "calendar" {
  name     = "${var.name}-calendar"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  health_check {
    enabled             = true
    path                = "${var.check_path}"
    interval            = "${var.interval}"
    healthy_threshold   = "${var.healthy_threshold}"
    unhealthy_threshold = "${var.unhealthy_threshold}"
  }
}

resource "aws_lb_listener" "calendar" {
  load_balancer_arn = "${aws_lb.calendar.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.calendar.arn}"
  }
}

output target_group_arn { value = "${aws_lb_target_group.calendar.arn}" }

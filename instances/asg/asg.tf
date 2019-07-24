variable name             { }
variable ami_id           { }
variable vpc_id           { }
variable vpc_cidr         { }
variable instance_type    { }
variable subnet_ids       { }
variable key_name         { }
variable target_group_arn { }
variable max_size         { }
variable min_size         { }
variable desired_size     { }

resource "aws_security_group" "webserver" {
  name        = "${var.name}-webserver-sg"
  description = "${var.name}-webserver-sg"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-web"
  }
}


resource "aws_launch_configuration" "web" {
  name            = "${var.name}-calendar-web"
  image_id        = "${var.ami_id}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.webserver.id}"]
  key_name        = "${var.key_name}"
  user_data = <<-EOF
    #!/bin/bash
    bash /var/www/deploy.sh
    EOF
}

resource "aws_autoscaling_group" "calendar-web" {
  name                      = "${var.name}-calendar"
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  health_check_grace_period = 300
  desired_capacity          = "${var.desired_size}"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.web.name}"
  target_group_arns         = "${split(",", var.target_group_arn)}"
  vpc_zone_identifier       = "${split(",", var.subnet_ids)}"
  termination_policies      = ["OldestInstance"]
  tag {
    key = "Name"
    value = "${var.name}-Calendar-Web"
    propagate_at_launch = true
  }
}

variable name          { }
variable vpc_id        { }
variable vpc_cidr      { }
variable instance_type { }
variable db_pass       { }
variable db_user       { }
variable db_name       { }
variable subnet_id     { }

resource "aws_security_group" "rds-mysql" {
  name        = "${var.name}-mysql-sg"
  description = "${var.name}-mysql-sg"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
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
    Name = "${var.name}-mysql"
  }
}

resource "aws_db_instance" "mysql" {
  identifier             = "${var.name}-calendar"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "${var.instance_type}"
  name                   = "${var.db_name}"
  username               = "${var.db_user}"
  password               = "${var.db_pass}"
  parameter_group_name   = "default.mysql5.7"
  publicly_accessible    = false
  skip_final_snapshot    = true
  db_subnet_group_name   = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.rds-mysql.id}"]
}

output rds_endpoint { value = "${aws_db_instance.mysql.endpoint}" }

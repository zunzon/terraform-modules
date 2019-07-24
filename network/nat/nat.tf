
variable name          { }
variable vpc_id        { }
variable ami_id        { }
variable instance_type { }
variable subnet_id     { }
variable key_name      { }

resource "aws_security_group" "nat" {
  name        = "${var.name}-nat-sg"
  description = "${var.name}-nat-sg"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.name}-nat" }
}

resource "aws_instance" "nat" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(split(",", var.subnet_id), 0)}"
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  source_dest_check      = false
  tags                   = { Name = "${var.name}-NAT" }
}

output nat_id { value = "${aws_instance.nat.id}"}
output nat_ip { value = "${aws_instance.nat.public_ip}"}

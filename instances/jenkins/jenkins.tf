variable name          { }
variable vpc_id        { }
variable vpc_cidr      { }
variable ami_id        { }
variable instance_type { }
variable key_name      { }
variable sg_ips        { }
variable ssh_ips       { }
variable subnet_id     { }


resource "aws_security_group" "jenkins" {
  name           = "${var.name}-jenkins-sg"
  description    = "${var.name}-jenkins-sg"
  vpc_id         = "${var.vpc_id}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = "${split(",", var.sg_ips)}"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = "${split(",", var.ssh_ips)}"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${split(",", var.ssh_ips)}"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${split(",", var.vpc_cidr)}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-jenkins"
  }
}


resource "aws_instance" "jenkins" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(split(",", var.subnet_id), 0)}"
  vpc_security_group_ids = ["${aws_security_group.jenkins.id}"]
  tags = {
    Name = "${var.name}-Jenkins"
  }
}

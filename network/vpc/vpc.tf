variable "name"     { }
variable "vpc_cidr" { }

resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
      Name = "${var.name}"
  }
}

output "vpc_id"   { value = "${aws_vpc.default.id}" }
output "vpc_cidr" { value = "${aws_vpc.default.cidr_block}" }

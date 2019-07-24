variable name               { }
variable vpc_id             { }
variable availability_zones { }
variable cidrs              { }
variable nat_id             { }

resource "aws_subnet" "private" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${element(split(",", var.cidrs), count.index)}"
  map_public_ip_on_launch = false
  availability_zone       = "${element(split(",", var.availability_zones), count.index)}"
  count                   = "${length(split(",", var.cidrs))}"
  tags                    = { Name = "${var.name}.${element(split(",", var.availability_zones), count.index)}" }
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${var.nat_id}"
  }

  tags = { Name = "${var.name}" }
}

resource "aws_route_table_association" "private" {
  count          = "${length(split(",", var.cidrs))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_db_subnet_group" "mysql" {
  name       = "${var.name}"
  subnet_ids = "${aws_subnet.private.*.id}"

  tags = { Name = "${var.name}-db-subnet" }
}


output subnet_ids { value = "${join(",", aws_subnet.private.*.id)}" }
output db_subnet_id { value = "${join(",", aws_db_subnet_group.mysql.*.id)}" }

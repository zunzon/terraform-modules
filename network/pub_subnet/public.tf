variable name               { }
variable vpc_id             { }
variable availability_zones { }
variable cidrs              { }

resource "aws_internet_gateway" "public" {
  vpc_id = "${var.vpc_id}"

  tags = { Name = "${var.name}" }
}

resource "aws_subnet" "public" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${element(split(",", var.cidrs), count.index)}"
  map_public_ip_on_launch = true
  availability_zone       = "${element(split(",", var.availability_zones), count.index)}"
  count                   = "${length(split(",", var.cidrs))}"
  tags                    = { Name = "${var.name}.${element(split(",", var.availability_zones), count.index)}" }
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags = { Name = "${var.name}" }
}

resource "aws_route_table_association" "public" {
  count          = "${length(split(",", var.cidrs))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

output "subnet_ids" { value = "${join(",", aws_subnet.public.*.id)}" }

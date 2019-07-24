variable name               { }
variable vpc_cidr           { }
variable public_subnets     { }
variable private_subnets    { }
variable availability_zones { }
variable nat_ami            { }
variable nat_instance_type  { }
variable key_name           { }

module "vpc" {
  source = "./vpc"

  name     = "${var.name}"
  vpc_cidr = "${var.vpc_cidr}"
}

module "private_subnet" {
  source = "./priv_subnet"

  name               = "${var.name}-private"
  vpc_id             = "${module.vpc.vpc_id}"
  cidrs              = "${var.private_subnets}"
  availability_zones = "${var.availability_zones}"
  nat_id             = "${module.nat.nat_id}"
}

module "public_subnet" {
  source = "./pub_subnet"

  name               = "${var.name}-public"
  vpc_id             = "${module.vpc.vpc_id}"
  cidrs              = "${var.public_subnets}"
  availability_zones = "${var.availability_zones}"
}

module "nat" {
  source = "./nat"

  name           = "${var.name}"
  vpc_id         = "${module.vpc.vpc_id}"
  ami_id         = "${var.nat_ami}"
  instance_type  = "${var.nat_instance_type}"
  subnet_id      = "${module.public_subnet.subnet_ids}"
  key_name       = "${var.key_name}"
}

output vpc_id             { value = "${module.vpc.vpc_id}" }
output vpc_cidr           { value = "${module.vpc.vpc_cidr}" }
output public_subnet_ids  { value = "${module.public_subnet.subnet_ids}" }
output private_subnet_ids { value = "${module.private_subnet.subnet_ids}" }
output nat_id             { value = "${module.nat.nat_id}"}
output nat_ip             { value = "${module.nat.nat_ip}" }
output db_subnet_id       { value = "${module.private_subnet.db_subnet_id}" }

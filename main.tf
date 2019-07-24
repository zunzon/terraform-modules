variable name                       { }
variable vpc_cidr                   { }
variable public_subnets             { }
variable private_subnets            { }
variable availability_zones         { }
variable nat_ami                    { }
variable nat_instance_type          { }
variable jenkins_id_ami             { }
variable jenkins_instance_type      { }
variable private_key_path           { }
variable jenkins_security_group_ips { }
variable jenkins_ssh_ip             { }
variable rds_instance_type          { }
variable rds_password               { }
variable rds_username               { }
variable rds_dbname                 { }
variable alb_check_path             { }
variable alb_unhealthy_threshold    { }
variable alb_healthy_threshold      { }
variable alb_interval               { }
variable aws_region                 { }
variable webserver_ami_id           { }
variable webserver_instance_type    { }
variable asg_max_size               { }
variable asg_min_size               { }
variable asg_desired_size           { }

terraform {
  backend "s3" {
    bucket = "btsol-tf-states"
    key    = "example.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = "${var.aws_region}"
}

module "network" {
  source = "./network"

  name               = "${var.name}"
  vpc_cidr           = "${var.vpc_cidr}"
  public_subnets     = "${var.public_subnets}"
  private_subnets    = "${var.private_subnets}"
  availability_zones = "${var.availability_zones}"
  nat_ami            = "${var.nat_ami}"
  nat_instance_type  = "${var.nat_instance_type}"
  key_name           = "${module.instances.key_name}"
}

module "instances" {
  source = "./instances"

  name                       = "${var.name}"
  vpc_id                     = "${module.network.vpc_id}"
  vpc_cidr                   = "${var.vpc_cidr}"
  public_subnet_id           = "${module.network.public_subnet_ids}"
  private_subnet_id          = "${module.network.private_subnet_ids}"
  jenkins_id_ami             = "${var.jenkins_id_ami}"
  jenkins_instance_type      = "${var.jenkins_instance_type}"
  private_key_path           = "${var.private_key_path}"
  jenkins_security_group_ips = "${var.jenkins_security_group_ips}"
  jenkins_ssh_ip             = "${var.jenkins_ssh_ip}"
  rds_instance_type          = "${var.rds_instance_type}"
  rds_password               = "${var.rds_password}"
  rds_username               = "${var.rds_username}"
  rds_dbname                 = "${var.rds_dbname}"
  db_subnet_id               = "${module.network.db_subnet_id}"
  alb_check_path             = "${var.alb_check_path}"
  alb_unhealthy_threshold    = "${var.alb_unhealthy_threshold}"
  alb_healthy_threshold      = "${var.alb_healthy_threshold}"
  alb_interval               = "${var.alb_interval}"
  webserver_ami_id           = "${var.webserver_ami_id}"
  webserver_instance_type    = "${var.webserver_instance_type}"
  asg_max_size               = "${var.asg_max_size}"
  asg_min_size               = "${var.asg_min_size}"
  asg_desired_size           = "${var.asg_desired_size}"
}

output nat_ip       { value = "${module.network.nat_ip}" }
output rds_endpoint { value = "${module.instances.rds_endpoint}" }

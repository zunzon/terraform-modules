variable name                       { }
variable vpc_id                     { }
variable vpc_cidr                   { }
variable public_subnet_id           { }
variable private_subnet_id          { }
variable jenkins_id_ami             { }
variable jenkins_instance_type      { }
variable private_key_path           { }
variable jenkins_security_group_ips { }
variable jenkins_ssh_ip             { }
variable rds_instance_type          { }
variable rds_password               { }
variable rds_username               { }
variable rds_dbname                 { }
variable db_subnet_id               { }
variable alb_check_path             { }
variable alb_unhealthy_threshold    { }
variable alb_healthy_threshold      { }
variable alb_interval               { }
variable webserver_ami_id           { }
variable webserver_instance_type    { }
variable asg_max_size               { }
variable asg_min_size               { }
variable asg_desired_size           { }

module "keypair" {
  source = "./keypair"

  name     = "${var.name}"
  key_path = "${var.private_key_path}"
}

module "jenkins" {
  source = "./jenkins"

  name          = "${var.name}"
  vpc_id        = "${var.vpc_id}"
  ami_id        = "${var.jenkins_id_ami}"
  instance_type = "${var.jenkins_instance_type}"
  subnet_id     = "${var.public_subnet_id}"
  key_name      = "${module.keypair.key_pair_name}"
  sg_ips        = "${var.jenkins_security_group_ips}"
  ssh_ips       = "${var.jenkins_ssh_ip}"
  vpc_cidr      = "${var.vpc_cidr}"
}

module "rds" {
  source = "./rds"

  name          = "${var.name}"
  vpc_id        = "${var.vpc_id}"
  vpc_cidr      = "${var.vpc_cidr}"
  instance_type = "${var.rds_instance_type}"
  db_pass       = "${var.rds_password}"
  db_user       = "${var.rds_username}"
  db_name       = "${var.rds_dbname}"
  subnet_id     = "${var.db_subnet_id}"
}

module "balancer" {
  source = "./balancer"

  name                = "${var.name}"
  vpc_id              = "${var.vpc_id}"
  subnet_ids          = "${var.public_subnet_id}"
  check_path          = "${var.alb_check_path}"
  interval            = "${var.alb_interval}"
  healthy_threshold   = "${var.alb_healthy_threshold}"
  unhealthy_threshold = "${var.alb_healthy_threshold}"
}

module "asg" {
  source = "./asg"

  name             = "${var.name}"
  vpc_id           = "${var.vpc_id}"
  vpc_cidr         = "${var.vpc_cidr}"
  ami_id           = "${var.webserver_ami_id}"
  instance_type    = "${var.webserver_instance_type}"
  subnet_ids       = "${var.private_subnet_id}"
  key_name         = "${module.keypair.key_pair_name}"
  max_size         = "${var.asg_max_size}"
  min_size         = "${var.asg_min_size}"
  desired_size     = "${var.asg_desired_size}"
  target_group_arn = "${module.balancer.target_group_arn}"
}

output key_name     { value = "${module.keypair.key_pair_name}" }
output rds_endpoint { value = "${module.rds.rds_endpoint}" }

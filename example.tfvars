#Rename this file to terraform.tfvars
name                       = "" # Unique name of your build
aws_region                 = "" # Your aws region
vpc_cidr                   = "" # CIDR of VPC
private_subnets            = "" # Private subnets CIDRs
public_subnets             = "" # Publlic Subnets CIDRs
availability_zones         = "" # Availability Zones (min 2)
nat_ami                    = "" # AMI ID for NAT instance
nat_instance_type          = "" # Instance type for NAT (example: t2.micro)
jenkins_id_ami             = "" # AMI ID for Jenkins instance
jenkins_instance_type      = "" # Instance type for Jenkins (example: t2.micro)
private_key_path           = "" # Path for public key, will be used to create key pair in AWS
jenkins_security_group_ips = "" # IPs for github webhooks
jenkins_ssh_ip             = "" # Your IP with /32 mask, will be used to whitelist you for ssh on created instances
rds_instance_type          = "" # Instance type for RDS (example: db.t2.micro)
rds_password               = "" # Root password for RDS instance
rds_username               = "" # Username for RDS instance
rds_dbname                 = "" # Database name for RDS isntance
alb_check_path             = "" # Health check path, which will be used by target groups (example: /users/sign_in)
alb_unhealthy_threshold    = "" # Number of checks, before target group will decide that target is unhealthy
alb_healthy_threshold      = "" # Number of checks, before target group will decide that target is healthy
alb_interval               = "" # Interval of target group health check (example: 30)
webserver_ami_id           = "" # AMI ID for webserver instance
webserver_instance_type    = "" # Instance type for Webserver (example: t2.micro)
asg_max_size               = "" # Max amount of instances of autoscaling group
asg_min_size               = "" # Min amount of instances of autoscaling group
asg_desired_size           = "" # Desired amount of isntances of autoscaling group

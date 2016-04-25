# name of project (also used as hostname)
#
name   = "www"
domain = "example.com"
passwd = "examplepassword"   # password for root user for Virtualmin

# AWS region where infra and host bootstraped
#
region = "us-east-1"

# paths to public and private ssh keys
#
site_public_key_path  = "~/.ssh/aws_infra.pem.pub"
site_private_key_path = "~/.ssh/aws_infra.pem"

# type of EC2 instance for host
#
instance_type = "t2.micro"
instance_disk = "30"

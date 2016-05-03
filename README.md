## AWS EC2 instance with Webmin/Virtualmin by Terraform

Create AWS resources and EC2 instance with Webmin/Virtulmin by [Terraform](http://terraform.io).

- VPC with CIDR 10.20.0.0/16
- Subnet in VPC with CIDR block 10.20.30.0/24
- SSH Key pair with user defined public key
- Security group to allow traffic on ports (SSH, HTTP, HTTPS, 100000 for Webmin)
- EC2 instance in VPC
- Elastic IP linked to EC2 instance
- Resoure to config EC2 instance and install Webmin/Virtualmin

>NOTE: Terraform uses Centos7 AMI (**ami-6d1c2007**) for US-East-1 region (N.Virginia).
Choose other AMI ID if you want use other region (see `resource "aws_instance" "host"` in *host.tf*)

### Bootstrap EC2 instance

Set env variables with AWS credentials before start:
```
export AWS_ACCESS_KEY_ID="YOURACCESSKEYID"
export AWS_SECRET_ACCESS_KEY="YourSuperSecretAccessKeyForAWS"
export AWS_DEFAULT_REGION="us-east-1"
```

Perform steps:

- check/setup variables in **vars.tfvars** file
- perfom test `terraform plan -var-file=vars.tfvars`
- create AWS resources by `terraform apply -var-file=vars.tfvars`
- check terraform output and login to Wibmin UI with provided Login/Password

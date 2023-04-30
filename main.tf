provider "aws" {
  region = "us-east-1"
}
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  for_each = toset(["web1", "web2", "alb-ansible"])

  name = "instance-${each.key}"

  instance_type          = "t2.micro"
  key_name               = "ansible_tejas"
  monitoring             = false
  vpc_security_group_ids = ["sg-0a79bc87db0e1cbac","sg-063d6db51bb015e91"]
  ami 			 = "ami-0e54300850599e43c"
  subnet_id              = "subnet-0fb2a608ee517e54c"
associate_public_ip_address = "false"

  tags = {
    Terraform   = "true"
    app =	"ansible-tejas"
    Environment = "dev"
  }
}  
module "http_80_security-group" {
  version = "4.17.2"
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  name        = "anisble web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = "vpc-00fd59baa806f6c7f"
  #ingress_cidr_blocks = ["10.0.0.0/8"]
  ingress_cidr_blocks = ["34.229.94.7/32","73.215.214.228/32","10.0.102.132/32","23.30.116.205/32"]

}

module "ssh_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "4.17.2"

  ingress_cidr_blocks = ["34.229.94.7/32","10.0.102.132/32","73.215.214.228/32","23.30.116.205/32"]
  vpc_id      = "vpc-00fd59baa806f6c7f"
  description = "Security group for web-server with SSH  ports open within VPC"
  name        = "anisble SSH-server"
}



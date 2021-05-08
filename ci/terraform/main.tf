provider "aws" {
  region = "eu-west-1"
}

# This module will create an EKS-compliant VPC. Taken from https://learn.hashicorp.com/tutorials/terraform/eks.
module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = "tms_vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                          = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                 = "1"
  }
}

# This resource will create a security group for allowing inbound SSH access
resource "aws_security_group" "allow_inbound_ssh" {
  name   = "allow_inbound_ssh"
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "Allow inbound SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# This resource will create a security group for allowing inbound HTTP traffic on port 8080
resource "aws_security_group" "allow_inbound_http_8080" {
  name   = "allow_inbound_http_8080"
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "Allow inbound HTTP traffic on port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# This resource will create a private key for SSH
resource "tls_private_key" "pk" {
  algorithm = "RSA"
}

# This resource will save the private key created above to the local filesystem
resource "null_resource" "save_private_key" {
  provisioner "local-exec" {
    command = "rm -f ${local.private_key_filepath}"
  }
  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ${local.private_key_filepath}"
  }
  provisioner "local-exec" {
    command = "chmod 400 ${local.private_key_filepath}"
  }
}

# This resource will create an EC2 key pair using the private key created above
resource "aws_key_pair" "tms" {
  key_name   = "tms_key"
  public_key = tls_private_key.pk.public_key_openssh
}

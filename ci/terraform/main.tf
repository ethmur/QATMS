provider "aws" {
  region = "eu-west-1"
}



/* --------------- Local Variables --------------- */

locals {
  # This local variable controls where the SSH private key will be saved
  private_key_filepath = "${abspath(path.root)}/privatekey.pem"

  # This local variable controls the name of the EKS cluster
  eks_cluster_name = "eks-cluster"
}



/* --------------- Resources --------------- */

# This module will create a VPC with 3 private subnets and 3 public subnets. Taken from https://learn.hashicorp.com/tutorials/terraform/eks.
module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = "qavpc"
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

# This resource will create an IAM service role for EC2
resource "aws_iam_role" "ec2_service_role" {
  name = "ec2_service_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

# This resource will create an IAM instance profile for EC2 using the IAM role created above
resource "aws_iam_instance_profile" "ec2_profile" {
  name  = "ec2_profile"
  role = aws_iam_role.ec2_service_role.name
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
resource "aws_key_pair" "qa_key" {
  key_name   = "qa_key"
  public_key = tls_private_key.pk.public_key_openssh
}

# This resource will create an EC2 instance
resource "aws_instance" "ec2_jenkins" {
  ami                  = "ami-0943382e114f188e8"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.qa_key.key_name
  subnet_id            = module.vpc.public_subnets[0]
  tags = {
    Name = "Jenkins"
  }
  vpc_security_group_ids = [
    module.vpc.default_security_group_id,
    aws_security_group.allow_inbound_ssh.id,
    aws_security_group.allow_inbound_http_8080.id
  ]
}




/* --------------- Outputs --------------- */

# This is the filepath of the SSH private key
output "private_key_filepath" {
  value = local.private_key_filepath
}

# This is the public DNS name of the EC2 instance
output "ec2_jenkins_hostname" {
  value = aws_instance.ec2_jenkins.public_dns
}

# This resource will create an EKS cluster
module "eks" {
  source                                    = "terraform-aws-modules/eks/aws"
  cluster_name                              = local.eks_cluster_name
  cluster_version                           = "1.18"
  kubeconfig_aws_authenticator_command      = "aws"
  kubeconfig_aws_authenticator_command_args = ["eks", "get-token", "--cluster-name", local.eks_cluster_name]
  kubeconfig_name                           = "tms"
  map_roles = [
    {
      rolearn  = aws_iam_role.ec2_service_role.arn
      username = "Admin"
      groups   = ["system:masters"]
    }
  ]
  node_groups = [
    {
      name             = "eks_group"
      instance_type    = "t3.medium"
      desired_capacity = 2
      min_capacity     = 2
      max_capacity     = 3
      key_name         = aws_key_pair.tms.key_name
      tags = {
        Name = "EKSnode"
      }
    }
  ]
  subnets = module.vpc.public_subnets
  vpc_id  = module.vpc.vpc_id
  worker_additional_security_group_ids = [
    aws_security_group.allow_inbound_ssh.id
  ]
  write_kubeconfig = true
}

# Declaring the kubernetes provider is required, otherwise terraform will throw an error when it tries to create/update the eks cluster config map
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}

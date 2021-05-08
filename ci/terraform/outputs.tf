# This is the filepath of the SSH private key
output "private_key_filepath" {
  value = local.private_key_filepath
}

# This is the public DNS name of the EC2 instance
output "ec2_jenkins_hostname" {
  value = aws_instance.ec2_jenkins.public_dns
}

# This is the RDS cluster endpoint
output "rds_endpoint" {
  value = aws_db_instance.tms.endpoint
}

# This is the RDS cluster username
output "rds_username" {
  value = aws_db_instance.tms.username
}

# This is the RDS cluster password
output "rds_password" {
  value     = aws_db_instance.tms.password
  sensitive = true
}

# This is the EKS cluster name
output "eks_cluster_name" {
  value = module.eks.cluster_id
}

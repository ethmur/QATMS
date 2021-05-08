locals {
  # This local variable controls where the SSH private key will be saved
  private_key_filepath = "${abspath(path.root)}/privatekey.pem"

  # This local variable controls the name of the EKS cluster
  eks_cluster_name = "eks_cluster"

  # This local variable controls the RDS cluster port
  rds_port = 3306
}

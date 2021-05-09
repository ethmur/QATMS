# This resource will create a security group for the RDS cluster
resource "aws_security_group" "rds_cluster" {
  name   = "rds_cluster"
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "Allow inbound JDBC/ODBC access"
    from_port   = local.rds_port
    to_port     = local.rds_port
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
}

# This resource will create a database subnet group for RDS
resource "aws_db_subnet_group" "tms" {
  name       = "tms_subnet_group"
  subnet_ids = module.vpc.public_subnets
}

# This resource will generate a random password for RDS
resource "random_password" "rds" {
  length  = 16
  special = false
}

# This resource will create a MySQL RDS cluster
resource "aws_db_instance" "tms" {
  allocated_storage    = 10
  apply_immediately    = true
  db_subnet_group_name = aws_db_subnet_group.tms.name
  engine               = "mysql"
  identifier           = "tmsdb"
  instance_class       = "db.t3.micro"
  name                 = "tms"
  username             = "rdsuser"
  password             = random_password.rds.result
  port                 = local.rds_port
  skip_final_snapshot  = true
  storage_encrypted    = true
  vpc_security_group_ids = [
    aws_security_group.rds_cluster.id
  ]
}

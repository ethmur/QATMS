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
  name = "ec2_profile"
  role = aws_iam_role.ec2_service_role.name
}

# This resource will create an EC2 instance
resource "aws_instance" "ec2_jenkins" {
  ami                  = "ami-0943382e114f188e8"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.tms.key_name
  subnet_id            = module.vpc.public_subnets[0]
  vpc_security_group_ids = [
    module.vpc.default_security_group_id,
    aws_security_group.allow_inbound_ssh.id,
    aws_security_group.allow_inbound_http_8080.id
  ]
  tags = {
    Name = "Jenkins"
  }
}

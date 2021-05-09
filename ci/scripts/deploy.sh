#!/bin/bash

: '
    Description: This script deploys the TicketManagementSystem application and CI pipeline into AWS

    Prerequisites:
        - AWS credentials are properly configured in ~/.aws/credentials
        - Following software is installed:
            - Terraform
            - Ansible

    - Flow:
        1) Using terraform, deploy following infrastructure into AWS:
            - VPC with public and private subnets
            - Jenkins EC2 machine
            - RDS cluster
            - EKS cluster
        2) Using ansible, run the following actions:
            - On Jenkins EC2 machine:
                - Set environment variables
                - Install the following software:
                    - AWS CLI
                    - Java
                    - Maven
                    - Pip
                    - Jenkins
                    - kubectl
                - Configure kubectl
                - Start Jenkins service
                - Install Jenkins plugins
                - Create Jenkins jobs
'


# Configure the shell script to fail on error
set -e


SCRIPT_START_TIME=$(date -u +%s)


# Determine required filesystem paths
printf "\nDetermining filesystem paths...\n"
SELF_PATH=$(readlink -f ${0})
BASE_DIR=$(dirname $(dirname ${SELF_PATH}))
TERRAFORM_DIR=${BASE_DIR}/terraform
ANSIBLE_DIR=${BASE_DIR}/ansible
printf "Script filepath is ${SELF_PATH}\n"
printf "Base CI directory path is ${BASE_DIR}\n"
printf "Terraform directory path is ${TERRAFORM_DIR}\n"
printf "Ansible directory path is ${ANSIBLE_DIR}\n"


# Deploy terraform infrastructure
printf "\nDeploying terraform infrastructure...\n"
terraform -chdir=${TERRAFORM_DIR} init
terraform -chdir=${TERRAFORM_DIR} apply -auto-approve


# Retrieve terraform output values and other variables
printf "\nRetrieving terraform output values...\n"
AWS_REGION=$(aws configure get region)
PRIVATE_KEY_FILEPATH=$(terraform -chdir=${TERRAFORM_DIR} output -raw private_key_filepath)
EC2_JENKINS_HOSTNAME=$(terraform -chdir=${TERRAFORM_DIR} output -raw ec2_jenkins_hostname)
RDS_ENDPOINT=$(terraform -chdir=${TERRAFORM_DIR} output -raw rds_endpoint)
RDS_USERNAME=$(terraform -chdir=${TERRAFORM_DIR} output -raw rds_username)
RDS_PASSWORD=$(terraform -chdir=${TERRAFORM_DIR} output -raw rds_password)
EKS_CLUSTER_NAME=$(terraform -chdir=${TERRAFORM_DIR} output -raw eks_cluster_name)
printf "AWS region is ${AWS_REGION}\n"
printf "private_key_filepath is ${PRIVATE_KEY_FILEPATH}\n"
printf "ec2_jenkins_hostname is ${EC2_JENKINS_HOSTNAME}\n"
printf "rds_endpoint is ${RDS_ENDPOINT}\n"
printf "rds_username is ${RDS_USERNAME}\n"
printf "eks_cluster_name is ${EKS_CLUSTER_NAME}\n"


# Run ansible playbook
printf "\nRunning ansible playbook...\n"
ansible-playbook -v -i ${ANSIBLE_DIR}/inventory.yaml ${ANSIBLE_DIR}/playbook.yaml \
	-e aws_region=${AWS_REGION} \
	-e private_key_filepath=${PRIVATE_KEY_FILEPATH} \
	-e jenkins_server_hostname=${EC2_JENKINS_HOSTNAME} \
	-e db_endpoint=${RDS_ENDPOINT} \
        -e db_username=${RDS_USERNAME} \
        -e db_password=${RDS_PASSWORD} \
	-e eks_cluster_name=${EKS_CLUSTER_NAME}


# Print useful information for user
printf "\nJenkins URL: http://${EC2_JENKINS_HOSTNAME}:8080\n"


SCRIPT_END_TIME=$(date -u +%s)
SCRIPT_ELAPSED_TIME=$((${SCRIPT_END_TIME}-${SCRIPT_START_TIME}))
printf "\nScript finished in ${SCRIPT_ELAPSED_TIME} seconds\n\n"

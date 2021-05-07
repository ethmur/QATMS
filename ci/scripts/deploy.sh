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
                - Install jenkins, kubectl
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


# Retrieve terraform output values
printf "\nRetrieving terraform output values...\n"


SCRIPT_END_TIME=$(date -u +%s)
SCRIPT_ELAPSED_TIME=$((${SCRIPT_END_TIME}-${SCRIPT_START_TIME}))
printf "\nScript finished in ${SCRIPT_ELAPSED_TIME} seconds\n\n"

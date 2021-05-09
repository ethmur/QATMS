#!/bin/bash

: '
    Description: This script tears down the TicketManagementSystem application and CI pipeline from AWS (which previously should have been deployed into AWS by the deploy.sh script)
    Flow:
        1) Use kubectl to delete all kubernetes resources (pods, services, etc...) that were created outside of terraform
        2) Destroy any infrastructure that was created using terraform
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


# Retrieve terraform output values and other variables
printf "\nRetrieving terraform output values...\n"
EKS_KUBECONFIG_FILEPATH=${TERRAFORM_DIR}/$(terraform -chdir=${TERRAFORM_DIR} output -raw eks_kubeconfig_relative_filepath)
printf "eks_kubeconfig_filepath is ${EKS_KUBECONFIG_FILEPATH}\n"


# Delete kubernetes resources
printf "\nDeleting kubernetes resources...\n"
kubectl --kubeconfig ${EKS_KUBECONFIG_FILEPATH} delete all --all


# Destroy terraform infrastructure
printf "\nDestroying terraform infrastructure...\n"
terraform -chdir=${TERRAFORM_DIR} destroy -auto-approve


SCRIPT_END_TIME=$(date -u +%s)
SCRIPT_ELAPSED_TIME=$((${SCRIPT_END_TIME}-${SCRIPT_START_TIME}))
printf "\nScript finished in ${SCRIPT_ELAPSED_TIME} seconds\n\n"

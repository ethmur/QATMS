#!/bin/bash

: '
    Description: This script tears down the TicketManagementSystem application and CI pipeline from AWS (which previously should have been deployed into AWS by the deploy.sh script)
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


# Destroy terraform infrastructure
printf "\nDestroying terraform infrastructure...\n"
terraform -chdir=${TERRAFORM_DIR} destroy -auto-approve


SCRIPT_END_TIME=$(date -u +%s)
SCRIPT_ELAPSED_TIME=$((${SCRIPT_END_TIME}-${SCRIPT_START_TIME}))
printf "\nScript finished in ${SCRIPT_ELAPSED_TIME} seconds\n\n"
#!/bin/bash

: '
    Description: This script locally installs the following software:
        - AWS CLI
        - Terraform
        - Ansible
	- kubectl

    Author: Ethan Murad

    Note: This script only supports ubuntu.
'


# Configure the shell script to fail on error
set -e


SCRIPT_START_TIME=$(date -u +%s)


# Make sure package metadata is up-to-date
printf "\nUpdating package metadata...\n"
sudo apt-get update


# Install standard packages
printf "\nInstalling standard packages...\n"
sudo apt-get install gnupg software-properties-common apt-transport-https ca-certificates curl zip unzip -y


# Install AWS CLI
printf "\nInstalling AWS CLI...\n"
sudo apt-get install awscli -y


# Install Terraform
printf "\nInstalling terraform...\n"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get install terraform -y


# Install Ansible
printf "\nInstalling ansible...\n"
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible -y
# Install Ansible Jenkins plugin
sudo ansible-galaxy collection install community.general


# Install kubectl
printf "\nInstalling kubectl...\n"
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install kubectl -y


SCRIPT_END_TIME=$(date -u +%s)
SCRIPT_ELAPSED_TIME=$((${SCRIPT_END_TIME}-${SCRIPT_START_TIME}))
printf "\nScript finished in ${SCRIPT_ELAPSED_TIME} seconds\n\n"

#!/bin/bash

# This script locally installs the following software:
    # - AWS CLI
    # - Terraform
    # - Ansible
# Note: This script only supports ubuntu.

# Make sure package metadata is up-to-date
sudo apt-get update

# Install standard packages
sudo apt-get install gnupg software-properties-common curl zip unzip -y

# Install AWS CLI
sudo apt-get install awscli -y

# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get install terraform -y

# Install Ansible
sudo apt-get install ansible -y

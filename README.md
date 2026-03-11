# Terraform + Ansible Minikube EC2 setup

This repository provisions an AWS EC2 instance with Terraform, configures it with Ansible, and automates both steps through Jenkins.

## Structure

- `infra/`: Terraform for the EC2 instance, security group, and generated Ansible inventory
- `ansible/`: Host configuration for Docker, Minikube, `kubectl`, and Helm
- `Jenkinsfile`: CI/CD pipeline that runs Terraform and then Ansible

## Prerequisites

- AWS credentials available to Terraform and Jenkins
- An existing EC2 key pair in AWS
- Matching private key available locally or as a Jenkins file credential named `ec2-ssh-private-key`
- Terraform 1.5+
- Ansible installed on the machine or Jenkins agent that will run the playbook

## Local usage

1. Copy `infra/terraform.tfvars.example` to `infra/terraform.tfvars` and set your values, especially `key_name` for your existing AWS key pair.
2. Run Terraform.
3. Run Ansible after Terraform generates `infra/inventory.ini`.

```powershell
cd infra
terraform init
terraform apply -var-file="terraform.tfvars"

cd ../ansible
ansible-playbook playbook.yml
```

## Terraform backend

The backend is configured in `infra/backend.tf` to use S3 with DynamoDB locking. Ensure the S3 bucket and DynamoDB table exist before running `terraform init`.

## Jenkins usage

The `Jenkinsfile` expects:

- a Linux Jenkins agent with `terraform` and `ansible-playbook`
- AWS credentials already available in the Jenkins environment
- a Jenkins file credential named `ec2-ssh-private-key`

The pipeline provisions the instance, uses the Terraform-generated inventory, and then installs Minikube and Helm on the EC2 host.
# minikube-assignment

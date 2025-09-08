# SSH Session Policy

## Description

This policy includes rules designed to monitor SSH session activity. It tracks processes initiated during SSH sessions by generating a unique SSH session key to identify all related process activities.

## Installation

### 1. Configure Variables

Set up the required variables for your DataDog environment:

```bash
export TF_VAR_api_key=your-datadog-api-key
export TF_VAR_app_key=your-datadog-app-key
export TF_VAR_url=https://app.datadoghq.com  # or your regional URL
```

### 2. Deploy Policy

```bash
# Initialization
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

## Using Docker

For containerized deployments, you can use the provided Dockerfile:

```bash
# Initialization
docker run -it -v ./policies:/policies -w /policies/ssh-session \
-e TF_VAR_api_key=$TF_VAR_api_key \
-e TF_VAR_app_key=$TF_VAR_app_key \
-e TF_VAR_url=$TF_VAR_url \
hashicorp/terraform init

# Plan the deployment
docker run -it -v ./policies:/policies -w /policies/ssh-session \
-e TF_VAR_api_key=$TF_VAR_api_key \
-e TF_VAR_app_key=$TF_VAR_app_key \
-e TF_VAR_url=$TF_VAR_url \
hashicorp/terraform plan

# Apply the configuration
docker run -it -v ./policies:/policies -w /policies/ssh-session \
-e TF_VAR_api_key=$TF_VAR_api_key \
-e TF_VAR_app_key=$TF_VAR_app_key \
-e TF_VAR_url=$TF_VAR_url \
hashicorp/terraform apply
```

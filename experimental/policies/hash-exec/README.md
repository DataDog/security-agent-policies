# Hash-Exec Policy

## Description

This policy provides security rules designed to detect potential malware execution by computing hashes for every binary execution. The system generates events containing the hash values and subsequently creates security signals when these hashes match known malware signatures. A caching mechanism is implemented to reduce the volume of events and minimize performance impact.

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
terrafor init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

## Using Docker

For containerized deployments, you can use the provided Dockerfile:

```bash
# Build the container (optional)
docker build -t datadog/wp-policy-creator .

# Plan the deployment
docker run -it -w /policies/hash-exec \
-e TF_VAR_api_key=$TF_VAR_api_key \
-e TF_VAR_app_key=$TF_VAR_app_key \
-e TF_VAR_url=$TF_VAR_url \
datadog/wp-policy-creator terraform plan

# Apply the configuration
docker run -it -w /policies/hash-exec \
-e TF_VAR_api_key=$TF_VAR_api_key \
-e TF_VAR_app_key=$TF_VAR_app_key \
-e TF_VAR_url=$TF_VAR_url \
datadog/wp-policy-creator terraform plan
```

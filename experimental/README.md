# Workload Protection - Experimental Policies

This repository contains Terraform configurations designed to provide experimental security detection capabilities for **DataDog Workload Protection**. These policies help organizations implement advanced security monitoring and threat detection across their infrastructure.

## Overview

The Workload Protection Policy Creator enables security teams to create sophisticated detection rules and monitoring policies through Infrastructure as Code (IaC). Each policy is designed to address specific security use cases and threat vectors, providing comprehensive coverage across different attack scenarios.

⚠️ **Policy Deployment**: The Terraform configuration creates policies that are disabled by default. These policies will appear in the DataDog Workload Protection UI, where you can enable them and select which hosts to monitor.


## Policies Directory

The `/policies` folder contains individual security policies, with each subfolder representing a dedicated policy targeting a specific security use case.

### Available Policies

| Policy | Use Case | Description |
|--------|----------|-------------|
| `hash-exec` | Malware Detection | Monitors binary executions and generates alerts based on file hashes matching known malware signatures |
| `hash-open` | Malware Detection | Monitors newly created files and generates alerts based on file hashes matching known malware signatures |
| `bpfdoor` | BPFDoor execution detection | Detect BPFDoor malware execution by monitoring its behavioral patterns |

## Prerequisites

Before using these policies, ensure you have:

- **Terraform** (v1.0 or later) or **Docker**
- **DataDog Account** with Workload Protection enabled
- **API Credentials**:
  - DataDog API Key
  - DataDog Application Key

## Quick Start

### 1. Choose a Policy

Navigate to the specific policy folder you want to deploy.

### 2. Review Documentation

Each policy folder contains its own `README.md` with specific installation instructions, required variables, and usage examples.

### 3. Configure Variables

Set up the required variables for your DataDog environment:

```bash
export TF_VAR_api_key=your-datadog-api-key
export TF_VAR_app_key=your-datadog-app-key
export TF_VAR_url=https://app.datadoghq.com  # or your regional URL
```

### 4. Deploy Policy

```bash
cd policies/[policy-name]

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
# Initialization
docker run -it -v ./policies:/policies -w /policies/[policy-name] \
-e TF_VAR_api_key=$TF_VAR_api_key \
-e TF_VAR_app_key=$TF_VAR_app_key \
-e TF_VAR_url=$TF_VAR_url \
hashicorp/terraform init

# Plan the deployment
docker run -it -v ./policies:/policies -w /policies/[policy-name] \
-e TF_VAR_api_key=$TF_VAR_api_key \
-e TF_VAR_app_key=$TF_VAR_app_key \
-e TF_VAR_url=$TF_VAR_url \
hashicorp/terraform plan

# Apply the configuration
docker run -it -v ./policies:/policies -w /policies/[policy-name] \
-e TF_VAR_api_key=$TF_VAR_api_key \
-e TF_VAR_app_key=$TF_VAR_app_key \
-e TF_VAR_url=$TF_VAR_url \
hashicorp/terraform apply
```

## Important Notes

⚠️ **Experimental Nature**: These policies are experimental and should be thoroughly tested in non-production environments before deployment.

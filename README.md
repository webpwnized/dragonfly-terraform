```
    ____                               ______         ______                     ____                   
   / __ \_________ _____ _____  ____  / __/ /_  __   /_  __/__  ______________ _/ __/___  _________ ___ 
  / / / / ___/ __ `/ __ `/ __ \/ __ \/ /_/ / / / /    / / / _ \/ ___/ ___/ __ `/ /_/ __ \/ ___/ __ `__ \
 / /_/ / /  / /_/ / /_/ / /_/ / / / / __/ / /_/ /    / / /  __/ /  / /  / /_/ / __/ /_/ / /  / / / / / /
/_____/_/   \__,_/\__, /\____/_/ /_/_/ /_/\__, /    /_/  \___/_/  /_/   \__,_/_/  \____/_/  /_/ /_/ /_/ 
                 /____/                  /____/                                                         
```

# Dragonfly Project Documentation

## Overview

Welcome to the Dragonfly project documentation! Dragonfly is a comprehensive web-based application designed to collect metrics for measuring browser privacy impact. This document provides an overview of the project structure and instructions for setting up and deploying Dragonfly.

## Project Announcements

Stay updated with project announcements via [Twitter](https://twitter.com/webpwnized).

## TLDR

To quickly deploy Dragonfly on Google Cloud Platform (GCP), follow these steps:

```bash
git clone https://github.com/webpwnized/dragonfly-terraform.git
cd dragonfly-terraform/terraform
terraform plan
terraform apply
```

## Terraform

The `terraform/` directory contains Terraform configuration files for deploying Dragonfly on various cloud platforms. These files define resources such as cloud run services, network configurations, and IAM policies. Here's a brief overview of the key files:

- `cloud-run-service.tf`: Defines the main Cloud Run service.
- `network.tf`: Configures network settings such as subnets and firewall rules.
- `variables.tf`: Declares input variables used throughout the Terraform configuration.
- `provider.tf`: Specifies the cloud provider and its configuration.
- Other files: Define additional resources and configurations.

## Tools

The `.tools/` directory contains scripts for Git operations and project management.

## License

Dragonfly is licensed under the [GNU General Public License v3.0](LICENSE).

## Version

The current version of Dragonfly is specified in the `version` file.

## Directory Structure

```
.
├── LICENSE
├── README.md
├── version
├── terraform/
│   ├── artifact-registry-remote-repository.tf
│   ├── cloud-run-service-backend-service.tf
│   ├── cloud-run-service-cloud-armor-policy.tf
│   ├── cloud-run-service-forwarding-rule.tf
│   ├── cloud-run-service-network-endpoint-group.tf
│   ├── cloud-run-service-service-account.tf
│   ├── cloud-run-service-service-iam-member.tf
│   ├── cloud-run-service-subnet.tf
│   ├── cloud-run-service-target-http-proxy.tf
│   ├── cloud-run-service.tf
│   ├── cloud-run-service-url-map.tf
│   ├── network.tf
│   ├── outputs.tf
│   ├── project-services.tf
│   ├── provider.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   ├── variables.tf
│   └── variables.tf.CHANGEME
└── .tools/
    ├── git.sh
    └── push-development-branch.sh
```

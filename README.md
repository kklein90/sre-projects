# SRE Projects

2 of the scenarios presented are implemented in this repo. They should be run in the following order:

1. vpc-setup
2. hosting-a-web-application

Each project has its' own README.

**hosting-a-web-application** depends on some of the resources deployed in **vpc-setup**, including:

- VPC
- Subnet
- DNS domain

# Prerequisites

- An established AWS account is required.
- Permissions to deploy the included resources.
- A Github user account with access key, stored in an AWS SSM parameter (secureString) & named **github-key**

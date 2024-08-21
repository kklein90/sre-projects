# SRE Project - Hosting a Web Application

## Synopsis 

Create a web-based application that you can either host on localhost or host in the cloud, the choice is yours. You can either create your own application or use an off-the shelf application as the backend. The goal is to create the infrastructure as code that supports your application.

Acceptance Criteria

● Your web-based application should be reachable from your local browser ● Your application stack should be created with Infrastructure as Code (IaC) ● You should be able to cleanly deploy, update, or remove your application stack with a few commands

Bonus Points

Bonus points for:

● Hosting in the cloud

● Having multiple replicas

● Having a local domain

## Solution

This solution requires a VPC & associated resources to exist. This solution is NOT well-architected for cloud deployment as it's all in a single public subnet.

**DEPLOY**

```
cd tf/env/dev
terraform init
terraform plan  <-- inspect the output for accuracy
terraform apply --auto-approve  <-- we already inspected the output, so no need to prompt for approval to deploy
```

**DESTROY**

```
cd tf/env/dev
terraform destroy
```

### Description

This Terraform & Ansible deploy a basic Wordpress site & MySql server. As mentioned above, this is NOT a well-architected depoyment.

#### Terraform

This TF code requires VPC resources already exist. The following resources are deployed:

- 2 EC2 instances
- IAM role & instance profile to grant permissions to the instances
- 2 DNS entries in a pre-existing DNS Zone
- 2 Security Groups to permit inbound traffic on the EC2 instances

The EC2 instance code includes **user-data** scripts, which are run on first-boot in AWS. These scripts install Ansible & some other required packages, lookup Git credentials in a previousely created SSM Parameter, clone this Github repo & finally, run the Ansible code to configure the instances.

The TF has 3 outputs:

- web server public IP address
- db server public IP address
- Private SSH key to access the servers (shows as "sensitive", so must be explicitly displayed)

#### Ansible

There are 2 sets of playbooks, 1 for a web server & 1 for a DB server. They both follow the same format, install base packages, source in other playbooks, setup docker & docker compose, run docker-compose.

The web server playbook includes a wait task that will wait for the DB container to come online before deploying the web site.

Updating with Ansible:

- cd into ansible/linux/web
- update the hosts file in the playbook folder with the appropriate IP address from the Terraform output
- make any changes to the host code
- from your workstation, run ansible `ansible-playbook -i hosts sre-web-base.yml`

**Note** there is no hosts file in the DB playbook on purpose.

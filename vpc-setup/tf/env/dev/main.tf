terraform {
  ##  this back end would be used in a multi-user env to save state to an S3 bucket
  # backend "s3" {
  #   bucket         = "sre-projects-terraform-state"
  #   key            = "develop/vpc"
  #   region         = "us-east-1"
  #   profile        = "develop"
  #   dynamodb_table = "terraform-lock"
  # }

  ## local backend for demo purposes
  backend "local" {
    path = "state/terraform.tfstate"
  }

  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    dns = {
      source  = "hashicorp/dns"
      version = "3.2.4"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "develop" # use my local credentials with profile name 'develop', based on having multiple account creds configured
}

module "main-vpc" {
  source      = "../../modules/main-vpc"
  region      = "us-east-1"
  env         = "dev"
  account     = "Sandbox"
  vpc-01-name = "sreproject-dev"
  vpc-01-cidr = "10.1.0.0/16"
  az1         = "us-east-1a"
  az2         = "us-east-1b"
  az3         = "us-east-1c"
  ns-record   = "10.1.0.2"
}

output "vpc_id" {
  value = module.main-vpc.aws-vpc-id
}

output "vpc_cidr" {
  value = module.main-vpc.aws-vpc-cidr
}



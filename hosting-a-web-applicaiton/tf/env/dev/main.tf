terraform {
  ##  this back end would be used in a multi-user env to save state to an S3 bucket
  #   backend "s3" {
  #     bucket         = "sre-projects-terraform-state"
  #     key            = "develop/server"
  #     region         = "us-east-1"
  #     profile        = "develop"
  #     dynamodb_table = "terraform-lock"
  #   }

  ## local backend for demo purposes
  backend "local" {
    path = "state/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
  }
}


provider "aws" {
  region  = "us-east-1"
  profile = "develop"
}

module "server" {
  source        = "../../modules"
  env           = "dev"
  account       = "Sandbox"
  ami_id        = "ami-0c7217cdde317cfec" # ubuntu 22.04 LTS
  instance_type = "t3.micro"              # ..0104/hr
}

output "db-ip" {
  value = module.server.db_ip
}

output "web-ip" {
  value = module.server.web_ip
}

output "private-key" {
  value     = module.server.private-key
  sensitive = true
}

terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">= 3.8"
    }
  }
}

module "lambda_testing" {
    source                  = "./modules/lambda-testing"
    aws_region              = var.aws_region
    aws_profile             = var.aws_profile
    aws_credentials_path    = var.aws_credentials_path
}

data "aws_availability_zones" "available" {}

locals {
  name         = basename(path.cwd)
  region       = var.region

  vpc_cidr = var.cidr_block

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/Akshay-Durgade/aws-projects"
  }
}

module "vpc" {
  source = "github.com/Akshay-Durgade/iac-modules/modules/vpc"

  create_vpc                            = true
  
  name                                  = local.name
  cidr_block                            = local.vpc_cidr
  use_ipam_pool                         = var.use_ipam_pool
  enable_ipv6                           = var.enable_ipv6
  instance_tenancy                      = var.instance_tenancy
  enable_dns_hostnames                  = var.enable_dns_hostnames
  enable_dns_support                    = var.enable_dns_support
  enable_network_address_usage_metrics  = var.enable_network_address_usage_metrics
  vpc_tags                              = var.vpc_tags
  tags                                  = local.tags
  region                                = local.region
}
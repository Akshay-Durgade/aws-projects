data "aws_availability_zones" "available" {}

locals {
  name         = "${var.region}-${basename(path.cwd)}"
  cluster_name = coalesce(var.cluster_name, local.name)
  region       = var.region

  vpc_cidr = var.cidr_block

  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/Akshay-Durgade/aws-projects"
  }
}

module "vpc" {
  # source = "github.com/Akshay-Durgade/iac-modules/modules/vpc"
  source = "../../iac-modules/modules/vpc"

  create_vpc                            = true
  
  ### VPC Configuration
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

  ### Secondary CIDR Blocks
  secondary_cidr_blocks                 = var.secondary_cidr_blocks

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = false
  single_nat_gateway   = true
  # enable_dns_hostnames = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }

  public_dedicated_network_acl = true
  create_igw                   = false
  public_inbound_acl_rules = var.public_inbound_acl_rules

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}
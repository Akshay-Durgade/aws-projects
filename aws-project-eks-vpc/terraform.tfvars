create_vpc                            = true
region                                = "us-east-1"
cidr_block                            = "10.0.0.0/16"
use_ipam_pool                         = false
enable_ipv6                           = false
instance_tenancy                      = "default"
enable_dns_hostnames                  = true
enable_dns_support                    = true
enable_network_address_usage_metrics  = false
vpc_tags = {
  "Environment" = "Development" 
}

## Secondary CIDR Blocks
secondary_cidr_blocks = ["10.1.0.0/16", "10.2.0.0/16"]
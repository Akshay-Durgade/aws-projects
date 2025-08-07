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

public_inbound_acl_rules = [
  {
    rule_number = 100
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_block  = "0.0.0.0/0"
    rule_action = "allow"
  },
  {
    rule_number = 110
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_block  = "0.0.0.0/0"
    rule_action = "allow"
  },
  {
    rule_number = 120
    protocol    = "tcp"
    from_port   = 1024
    to_port     = 65535
    cidr_block  = "10.0.0.0/16"
    rule_action = "allow"
  }
]

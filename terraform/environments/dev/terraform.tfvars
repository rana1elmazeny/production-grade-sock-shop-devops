aws_region = "us-east-1"
vpc_cidr   = "10.0.0.0/16"

key_name = "sockshop-key"

my_ip = "41.33.136.51/32"

ami_id = "ami-020cba7c55df1f615"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

availability_zones = [
  "us-east-1a",
  "us-east-1b"
]

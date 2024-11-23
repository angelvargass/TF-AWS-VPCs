default_region="us-east-1"
instance_type="t2.micro"
vpc_name="main-vpc"
vpc_cidr="10.0.0.0/16"
private_rt_name="private-route-table"
public_rt_name="public-route-table"
public_subnets_cidr=["10.0.0.0/24", "10.0.1.0/24"]
private_subnets_cidr=["10.0.2.0/24", "10.0.3.0/24"]
module "vpc-setup" {
    source = "./modules/vpc"
    instance_type = var.instance_type
    vpc_name = var.vpc_name
    vpc_cidr = var.vpc_cidr
    private_rt_name = var.private_rt_name
    public_rt_name = var.public_rt_name
    public_subnets_cidr = var.public_subnets_cidr
    private_subnets_cidr = var.private_subnets_cidr
}
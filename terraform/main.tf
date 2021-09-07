module "vpc" {
  source = "./modules/vpc"
  resource_prefix = "windows_image"
  name = "default-vpc"
  cidr = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}

module "s3" {
  source = "./modules/s3"
  resource_prefix = "windows_image"
  name = "ami-config-bucket"
  allowed_role_arn_list = [] #TODO : Not implemented
  depends_on = [module.vpc]
}

module "scanner" {
  source = "./modules/scanner"
  resource-prefix = "windows_image"
  ami_config_bucket = module.s3.arn
  security_group_id = module.vpc.security_group_id
  subnet_id = module.vpc.private_subnet_arn
  sns_email_id = "sridhar.mundra@gmail.com" #TODO : Change me
  default_ami = "Windows_Server-20H2-English-Core-Base-2021.05.12"
  instance_type = "t3.large"
  approver_arn = "abc" #TODO : Change me
  inspection_frequency = "rate(1 day)"
  depends_on = [module.s3]
}
locals {
  subnet_tier1 = {
    "us-east-1a" = 0
    "us-east-1b" = 1
    "us-east-1c" = 2
  }
  subnet_tier2 = {
    "us-east-1a" = 10
    "us-east-1b" = 11
    "us-east-1c" = 22
  }
  subnet_tier3 = {
    "us-east-1a" = 100
    "us-east-1b" = 110
    "us-east-1c" = 220
  }
}
# module "vpcbastion" {
#   source = "../modules/vpc"

#   cidr         = "10.0.0.0/16"
#   name         = "Bastion"
#   subnet_tier1 = local.subnet_tier1
#   subnet_tier2 = local.subnet_tier2
# }

# module "lbbastion" {
#   source = "../modules/elb"

#   namelb            = "NLBBastion"
#   typelb            = "network"
#   internal          = false
#   subnet_public_ids = module.vpcbastion.subnet_id_public
#   vpcid             = module.vpcbastion.vpcid
# }

# module "sg" {
#   source = "../modules/sg"

#   vpcid      = module.vpcbastion.vpcid
#   namesg     = "allow-ssh"
#   depends_on = [module.vpcbastion]
# }

# module "acg-bastion" {
#   source = "../modules/asg"

#   nameec2           = "Bastion"
#   instance_type     = "t2.micro"
#   sg_id             = module.sg.sg_id
#   ssh_key_pair      = "theanh"
#   subnet_id_private = module.vpcbastion.subnet_id_private
#   targetgrouparn    = module.lbbastion.target_group_arn
#   depends_on        = [module.sg]
# }
module "vpcdev" {
  source = "../modules/vpc"

  cidr                 = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  name                 = "NonPROD"
  subnet_tier1         = local.subnet_tier1
  subnet_tier2         = local.subnet_tier2
  subnet_tier3         = local.subnet_tier3
  namecluster          = "DEV"
}
# module "vpcprod" {
#   source = "../modules/vpc"

#   cidr                 = "10.2.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#   name                 = "PROD"
#   subnet_tier1         = local.subnet_tier1
#   subnet_tier2         = local.subnet_tier2
#   subnet_tier3         = local.subnet_tier3
#   namecluster          = "PROD"
# }
module "eksdev" {
  source = "../modules/eks"

  namecluster        = "DEV"
  namenodegroup      = "node-general"
  allsubnetid        = module.vpcdev.subnet_id_all
  allsubnetprivateid = module.vpcdev.subnet_id_private
  k8sversion         = "1.21"
}
# module "eksprod" {
#   source = "../modules/eks"

#   namecluster        = "PROD"
#   namenodegroup      = "node-general1"
#   allsubnetid        = module.vpcprod.subnet_id_all
#   allsubnetprivateid = module.vpcprod.subnet_id_private
#   k8sversion         = "1.21"
# }

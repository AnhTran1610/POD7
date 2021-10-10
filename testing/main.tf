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

# ### BASTION ZONE

# module "vpcbastion" {
#   source = "../modules/vpc"

#   cidr                 = "10.0.0.0/16"
#   name                 = "Bastion"
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#   subnet_tier1         = local.subnet_tier1
#   subnet_tier2         = local.subnet_tier2
# }

# module "lbbastion" {
#   source = "../modules/elb"

#   namelb            = "NLBBastion"
#   typelb            = "network"
#   internal          = false
#   subnet_public_ids = module.vpcbastion.subnet_id_public
#   vpcid             = module.vpcbastion.vpcid
# }

# module "sg-bastion" {
#   source = "../modules/sg"

#   vpcid         = module.vpcbastion.vpcid
#   namesg        = "allow-ssh"
#   fport-ingress = 0
#   tport-ingress = 0

#   fport-egress = 0
#   tport-egress = 0
#   depends_on   = [module.vpcbastion]
# }

# module "acg-bastion" {
#   source = "../modules/asg"

#   nameec2           = "Bastion"
#   instance_type     = "t2.micro"
#   sg_id             = module.sg-bastion.sg_id
#   key_name          = "theanh"
#   subnet_id_private = module.vpcbastion.subnet_id_private
#   targetgrouparn    = module.lbbastion.target_group_arn
#   depends_on        = [module.sg-bastion]
# }
module "iam" {
  source = "../modules/iam"
}

### CREATE DEV ENVIRONMENT

module "vpcdev" {
  source = "../modules/vpc"

  cidr                 = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  name                 = "NonPROD"
  subnet_tier1         = local.subnet_tier1
  subnet_tier2         = local.subnet_tier2
  # subnet_tier3         = local.subnet_tier3
  namecluster = "DEV"
}
module "sg-eksdev" {
  source = "../modules/sg"

  vpcid         = module.vpcdev.vpcid
  namesg        = "EKSdev-securitygroup"
  fport-ingress = 0
  tport-ingress = 0
  cidringress   = ["0.0.0.0/0"]
  fport-egress  = 0
  tport-egress  = 0
  depends_on    = [module.vpcdev]
}
module "eksdev" {
  source = "../modules/eks"

  namecluster          = "DEV"
  iam_role_cluster_arn = module.iam.iam_role_cluster_arn
  iam_role_node_arn    = module.iam.iam_role_node_arn
  namenodegroup        = "node-general"
  # sg_id              = module.sg-eksdev.sg_id
  allsubnetid        = module.vpcdev.subnet_id_all
  allsubnetprivateid = module.vpcdev.subnet_id_private
  k8sversion         = "1.20"
  depends_on = [
    module.iam
  ]
}

# module "helmdev" {
#   source = "../modules/helm"

#   hosturl     = module.eksdev.cluster_endpoint
#   ca_cer      = module.eksdev.cluster_certificate_authority_data
#   clustername = module.eksdev.cluster_name
# }

# ### Create IAM Roles for Service Accounts
# data "tls_certificate" "this" {
#   url = module.eksdev.cluster_identity
# }

# resource "aws_iam_openid_connect_provider" "this" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
#   url             = module.eksdev.cluster_identity
# }

# data "aws_iam_policy_document" "sa_role_policy" {
#   statement {
#     sid     = "SA"
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:default:external-dns"]
#     }

#     principals {
#       identifiers = [aws_iam_openid_connect_provider.this.arn]
#       type        = "Federated"
#     }
#   }
# }

# resource "aws_iam_role" "iam_sa" {
#   assume_role_policy = data.aws_iam_policy_document.sa_role_policy.json
#   name               = "iam_service_account"
# }

# data "aws_iam_policy_document" "external_dns_policy" {
#   statement {
#     actions   = ["route53:ChangeResourceRecordSets"]
#     effect    = "Allow"
#     resources = ["arn:aws:route53:::hostedzone/*"]
#   }
#   statement {
#     actions = [
#       "route53:ListHostedZones",
#       "route53:ListResourceRecordSets",
#     ]
#     effect    = "Allow"
#     resources = ["*"]
#   }
# }
# ### Attach externalDNS-policy for IAM ServiceAccount
# resource "aws_iam_policy" "externalDnsPolicy" {
#   name   = "external-dns-policy"
#   policy = data.aws_iam_policy_document.external_dns_policy.json
# }
# resource "aws_iam_role_policy_attachment" "externalDnsPolicy" {
#   policy_arn = aws_iam_policy.externalDnsPolicy.arn
#   role       = aws_iam_role.iam_sa.name
# }

# ### CREATE PRODUCTION ENVIRONMENT

# module "vpcprod" {
#   source = "../modules/vpc"

#   cidr                 = "10.2.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#   name                 = "PROD"
#   subnet_tier1         = local.subnet_tier1
#   subnet_tier2         = local.subnet_tier2
#   # subnet_tier3         = local.subnet_tier3
#   namecluster = "PROD"
# }
# module "sg-eksprod" {
#   source = "../modules/sg"

#   vpcid         = module.vpcprod.vpcid
#   namesg        = "EKSprod-securitygroup"
#   fport-ingress = 0
#   tport-ingress = 0
#   cidringress   = ["0.0.0.0/0"]
#   fport-egress  = 0
#   tport-egress  = 0
#   depends_on    = [module.vpcprod]
# }
# module "eksprod" {
#   source = "../modules/eks"

#   namecluster          = "PROD"
#   iam_role_cluster_arn = module.iam.iam_role_cluster_arn
#   iam_role_node_arn    = module.iam.iam_role_node_arn
#   namenodegroup        = "node-general1"
#   allsubnetid          = module.vpcprod.subnet_id_all
#   allsubnetprivateid   = module.vpcprod.subnet_id_private
#   k8sversion           = "1.20"
#   depends_on = [
#     module.iam
#   ]
# }
# module "helmprod" {
#   source = "../modules/helm"

#   hosturl     = module.eksprod.cluster_endpoint
#   ca_cer      = module.eksprod.cluster_certificate_authority_data
#   clustername = module.eksprod.cluster_name
# }



# ## Create VPC Peering module ( TODO )
# resource "aws_vpc_peering_connection" "this" {
#   peer_vpc_id = module.vpcdev.vpcid
#   vpc_id      = module.vpcbastion.vpcid
#   auto_accept = true
#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }
#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }
#   tags = {
#     Name = "VPC Peering between Bastion and Dev"
#   }
# }
# resource "aws_route" "a" {
#   route_table_id            = module.vpcbastion.route_table_private_id
#   destination_cidr_block    = module.vpcdev.vpccidr
#   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
#   depends_on                = [module.vpcbastion]
# }
# # resource "aws_route" "b" {
# #   route_table_id            = module.vpcdev.route_table_public_id
# #   destination_cidr_block    = module.vpcbastion.vpccidr
# #   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
# #   depends_on                = [module.vpcdev]
# # }
# resource "aws_route" "c" {
#   route_table_id            = module.vpcdev.route_table_private_id
#   destination_cidr_block    = module.vpcbastion.vpccidr
#   vpc_peering_connection_id = aws_vpc_peering_connection.this.id
#   depends_on                = [module.vpcdev]
# }